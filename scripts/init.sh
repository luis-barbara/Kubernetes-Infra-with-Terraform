#!/bin/bash
# Initialize Terraform

set -e

echo "🚀 Initializing Terraform..."
echo ""

cd "$(dirname "$0")/../terraform"

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

echo ""
echo "✅ Terraform initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Review terraform/terraform.tfvars"
echo "  2. Run: ./scripts/apply.sh"
```
