#!/bin/sh
set -e

ROLE_ARN=$1
BUCKET=$2
BUCKET_KEY=$3
REGION=$4
DYNAMODB_TABLE_NAME=$5
NAMES=$6

local_dir_name=terraform-remote-output-action

mkdir -p $local_dir_name

cat << EOF > $HOME/.terraformrc
credentials "app.terraform.io" {
  token = "$TOKEN"
}
EOF

cat << EOF > $local_dir_name/main.tf
terraform {
  required_version = ">= 0.14"
  required_providers {}
  backend "s3" {}
}
EOF

cat << EOF > $local_dir_name/backend.tfbackend
role_arn = "${ROLE_ARN}"
bucket = "${BUCKET}"
key = "${BUCKET_KEY}"
region = "${REGION}"
dynamodb_table = "${DYNAMODB_TABLE_NAME}"
encrypt = true

EOF

terraform init -chdir=$local_dir_name -input=false -backend-config="backend.tfbackend"

for name in $NAMES
do
    echo $name
    echo "::set-output name=$name::$(terraform -chdir=$local_dir_name output $name)"
done

# Cleanup
rm -r $local_dir_name
