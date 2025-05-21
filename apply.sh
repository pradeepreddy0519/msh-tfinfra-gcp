#!/bin/bash

set -e

# Set your project
PROJECT_ID="your_project_id"
# Set a Unique name for Bucket creatiom
BUCKET_NAME="unique_bucket"
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
# Detect OS type
detect_os() {
    if command -v uname >/dev/null 2>&1; then
        OS_TYPE=$(uname | tr '[:upper:]' '[:lower:]')
        if [[ "$OS_TYPE" == "darwin" ]]; then
            echo "mac"
        elif [[ "$OS_TYPE" == "linux" ]]; then
            echo "linux"
        elif [[ "$OS_TYPE" == *"mingw"* || "$OS_TYPE" == *"msys"* || "$OS_TYPE" == *"cygwin"* ]]; then
            echo "windows"
        else
            echo "unknown"
        fi
    else
        # uname not found — assume Windows
        echo "windows"
    fi
}

OS=$(detect_os)

# Check and inject the bucket name into backend.tf (only if not already injected)
if grep -q "bucket_name" "$BACKEND_FILE"; then
    echo "Injecting bucket name into backend.tf..."

    case "$OS" in
        mac)
            sed -i '' "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
            ;;
        linux | windows)
            sed -i "s|bucket_name|${BUCKET_NAME}|g" "$BACKEND_FILE"
            ;;
        *)
            echo "Unsupported or unknown OS"
            exit 1
            ;;
    esac
else
    echo "backend.tf already configured with bucket name."
fi

echo "Running Terraform init and apply for infrastructure..."
cd tf-stack
terraform init
terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "✅ Deployment complete!"
