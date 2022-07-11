#!/usr/bin/env bash

get-subnet-id-by-tagname() {
  local name=$1

  id=$( \
    aws ec2 describe-subnets \
      --filters Name=tag:Name,Values=${name} \
      | jq -r '.Subnets[].SubnetId' \
  )
  printf $id
}
export -f get-subnet-id-by-tagname

get-vpc-id-by-tagname() {
  local name=$1

  id=$( \
    aws ec2 describe-vpcs \
      --filters Name=tag:launch_name,Values=${name} \
      | jq -r '.Vpcs[].VpcId' \
  )
  printf $id
}
export -f get-vpc-id-by-tagname

assume-cicd-role() {
  local ENV_ACCOUNT_ID=$1

# export AWS_PROFILE=App_AzureDevops_Deploy
# unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN


  ROLE_ARN=arn:aws:iam::${ENV_ACCOUNT_ID}:role/sc-admin-product/CICD_Deployment
  ROLE_SESSION_NAME=CICD

  TEMP_ROLE=$(aws sts assume-role \
    --role-arn $ROLE_ARN \
    --role-session-name $ROLE_SESSION_NAME)

  export AWS_ACCESS_KEY_ID=$(echo $TEMP_ROLE | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_ROLE | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo $TEMP_ROLE | jq -r .Credentials.SessionToken)
}
export -f assume-cicd-role
