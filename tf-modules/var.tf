##########################################
# Cloud_Function
##########################################
variable "env" {
  type = string
  default = "test"
}
variable "project_id" {
  type = string
}
variable "function_name" {
  type = string
  default = "hello-world"
}
variable "runtime" {
  type = string
  default = "python311"
}
variable "entry_point" {
  type = string
  default = "hello_world"
}
variable "region" {
  type = string
  default = "us-central1"
}
variable "bucket_name" {
  type = string
  default = "hello-world"
}
