#### Variables used in modules
##################### AWS Variables

#### Provider variables
variable "aws_creds" {
    description = "Access key and Secret key for AWS [Access Keys, Secret Key]"
}

variable "owner" {
    description = "owner tag name"
}

#### AWS VPC
variable "prefix_name_1" {
    description = "base name for resources (prefix name)"
    default = "redisuser1-tf"
}

variable "prefix_name_2" {
    description = "base name for resources (prefix name)"
    default = "redisuser2-tf"
}

variable "region_1" {
    description = "aws region"
    default = "us-east-1"
}

variable "region_2" {
    description = "aws region"
    default = "us-west-2"
}

#### Declare the list of subnet CIDR blocks
variable "subnet_cidr_blocks_1" {
    type = list(string)
    description = "subnet_cidr_block"
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

#### Declare the list of subnet CIDR blocks
variable "subnet_cidr_blocks_2" {
    type = list(string)
    description = "subnet_cidr_block"
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}


#### Declare the list of availability zones
variable "subnet_azs_1" {
  type = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "subnet_azs_2" {
  type = list(string)
  default = ["us-west-2a","us-west-2b","us-west-2c"]
}


##### Subscription Peering

variable "aws_customer_application_vpc_region_1" {
    description = "aws_customer_application_vpc_region"
    default = "us-east-1"
}

variable "aws_customer_application_vpc_region_2" {
    description = "aws_customer_application_vpc_region"
    default = "us-west-2"
}

variable "aws_customer_application_aws_account_id" {
    description = "aws_customer_application_aws_account_id"
}

variable "aws_customer_application_vpc_id_1" {
    description = "aws_customer_application_vpc_id"
    default = ""
}

variable "aws_customer_application_vpc_id_2" {
    description = "aws_customer_application_vpc_id"
    default = ""
}

variable "aws_customer_application_vpc_cidr_1" {
    description = "aws_customer_application_vpc_cidr"
    default = "10.0.0.0/16"
}

variable "aws_customer_application_vpc_cidr_2" {
    description = "aws_customer_application_vpc_cidr"
    default = "10.0.0.0/16"
}

variable "aws_vpc_route_table_id_1" {
    description = "aws_customer_application_vpc_cidr"
    default = ""
}

variable "aws_vpc_route_table_id_2" {
    description = "aws_customer_application_vpc_cidr"
    default = ""
}

##################### Redis Cloud Variables

variable "rediscloud_creds" {
    description = "Access key and Secret key for Redis Cloud account"
}

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

################################ Redis Cloud AA Subscription Variables

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

##### Redis Cloud Creation Plan Variables
##### The Creation plan defines the infra for the RE Subscription Cluster, it does not deploy a db.

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

##################################### AWS TEST NODE VARIABLES (START)
variable "ssh_key_name_1" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_name_2" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path_1" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path_2" {
    description = "name of ssh key to be added to instance"
}
#### Test Instance Variables
variable "test-node-count" {
  description = "number of data nodes"
  default     = 1
}

variable "test_instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}

variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = true
}

variable "node-root-size" {
  description = "The size of the root volume"
  default     = "50"
}

#### Security
variable "open-nets" {
  type        = list(any)
  description = "CIDRs that will have access to everything"
  default     = []
}

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - enabled by default"
  default     = "1"
}

variable "internal-rules" {
  description = "Security rules to allow for connectivity within the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      comment   = "SSH from VPC"
    },
    {
      type      = "ingress"
      from_port = "1968"
      to_port   = "1968"
      protocol  = "tcp"
      comment   = "Proxy traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3333"
      to_port   = "3341"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3343"
      to_port   = "3344"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "36379"
      to_port   = "36380"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8001"
      to_port   = "8001"
      protocol  = "tcp"
      comment   = "Traffic from application to RS Discovery Service"
    },
    {
      type      = "ingress"
      from_port = "8002"
      to_port   = "8002"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8004"
      to_port   = "8004"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8006"
      to_port   = "8006"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8443"
      to_port   = "8443"
      protocol  = "tcp"
      comment   = "Secure (HTTPS) access to the management web UI"
    },
    {
      type      = "ingress"
      from_port = "8444"
      to_port   = "8444"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9080"
      to_port   = "9080"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9081"
      to_port   = "9081"
      protocol  = "tcp"
      comment   = "For CRDB management (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8070"
      to_port   = "8071"
      protocol  = "tcp"
      comment   = "Prometheus metrics exporter"
    },
    {
      type      = "ingress"
      from_port = "9443"
      to_port   = "9443"
      protocol  = "tcp"
      comment   = "REST API traffic, including cluster management and node bootstrap"
    },
    {
      type      = "ingress"
      from_port = "10000"
      to_port   = "19999"
      protocol  = "tcp"
      comment   = "Database traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "20000"
      to_port   = "29999"
      protocol  = "tcp"
      comment   = "Database shards traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "5353"
      to_port   = "5353"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      comment   = "Let TCP out to the VPC"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      comment   = "Let UDP out to the VPC"
    },
    #    {
    #      type      = "ingress"
    #      from_port = "8080"
    #      to_port   = "8080"
    #      protocol  = "tcp"
    #      comment   = "Allow for host check between nodes"
    #    },
  ]
}

variable "external-rules" {
  description = "Security rules to allow for connectivity external to the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    }
  ]
}

##################################### AWS TEST NODE VARIABLES (END)