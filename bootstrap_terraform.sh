#!/bin/bash

echo "Initializing Terraform for the first time..."
terraform init

echo "Creating a staging workspace..."
terraform workspace new staging

echo "Creating a production workspace..."
terraform workspace new production

echo "Bootstrapping complete!"
