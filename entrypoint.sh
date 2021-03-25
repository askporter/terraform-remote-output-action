#!/bin/sh
set -e

ORGANIZATION=$1
WORKSPACE=$2
TOKEN=$3
NAMES=$4

cat << EOF > $HOME/.terraformrc
credentials "app.terraform.io" {
  token = "$TOKEN"
}
EOF

cat << EOF > main.tf
terraform {
  required_version = ">= 0.14"
  backend "remote" {
    organization = "$ORGANIZATION"

    workspaces {
      name = "$WORKSPACE"
    }
  }
}
EOF

terraform init

for name in $NAMES
do
    echo "::set-output name=$name::$(terraform output $name)"
done
