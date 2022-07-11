#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THIS=$0


cd $BASEDIR
source ../set-env.sh

terraform init \
  -backend-config="bucket=${BUCKET_NAME}" \
  -backend-config="region=${TF_VAR_backend_region}" \
  -backend-config="dynamodb_table=${DYNAMODB_TABLE}"

terraform destroy -auto-approve

