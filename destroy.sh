#!/bin/bash

set -e

# Set project
PROJECT_ID="planar-night-455516-n3"
BUCKET_NAME="tf-state-file-planar"

echo "Destroying infrastructure..."
cd tf-stack
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "Cleaning up state bucket..."
cd statefile
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}" -var="bucket_name=${BUCKET_NAME}"
cd ..

echo "Infrastructure cleanup complete!"
