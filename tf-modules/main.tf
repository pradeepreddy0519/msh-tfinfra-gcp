module "gcs_bucket" {
  source                 = "../tf-resources/storage"
  project_id             = var.project_id
  region                 = var.region
  bucket_name            = var.bucket_name
  source_archive_object  = "../function.zip"
}


module "cloud_function" {
  source                = "../tf-resources/cloudfunction"
  project_id            = var.project_id
  region                = var.region
  function_name         = var.function_name
  runtime               = var.runtime
  entry_point           = var.entry_point  
  bucket_name           = module.gcs_bucket.bucket_name
  object_name           = module.gcs_bucket.object_name
  env                   = var.env
  depends_on            = [ module.gcs_bucket ]
}

module "lb" {
  source              = "../tf-resources/load-balancer"
  function_name       = module.cloud_function.function_name
  region              = var.region
  depends_on          = [ module.cloud_function ]
}


