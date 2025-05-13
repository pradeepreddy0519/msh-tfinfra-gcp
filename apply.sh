#!/bin/bash

set -e

# Set your project
PROJECT_ID=""
BUCKET_NAME=""
BACKEND_FILE="tf-modules/backend.tf"

echo "Setting GCP project..."
gcloud config set project $PROJECT_ID

# Check if bucket exists
if gsutil ls -b gs://${BUCKET_NAME} >/dev/null 2>&1; then
    echo "Bucket ${BUCKET_NAME} already exists. Skipping creation..."
else
    echo "Creating backend bucket ${BUCKET_NAME}..."
    cd statefile
    terraform init
    terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
    cd ..
fi

# Check and inject the bucket name into backend.tf (only if not already injected)
if grep -q "bucket_name" "$BACKEND_FILE"; then
    echo "Injecting bucket name into backend.tf..."
    sed -i "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
else
    echo "backend.tf already configured with bucket name."
fi

echo "Running Terraform init and apply for infrastructure..."
cd tf-modules
terraform init
terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "✅ Deployment complete!"
