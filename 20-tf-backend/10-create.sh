#!/usr/bin/env bash

set -x

set -eu
set -o pipefail

THIS=$0

#usage() {
#cat << EOF
#Usage: ${THIS} "<environment account id>"
#example:
#
#${THIS} 999999999999
#
#EOF
#}
#
#if [[ $# -lt 1 ]]; then
#  usage
#  exit 1
#fi

#ENV_ACCOUNT_ID=$1


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
#source ../functions.sh
source ./set-env.sh
source ./functions.sh

# test
#echo assuming role 1

#assume-cicd-role ${ENV_ACCOUNT_ID}

#echo assuming role 2

# 1. test if bucket exists and you can decrypt
# in that case you can assume it's YOUR bucket

# 2. create the bucket + db etc.

function create-bucket() {

  echo creating bucket ${BUCKET_NAME}
  aws s3api create-bucket \
    --bucket ${BUCKET_NAME} \
    --region ${TF_VAR_backend_region} \
    --create-bucket-configuration \
    LocationConstraint=${TF_VAR_backend_region}

  aws s3api put-bucket-encryption \
    --bucket ${BUCKET_NAME} \
    --server-side-encryption-configuration "{\"Rules\": [{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\": \"AES256\"}}]}"

}


result=$(list-buckets ${BUCKET_NAME})
if [ "$result" != "${BUCKET_NAME}" ]; then 
  create-bucket
fi

result=$(ddb-table-exists ${DYNAMODB_TABLE})
if [ "$result" = "null" ]; then 

  echo creating table ${DYNAMODB_TABLE}
  aws dynamodb create-table \
    --region ${TF_VAR_backend_region} \
    --table-name ${DYNAMODB_TABLE} \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

fi


echo waiting for table ${DYNAMODB_TABLE} to be available
aws dynamodb wait table-exists \
  --region ${TF_VAR_backend_region} \
  --table-name ${DYNAMODB_TABLE}

