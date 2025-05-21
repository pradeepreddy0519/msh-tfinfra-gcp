# **☁️ Google Cloud Function with Load Balancer (Terraform)**

This project demonstrates how to deploy a Python **Cloud Function (1st Gen)** on Google Cloud using Terraform, expose it via an **HTTP Load Balancer**, and manage infrastructure using **Terraform**.

**Prerequisites**:

Before getting started, ensure the following are completed:

**Google Cloud Setup**:
 1. A GCP Project must be created
 2. You must have Editor or Owner permissions.

---

**Required Tools**:

**Google Cloud SDK (gcloud)**: 
For authentication and interaction with GCP services. Install: https://cloud.google.com/sdk/docs/install

**Terraform**:
For infrastructure as code (IaC). Install: https://developer.hashicorp.com/terraform/downloads

**tflint & tfsec** (optional): For code quality and security scanning.

Terraform - Required for defining and deploying infrastructure as code.

**GCP Authentication (Using Service Account)**

1. Create a service account with the following roles (roles/editor, roles/storage.admin, roles/iam.serviceAccountUser)
   ```
    - Go to IAM & Admin > Service Accounts → Click “Create Service Account”
 
    - Fill in name → Click Continue → Assign roles (e.g., Editor) → Click Done
 
    - Go to Keys tab → Click “Add Key > Create New Key” → Choose JSON → Download key file
    ```
2. Export the path to your service account key file:
   ```
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-service-account.json"
   ```
3. Authenticate gcloud using the service account:
   ```
   gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
   gcloud config get-value project     # This command will extract the Project_ID
   ```
4. Set your GCP project:
   ```
   gcloud config set project YOUR_PROJECT_ID
   ```
5. Verify:
   ```
   gcloud auth list
   gcloud config list
   ```

** Enable the Required API's **
```
gcloud services enable compute.googleapis.com cloudfunctions.googleapis.com \
  run.googleapis.com networkservices.googleapis.com iam.googleapis.com \
  monitoring.googleapis.com logging.googleapis.com cloudbuild.googleapis.com \
  serviceusage.googleapis.com storage.googleapis.com storage-api.googleapis.com
```

---

   **🧠 Cloud Function Code**

   **main.py**
   ```
   def hello_world(request):
    return "Hello, World!"
   ```

   Responds only to the `Hello, World!` path.

---

##  Packaging the Function

```bash
zip -r main.py requirements.txt
```

---

## Folder Structure
```
├── statefile/                  # Creates the GCS bucket for backend state storage
│   ├── main.tf
│   └── output.tf
├── tf-stack/                   # Main infrastructure using modules
│   ├── backend.tf              # Backend block for remote state
│   ├── main.tf                 # Core module references
│   ├── output.tf
│   └── var.tf
├── modules/                    # Modules for individual resources
│   ├── cloudfunction/          # Cloud Function module
│   ├── load-balancer/          # Load Balancer module
│   └── storage/                # Storage module which holds the source code for cloud function
├── apply.sh                    # Script to deploy everything
├── destroy.sh                  # Script to destroy all resources
└── function.zip                # Source code for Cloud Function
```
---

**Script Descriptions**

apply.sh: Provisions for GCP infrastructure, including:
 - GCS bucket for holding the cloudfunction code
 - Cloud Functions
 - Load Balancer

destroy.sh:
 - Destroys all created infrastructure. You can use this when cleaning up.

secure.sh:
 - Runs code quality checks using tflint and security checks using tfsec.

---

**How to Execute**

Step 1: Configure Scripts:

Change the permissions for shell script (apply.sh, destroy.sh, secure.sh)
```
chmod +x apply.sh
chmod +x destroy.sh
chmod +x secure.sh
```
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

---

