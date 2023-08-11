
##### Terraform providers for rediscloud and aws
terraform {
 required_providers {
   rediscloud = {
     source = "RedisLabs/rediscloud"
     version = "1.3.1"
     }
   aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
      configuration_aliases = [ aws.a, aws.b ]
      }
  }
}

#### AWS region and AWS key pair for region A
#### Cluster A will live in region A and use this provider
provider "aws" {
  alias      = "a"
  region     = var.region_1
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}

#### AWS region and AWS key pair for region B
#### Cluster B will live in region B and use this provider
provider "aws" {
  alias      = "b"
  region     = var.region_2
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}


#### Configure the rediscloud provider:
#### go to your Redis Cloud Account >  Access Managment > API Keys > 
#### create new API Key (this gives you the secret key, the API_key is the API account key)
provider "rediscloud" {
    api_key = var.rediscloud_creds[0]
    secret_key = var.rediscloud_creds[1]
}

