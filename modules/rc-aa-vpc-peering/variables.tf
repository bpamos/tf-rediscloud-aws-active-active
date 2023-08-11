

# variable "owner" {
#     description = "owner tag name"
# }

# variable "vpc_name" {
#     description = "vpc_name"
# }

# ##### Subscription Peering

variable "rediscloud_aa_subscription_id" {
    description = "the CIDR of your RedisCloud deployment"
}

variable "aws_customer_application_aws_account_id" {
    description = "aws_customer_application_aws_account_id"
}

### VPC

variable "aws_customer_application_vpc_region" {
    description = "aws_customer_application_vpc_region"
}

variable "aws_customer_application_vpc_id" {
    description = "aws_customer_application_vpc_id"
}

variable "aws_customer_application_vpc_cidr" {
    description = "aws_customer_application_vpc_cidr"
}

variable "aws_vpc_route_table_id" {
    description = "aws_customer_application_vpc_cidr"
}

variable "rc_networking_deployment_cidr" {
    description = "the CIDR of your RedisCloud deployment"
}

variable "destination_region" {
    description = "the destination region"
}