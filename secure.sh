#!/bin/bash

PROJECT_ID="your_project_id"

# Validate project_name
if [ -z "$PROJECT_ID" ]; then
  echo "Error: project_name is not set. Exiting."
  exit 1
fi

# Detect platform
OS_TYPE="$OSTYPE"
ARCH_TYPE=$(uname -m)
IS_WINDOWS=false

if [[ "$OS_TYPE" == "msys" || "$OS_TYPE" == "cygwin" || "$OS_TYPE" == "win32" ]]; then
  IS_WINDOWS=true
fi

# Function to install tflint
install_tflint() {
  echo "Installing tflint..."

  if $IS_WINDOWS; then
    LATEST_TFLINT=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -Lo tflint.zip "https://github.com/terraform-linters/tflint/releases/download/${LATEST_TFLINT}/tflint_windows_amd64.zip"
    mkdir -p tflint-bin
    unzip -o tflint.zip -d tflint-bin
    chmod +x tflint-bin/tflint.exe
    export PATH="$PWD/tflint-bin:$PATH"
  elif [[ "$OS_TYPE" == "darwin"* ]]; then
    brew install tflint
  elif [[ "$OS_TYPE" == "linux-gnu"* ]]; then
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  fi
}

# Function to install tfsec
install_tfsec() {
  echo "Installing tfsec..."

  if $IS_WINDOWS; then
    LATEST_TFSEC=$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -Lo tfsec.exe "https://github.com/aquasecurity/tfsec/releases/download/${LATEST_TFSEC}/tfsec-windows-amd64.exe"
    mkdir -p tfsec-bin
    mv tfsec.exe tfsec-bin/
    chmod +x tfsec-bin/tfsec.exe
    export PATH="$PWD/tfsec-bin:$PATH"
  elif [[ "$OS_TYPE" == "darwin"* ]]; then
    brew install tfsec
  elif [[ "$OS_TYPE" == "linux-gnu"* ]]; then
    curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/get.sh | bash
  fi
}

# Check/install tflint
if ! command -v tflint &> /dev/null; then
  install_tflint
else
  echo "tflint is already installed."
fi

# Check/install tfsec
if ! command -v tfsec &> /dev/null; then
  install_tfsec
else
  echo "tfsec is already installed."
fi

# Paths
TF_STATEFILE_DIR="./statefile"
TF_ENV_DIR="./modules"

# Run tflint and tfsec on tfstatefile directory
echo "Running terraform init in tfstatefile directory..."
cd "$TF_STATEFILE_DIR"
terraform init 
tflint
tfsec .

# Move back
cd - || exit

# Run in tf-env directory
echo "Running terraform init in tf-env directory..."
cd "$TF_ENV_DIR"
terraform init
echo "TFLint code quality check...."
tflint
echo "Security vulnerabilities check....."
tfsec .