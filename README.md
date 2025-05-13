Prerequisites
Before getting started, ensure you have the following tools installed and properly configured:

Google Cloud Setup:
 1. A GCP Project must be created
 2. You must have Editor or Owner permissions.
 3. Create a service account with the following roles (roles/editor, roles/storage.admin, roles/iam.serviceAccountUser)
 4. Download the JSON key for the service account.

Required Tools
Google Cloud SDK (gcloud) - Used to authenticate and interact with GCP services.

Terraform - Required for defining and deploying infrastructure as code.

## Folder Structure
```
├── statefile/                  # Creates the GCS bucket for backend state storage
│   ├── main.tf
│   └── output.tf
├── tf-modules/                 # Main infrastructure using modules
│   ├── backend.tf              # Backend block for remote state
│   ├── main.tf                 # Core module references
│   ├── output.tf
│   └── var.tf
├── tf-resources/               # Modules for individual resources
│   ├── cloudfunction/          # Cloud Function module
│   ├── load-balancer/          # Load Balancer module
│   └── storage/                # Storage module
├── apply.sh                    # Script to deploy everything
├── destroy.sh                  # Script to destroy all resources
└── function.zip                # Source code for Cloud Function
```

Scripts

apply.sh: This script provisions the GCP infrastructure. It will create a Cloud Storage Bucket to store the Terraform state. Set up Cloud Functions. Create a Load Balancer.

destroy.sh This script will destroy all resources created by deploy.sh. It is useful for cleaning up your GCP project after the infrastructure is no longer needed.

How to Execute

Step 1: Set the Project Name. For all scripts (apply.sh, destroy.sh), you will need to specify your project_name and bucket_name. You can set the project name by modifying the project_name and bucket_name variables in each script.

Update inside the script PROJECT_NAME="your-project-id" and BUCKET_NAME="unique_name"

Step 2: Running the Scripts Deploying the Infrastructure:

Run the apply.sh script to create the infrastructure:

./apply.sh

Wait for 5 minutes and run the command curl http://load_balancer_url

Destroying the Infrastructure:

When you're done and want to destroy the infrastructure, run the destroy.sh script:

./destroy.sh
