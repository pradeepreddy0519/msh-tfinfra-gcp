#!/bin/bash

set -e

# Set project
PROJECT_ID="your_project_id"
PROJECT_ID="Unique_name"
# created Bucket Name from apply.sh
BUCKET_NAME=""

echo "Destroying infrastructure..."
cd tf-stack
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "Cleaning up state bucket..."
cd statefile
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "Infrastructure cleanup complete!"
