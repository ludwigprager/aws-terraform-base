#!/usr/bin/env bash

MY_PREFIX=atb-20220723-lp

export BUCKET_NAME="${MY_PREFIX}-bucket"

# backend: where dynamo-db will be created
export TF_VAR_backend_region="eu-central-1"
export DYNAMODB_TABLE="${MY_PREFIX}-terraform-statelock"

export TF_VAR_prefix=${MY_PREFIX}

export S3_KEY="terraform-aws/terraform.tfstate"              
