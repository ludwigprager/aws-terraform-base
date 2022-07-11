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
