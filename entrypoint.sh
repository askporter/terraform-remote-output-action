#!/bin/sh
set -e

echo "user: $USER"
echo "home: $HOME"
echo "============"
ls $HOME

ORGANIZATION=$1
WORKSPACE=$2
NAME=$3

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
