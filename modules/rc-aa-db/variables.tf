


variable "rediscloud_aa_subscription_id" {
    description = "redis cloud aa subscription id"
}

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

######################################## Redis Cloud Database Variables

variable "rc_db_data_persistence" {
    description = "Rate of database data persistence (in persistent storage)"
    default = "none"
}

variable "rc_db_memory_limit_in_gb" {
    description = "Maximum memory usage that will be used for your database."
    default = 25
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