#!/bin/sh

echo $TF_VAR_access_key
/bin/terraform init -backend-config "access_key=${TF_VAR_access_key}"  -backend-config "secret_key=${TF_VAR_secret_key}" "${TF_VAR_terraform_directory}"
/bin/terraform $@
