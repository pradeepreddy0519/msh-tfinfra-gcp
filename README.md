Prerequisites
Before getting started, ensure you have the following tools installed and properly configured:

Google Cloud Setup:
 1. A GCP Project must be created
 2. You must have Editor or Owner permissions.
 3. Create a service account with the following roles (roles/editor, roles/storage.admin, roles/iam.serviceAccountUser)
 4. Download the JSON key for the service account.

Required Tools
Google Cloud SDK (gcloud): For authentication and interaction with GCP services.
Install: https://cloud.google.com/sdk/docs/install

Terraform: For infrastructure as code (IaC).
Install: https://developer.hashicorp.com/terraform/downloads

tflint & tfsec (optional): For code quality and security scanning.

Terraform - Required for defining and deploying infrastructure as code.

GCP Authentication (Using Service Account)
1. Export the path to your service account key file:
   ```
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-service-account.json"
   ```
2. Authenticate gcloud using the service account:
   ```
   gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
   ```
3. Set your GCP project:
   ```
   gcloud config set project YOUR_PROJECT_ID
   ```
4. Verify:
   ```
   gcloud auth list
   gcloud config list
   ```   

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

Script Descriptions
apply.sh:
Provisions for GCP infrastructure, including:
 - GCS bucket for Terraform state
 - Cloud Functions
 - Load Balancer

destroy.sh:
 - Destroys all created infrastructure. You can use this when cleaning up.

secure.sh:
 - Runs code quality checks using tflint and security checks using tfsec.

How to Execute

How to Execute
Step 1: Configure Scripts:
Update these variables at the top of each script (apply.sh, destroy.sh, secure.sh):
 ```
 PROJECT_ID="your-project-id"
 BUCKET_NAME="your-unique-bucket-name"
 ```
Step 2: Deploy Infrastructure:
 ```
 ./apply.sh
 ```
Once deployed, wait ~5 minutes and test:
 ```
curl -v http://<load_balancer_url>:80
```
Step 3: Run Security & Code Quality Checks:
```
./secure.sh
```
Step 4: Destroy Infrastructure:
Update PROJECT_ID and BUCKET_NAME again in destroy.sh and run:
```
./destroy.sh
```

