##################### Redis Cloud Variables

variable "cc_type" {
    description = "credit card type"
    default = "Visa"
}

variable "cc_last_4" {
    description = "Last 4 digits for payment method"
}

variable "rediscloud_subscription_name" {
    description = "Name of RedisCloud subscription"
}

variable "rc_cloud_account_id" {
    description = "rediscould account id"
    default = ""
}

variable "rc_cloud_account_provider_type" {
    description = "rc_cloud_account_provider_type"
    default = "AWS"
}

################################ Redis Cloud Subscription Variables

variable "rc_region_1" {
    description = "redis cloud aws region"
    default = "us-east-1"
}

variable "rc_region_2" {
    description = "redis cloud aws region"
    default = "us-west-2"
}

variable "rc_networking_deployment_cidr_1" {
    description = "the CIDR of your RedisCloud deployment, MUST BE /24"
    default = "10.1.0.0/24"
}

variable "rc_networking_deployment_cidr_2" {
    description = "the CIDR of your RedisCloud deployment, MUST BE /24"
    default = "10.2.0.0/24"
}


variable "rc_cp_memory_limit_in_gb" {
    description = "Maximum memory usage that will be used for your largest planned database."
    default = 25
}

variable "rc_cp_quantity" {
    description = "The planned number of databases in the subscription."
    default = 1
}

variable "rc_cp_write_operations_per_second_1" {
    description = "The planned write_operations_per_second for side 1"
    default = 1000
}

variable "rc_cp_read_operations_per_second_1" {
    description = "The planned read_operations_per_second for side 1"
    default = 1000
}

variable "rc_cp_write_operations_per_second_2" {
    description = "The planned write_operations_per_second for side 2"
    default = 1000
}

variable "rc_cp_read_operations_per_second_2" {
    description = "The planned read_operations_per_second for side 2"
    default = 1000
}

##########

variable "rc_db_data_persistence" {
    description = "Rate of database data persistence (in persistent storage)"
    default = "none"
}

variable "rc_db_memory_limit_in_gb" {
    description = "Maximum memory usage that will be used for your database."
    default = 1
}

variable "rc_db_name" {
    description = "database name"
    default = "example-db"
}

variable "local_write_operations_per_second_1" {
    description = "local_write_operations_per_second side 1"
    default = 1000
}

variable "local_read_operations_per_second_1" {
    description = "local_read_operations_per_second side 1"
    default = 1000
}

variable "local_write_operations_per_second_2" {
    description = "local_write_operations_per_second side 2"
    default = 1000
}

variable "local_read_operations_per_second_2" {
    description = "local_read_operations_per_second side 2"
    default = 1000
}