# Terraform Statefile in an AWS S3 Bucket
This project is a generic solution to use terraform statefiles in a CICD pipeline.
# Objectives
1. A cli command creates and deletes the S3 backend and all related components.
   The deletion is not easily possible with a script to prevent accidental use.
2. The deployment is resilient against multiple simultaneous calls (synchronisation).
3. Ability to be used in various situations like
    - several statefiles per team
    - AWS accounts per environment (like G1-NonProd, G1-Prod)
    - One AWS account for multiple environments. (terraform 'workspaces')

# Possible Alternative Ways of Implementation
The creation of the backend resources via terraform would be another viable option. Either by  
1. Running `terraform init`.
2. Creation of the backend bucket and dynamodb table by creating terraform code. This leads to a second statefile to be taken care of.

Downsides:  
- Solution 1. doesn't cover locking with dynamodb
- Solution 2. is not cloud agnostic and perhaps less obvious than a scripted solution.
- The statefile produced by 2. also needs to be stored somewhere. This is a sort of hen and egg problem. Storing in git might be an option since this statefile is rarely modified. But it may contain a key which prevents storing in git without further measures.
    
# Conventions
The modification of the following variables in [set-env.sh](/aws-terraform-base/set-env.sh) is provided and will not affect function as long as it doesn't conflict with AWS resources of the same name.

- `MY_PREFIX`: String that shall prevent naming overlap. Should be unique for every scenario.
    Note: `MY_PREFIX` must follow the rules for [AWS bucket names](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
- `DYNAMODB_TABLE`: name of the dynamodb table that provides synchronisation.
- `S3_KEY`: path of the statefile in the bucket.

# AWS console
[S3](https://s3.console.aws.amazon.com/s3/home?region=eu-central-1&region=eu-central-1)  
[Dynamodb tables](https://eu-central-1.console.aws.amazon.com/dynamodbv2/home?region=eu-central-1#tables)  

# Reads
[Create terraform pre requisites for aws using aws cli in 3 easy steps](https://skundunotes.com/2021/04/03/create-terraform-pre-requisites-for-aws-using-aws-cli-in-3-easy-steps/)  
[Terraform S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html#example-configuration)  
[Terraform best practices](https://github.com/ozbillwang/terraform-best-practices)  
[Terraform workspaces](https://www.terraform.io/docs/language/state/workspaces.html)  

[secret variables](https://docs.microsoft.com/de-de/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#secret-variables)
https://docs.aws.amazon.com/vsts/latest/userguide/awsshell.html
