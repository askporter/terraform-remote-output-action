# Terraform Remote Output

This is a Github Action to retrieve Terraform output from the Terraform Cloud remote backend.

Inputs (all required):
- `organization`: The Terraform cloud organization name
- `workspace`: The name of the workspace in the above organization
- `name`: The name of the variable to get

Example usage:

```yaml
name: My action

on:
  push:
    branches:
      - main

jobs:
  get-remote-state:
    runs-on: ubuntu-latest
    name: Check terraform file are formatted correctly
    steps:
      # Terraform needs initialising
      - name: Terraform config
        run: |
          cat > .terraformrc <<EOF
          credentials "app.terraform.io" {
            token = "${{ secrets.TERRAFORM_BACKEND_TOKEN }}"
          }
          EOF
      - name: Get remote state
        uses: askporter/terraform-remote-output
        id: remote-state
        with:
          # The Terraform cloud organization
          organization: ask-products
          # The name of the workspace in Terraform cloud
          workspace: platform-dev
          # The name of the output to retrieve
          name: grieg_lambda_arn

      - name: Deploy lambda
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws lambda update-function-code \
          --function-name ${{ steps.remote-state.outputs.value }} \
          --zip-file fileb://my-function.zip
```
