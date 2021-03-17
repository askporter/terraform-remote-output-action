#!/bin/sh
set -e

ORGANIZATION=$1
WORKSPACE=$2
TOKEN=$3
NAME=$4

cat << EOF > $HOME/.terraformrc
credentials "app.terraform.io" {
  token = "$TOKEN"
}
EOF

ls -lah $HOME

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

echo "::set-output name=value::$(terraform output $NAME)"
