#!/usr/bin/env bash

set -eu

THIS=$0


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../set-env.sh
source ./functions.sh



result=$(ddb-table-exists ${DYNAMODB_TABLE})

if [ "$result" != "null" ]; then 
  echo deleting table ${DYNAMODB_TABLE}
  aws dynamodb delete-table \
    --region ${TF_VAR_backend_region} \
    --table-name ${DYNAMODB_TABLE}
fi

echo waiting for table ${DYNAMODB_TABLE} to vanish
aws dynamodb wait table-not-exists \
  --region ${TF_VAR_backend_region} \
  --table-name ${DYNAMODB_TABLE}

result=$(list-buckets ${BUCKET_NAME})
if [ "$result" == "${BUCKET_NAME}" ]; then 

  echo deleting bucket ${BUCKET_NAME}
  echo "in case the bucket deletion fails you can run"
  echo
  echo "aws s3 rb s3://${BUCKET_NAME} --force"
  echo
  aws s3api delete-bucket \
    --bucket ${BUCKET_NAME} \
    --region ${TF_VAR_backend_region}

fi


