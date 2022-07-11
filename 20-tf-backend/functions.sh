#!/usr/bin/env bash

function list-buckets() {
  local bucket_name=$1
  # https://gist.github.com/david-sanabria/a26a33fe2f85dc0f40d6496536e83d84
  result=$(aws s3api list-buckets \
    --query "Buckets[?starts_with(Name,'${bucket_name}')].[Name]" \
    --output text \
  )
  printf "$result"
}

function ddb-table-exists() {
  local table_name=$1

  result=$( \
    aws dynamodb list-tables --region=$TF_VAR_backend_region \
    | jq --arg TABLE_NAME "$table_name" '.TableNames | index( $TABLE_NAME )' 
  )

  printf "$result"
}


export -f list-buckets
export -f ddb-table-exists
