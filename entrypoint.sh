#!/bin/bash

ORGANIZATION=$1
WORKSPACE=$2
NAME=$3

echo $ORGANIZATION
echo $WORKSPACE
echo $NAME

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
