#!/usr/bin/env bash

set -eu

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


#if [[ $# -lt 1 ]]; then
#  usage
#  exit 1
#fi

#ENV_ACCOUNT_ID=$1


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ./set-env.sh
source ./functions.sh

#assume-cicd-role ${ENV_ACCOUNT_ID}


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
  echo "in case the bucket deletion fails run"
  echo
  echo "source ${DIR}/../functions.sh"
# echo "assume-cicd-role ${ENV_ACCOUNT_ID}"
  echo "aws s3 rb s3://${BUCKET_NAME} --force"
  echo "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN"
  echo
  aws s3api delete-bucket \
    --bucket ${BUCKET_NAME} \
    --region ${TF_VAR_backend_region}

fi


