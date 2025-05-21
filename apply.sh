#!/bin/bash

set -e

# Set your project
PROJECT_ID="your_project_id"
# Set a Unique name for Bucket creatiom
BUCKET_NAME="unique_name"
BACKEND_FILE="tf-stack/backend.tf"

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

    # OS-specific sed command
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS
        sed -i '' "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        # Linux
        sed -i "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
    elif [[ "$OS_TYPE" =~ "MINGW" || "$OS_TYPE" =~ "CYGWIN" || "$OS_TYPE" =~ "MSYS" ]]; then
        # Windows (Git Bash / Cygwin / MSYS)
        sed -i "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
    else
        echo "Unsupported OS: $OS_TYPE"
        exit 1
    fi
else
    echo "backend.tf already configured with bucket name."
fi

echo "Running Terraform init and apply for infrastructure..."
cd tf-stack
terraform init
terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "✅ Deployment complete!"
