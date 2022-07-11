#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../set-env.sh
#source ../../functions.sh


# todo: statt envsubst 'terraform init' mit key/value Datei
terraform init \
  -input=false \
  -backend-config="bucket=${BUCKET_NAME}" \
  -backend-config="region=${TF_VAR_backend_region}" \
  -backend-config="dynamodb_table=${DYNAMODB_TABLE}"

terraform apply -auto-approve

