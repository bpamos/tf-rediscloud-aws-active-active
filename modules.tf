


######## Redis Cloud Account Information
####### Used in the terraform modules
data "rediscloud_cloud_account" "account" {
  exclude_internal_account = true
  provider_type = "AWS"
}

output "rc_cloud_account_id" {
  value = data.rediscloud_cloud_account.account.id
}

output "rc_cloud_account_provider_type" {
  value = data.rediscloud_cloud_account.account.provider_type
}

output "cloud_account_access_key_id" {
  value = data.rediscloud_cloud_account.account.access_key_id
}


########### VPC Module 1
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "aws-vpc-1" {
    source             = "./modules/aws-vpc"
    providers = {
      aws = aws.a
    }
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.aws_customer_application_vpc_region_1
    prefix_name        = var.prefix_name_1
    vpc_cidr           = var.aws_customer_application_vpc_cidr_1
    subnet_cidr_blocks = var.subnet_cidr_blocks_1
    subnet_azs         = var.subnet_azs_1
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids-1" {
  value = module.aws-vpc-1.subnet-ids
}

output "vpc-id-1" {
  value = module.aws-vpc-1.vpc-id
}

output "vpc_name_1" {
  description = "get the VPC Name tag"
  value = module.aws-vpc-1.vpc-name
}

output "route-table-id-1" {
  description = "route table id"
  value = module.aws-vpc-1.route-table-id
}


########### VPC Module 2
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "aws-vpc-2" {
    source             = "./modules/aws-vpc"
    providers = {
      aws = aws.b
    }
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.aws_customer_application_vpc_region_2
    prefix_name        = var.prefix_name_2
    vpc_cidr           = var.aws_customer_application_vpc_cidr_2
    subnet_cidr_blocks = var.subnet_cidr_blocks_2
    subnet_azs         = var.subnet_azs_2
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids-2" {
  value = module.aws-vpc-2.subnet-ids
}

output "vpc-id-2" {
  value = module.aws-vpc-2.vpc-id
}

output "vpc_name_2" {
  description = "get the VPC Name tag"
  value = module.aws-vpc-2.vpc-name
}

output "route-table-id-2" {
  description = "route table id"
  value = module.aws-vpc-2.route-table-id
}


############################ Redis Cloud AA Subscription
#### Provision an empty (no db) Redis Cloud AA subscription 
#### (1 VPC with 3+ Redis Enterprise Nodes (VMs) in Region 1)
#### (1 VPC with 3+ Redis Enterprise Nodes (VMs) in Region 2)
#### The db paramters are used to define the subscription creation plan
module "rc-aa-subscription" {
    source                          = "./modules/rc-aa-subscription"
    rc_cloud_account_id             = data.rediscloud_cloud_account.account.id
    rc_cloud_account_provider_type  = data.rediscloud_cloud_account.account.provider_type
    rediscloud_subscription_name    = var.rediscloud_subscription_name
    cc_type                         = var.cc_type
    cc_last_4                       = var.cc_last_4
    rc_region_1                       = var.rc_region_1
    rc_region_2                       = var.rc_region_2
    rc_networking_deployment_cidr_1   = var.rc_networking_deployment_cidr_1 #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    rc_networking_deployment_cidr_2   = var.rc_networking_deployment_cidr_2 #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    ######### CREATION PLAN (defines the size of cluster, does not deploy a db)
    rc_cp_memory_limit_in_gb              = var.rc_cp_memory_limit_in_gb
    rc_cp_quantity                        = var.rc_cp_quantity
    rc_cp_write_operations_per_second_1   = var.rc_cp_write_operations_per_second_1
    rc_cp_read_operations_per_second_1    = var.rc_cp_read_operations_per_second_1
    rc_cp_write_operations_per_second_2   = var.rc_cp_write_operations_per_second_2
    rc_cp_read_operations_per_second_2    = var.rc_cp_read_operations_per_second_2

    depends_on = [
      data.rediscloud_cloud_account.account
    ]
}

#outputs
# output the Redis Cloud Subscription ID to be used in additional modules
output "rediscloud_aa_subscription_id" {
  value = module.rc-aa-subscription.rediscloud_aa_subscription_id
}

########################### Redis Cloud AA Subscription DATABASE
### Provision a database in the AA subscription
### provide the size (GB) and throughput (read and write ops/sec) for the db in each region
module "rc-aa-db" {
    source                              = "./modules/rc-aa-db"
    rediscloud_aa_subscription_id       = module.rc-aa-subscription.rediscloud_aa_subscription_id
    rc_region_1                         = var.rc_region_1
    rc_region_2                         = var.rc_region_2
    rc_networking_deployment_cidr_1     = var.rc_networking_deployment_cidr_1 #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    rc_networking_deployment_cidr_2     = var.rc_networking_deployment_cidr_2 #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    ######### DB Vars (this will deploy the db)
    rc_db_data_persistence              = var.rc_db_data_persistence
    rc_db_password                      = var.rc_db_password
    rc_db_memory_limit_in_gb            = var.rc_db_memory_limit_in_gb
    rc_db_name                          = var.rc_db_name
    local_write_operations_per_second_1 = var.local_write_operations_per_second_1
    local_read_operations_per_second_1  = var.local_read_operations_per_second_1
    local_write_operations_per_second_2 = var.local_write_operations_per_second_2
    local_read_operations_per_second_2  = var.local_read_operations_per_second_2
    
    depends_on = [
      module.rc-aa-subscription
    ]
}

output "private_endpoint" {
  description = "A map of which private endpoints can to access the database per region, uses region name as key."
  value = module.rc-aa-db.private_endpoint
}

output "private_endpoints_list" {
  description = "list them private endpionts"
  value = module.rc-aa-db.private_endpoints_list
}

################################## VPC PEERING (region A)
############## Redis Cloud VPC peering to Application VPC in same region
########## This requires adding a route to the applicaiton VPC in the customers AWS account
module "rc-aa-vpc-peering-1" {
    source                                    = "./modules/rc-aa-vpc-peering"
    providers = {
      aws = aws.a
    }
    rediscloud_aa_subscription_id           = module.rc-aa-subscription.rediscloud_aa_subscription_id
    aws_customer_application_vpc_region     = var.aws_customer_application_vpc_region_1
    aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc-1.vpc-id
    aws_customer_application_vpc_cidr       = var.aws_customer_application_vpc_cidr_1
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr_1
    rc_region                               = var.rc_region_1
    aws_vpc_route_table_id                  = module.aws-vpc-1.route-table-id

    depends_on = [
      module.aws-vpc-1, module.rc-aa-subscription
    ]
}

# ################################## VPC PEERING (region B)
# ############## Redis Cloud VPC peering to Application VPC in same region
# ########## This requires adding a route to the applicaiton VPC in the customers AWS account
module "rc-aa-vpc-peering-2" {
    source                                  = "./modules/rc-aa-vpc-peering"
    providers = {
      aws = aws.b
    }
    rediscloud_aa_subscription_id           = module.rc-aa-subscription.rediscloud_aa_subscription_id
    aws_customer_application_vpc_region     = var.aws_customer_application_vpc_region_2
    aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc-2.vpc-id
    aws_customer_application_vpc_cidr       = var.aws_customer_application_vpc_cidr_2
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr_2
    rc_region                               = var.rc_region_2
    aws_vpc_route_table_id                  = module.aws-vpc-2.route-table-id

    depends_on = [
      module.aws-vpc-2, module.rc-aa-subscription
    ]
}

################################# VPC PEERING (Cross Region)
############## Redis Cloud VPC peering to Application VPC in other region. Redis Cloud Region B to Application Region A
module "rc-aa-vpc-peering-application-vpc-a-to-redis-vpc-b" {
    source                                    = "./modules/rc-aa-vpc-peering"
    providers = {
      aws = aws.a
    }
    rediscloud_aa_subscription_id           = module.rc-aa-subscription.rediscloud_aa_subscription_id
    aws_customer_application_vpc_region     = var.aws_customer_application_vpc_region_1
    aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc-1.vpc-id
    aws_customer_application_vpc_cidr       = var.aws_customer_application_vpc_cidr_1
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr_2
    rc_region                               = var.rc_region_2
    aws_vpc_route_table_id                  = module.aws-vpc-1.route-table-id

    depends_on = [
      module.aws-vpc-1, module.aws-vpc-2, 
      module.rc-aa-subscription,
      module.rc-aa-vpc-peering-1
    ]
}

################################# VPC PEERING (Cross Region)
############## Redis Cloud VPC peering to Application VPC in other region. Redis Cloud Region A to Application Region B
module "rc-aa-vpc-peering-application-vpc-b-to-redis-vpc-a" {
    source                                    = "./modules/rc-aa-vpc-peering"
    providers = {
      aws = aws.b
    }
    rediscloud_aa_subscription_id           = module.rc-aa-subscription.rediscloud_aa_subscription_id
    aws_customer_application_vpc_region     = var.aws_customer_application_vpc_region_2
    aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc-2.vpc-id
    aws_customer_application_vpc_cidr       = var.aws_customer_application_vpc_cidr_2
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr_1
    rc_region                               = var.rc_region_1
    aws_vpc_route_table_id                  = module.aws-vpc-2.route-table-id

    depends_on = [
      module.aws-vpc-1, module.aws-vpc-2, 
      module.rc-aa-subscription,
      module.rc-aa-vpc-peering-2
    ]
}


# #######################################
########### Node Module 1
#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-1" {
    source             = "./modules/nodes"
    providers = {
      aws = aws.a
    }
    owner              = var.owner
    region             = var.aws_customer_application_vpc_region_1
    vpc_cidr           = var.aws_customer_application_vpc_cidr_1
    subnet_azs         = var.subnet_azs_1
    ssh_key_name       = var.ssh_key_name_1
    ssh_key_path       = var.ssh_key_path_1
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-1.vpc-name
    vpc_subnets_ids    = module.aws-vpc-1.subnet-ids
    vpc_id             = module.aws-vpc-1.vpc-id

    depends_on = [
      module.aws-vpc-1
    ]
}

#### Node Outputs to use in future modules
output "test-node-eips-1" {
  value = module.nodes-1.test-node-eips
}

output "test-node-internal-ips-1" {
  value = module.nodes-1.test-node-internal-ips
}

output "test-node-eip-public-dns-1" {
  value = module.nodes-1.test-node-eip-public-dns
}


########### Node Module 1
#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-redis-1" {
    source             = "./modules/node-config-redis"
    providers = {
      aws = aws.a
    }
    ssh_key_name       = var.ssh_key_name_1
    ssh_key_path       = var.ssh_key_path_1
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-1.vpc-name
    vpc_id             = module.aws-vpc-1.vpc-id
    aws_eips           = module.nodes-1.test-node-eips

    depends_on = [
      module.nodes-1
    ]
}


#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-java-1" {
    source             = "./modules/node-config-java"
    providers = {
      aws = aws.a
    }
    ssh_key_name       = var.ssh_key_name_1
    ssh_key_path       = var.ssh_key_path_1
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-1.vpc-name
    vpc_id             = module.aws-vpc-1.vpc-id
    aws_eips           = module.nodes-1.test-node-eips

    depends_on = [
      module.nodes-1,
      module.nodes-config-redis-1
    ]
}

output "mvn_command" {
  description = "Formatted Maven command with private endpoint values."
  value = <<-EOT
    mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args="--failover true --host ${module.rc-aa-db.private_endpoints_list[0].endpoint.hostname} --port ${module.rc-aa-db.private_endpoints_list[0].endpoint.port} --password ${var.rc_db_password} --host2 ${module.rc-aa-db.private_endpoints_list[1].endpoint.hostname} --port2 ${module.rc-aa-db.private_endpoints_list[1].endpoint.port} --password2 ${var.rc_db_password}"
  EOT
  depends_on = [module.nodes-config-java-1, module.rc-aa-db]
}

#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "jedis-run-app-1" {
    source             = "./modules/jedis-run"
    providers = {
      aws = aws.a
    }
    vpc_name               = module.aws-vpc-1.vpc-name
    rc_db_password         = var.rc_db_password
    private_endpoints_list = module.rc-aa-db.private_endpoints_list

    depends_on = [
      module.nodes-config-java-1
    ]
}

#######################################
########### Node Module 2
#### Create Test node
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-2" {
    source             = "./modules/nodes"
    providers = {
      aws = aws.b
    }
    owner              = var.owner
    region             = var.aws_customer_application_vpc_region_2
    vpc_cidr           = var.aws_customer_application_vpc_cidr_2
    subnet_azs         = var.subnet_azs_2
    ssh_key_name       = var.ssh_key_name_2
    ssh_key_path       = var.ssh_key_path_2
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-2.vpc-name
    vpc_subnets_ids    = module.aws-vpc-2.subnet-ids
    vpc_id             = module.aws-vpc-2.vpc-id

    depends_on = [
      module.aws-vpc-2
    ]
}

#### Node Outputs to use in future modules
output "test-node-eips-2" {
  value = module.nodes-2.test-node-eips
}

output "test-node-internal-ips-2" {
  value = module.nodes-2.test-node-internal-ips
}

output "test-node-eip-public-dns-2" {
  value = module.nodes-2.test-node-eip-public-dns
}

########### Node Module 1
#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-redis-2" {
    source             = "./modules/node-config-redis"
    providers = {
      aws = aws.b
    }
    ssh_key_name       = var.ssh_key_name_2
    ssh_key_path       = var.ssh_key_path_2
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-2.vpc-name
    vpc_id             = module.aws-vpc-2.vpc-id
    aws_eips           = module.nodes-2.test-node-eips

    depends_on = [
      module.nodes-2
    ]
}


#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-java-2" {
    source             = "./modules/node-config-java"
    providers = {
      aws = aws.b
    }
    ssh_key_name       = var.ssh_key_name_2
    ssh_key_path       = var.ssh_key_path_2
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc-2.vpc-name
    vpc_id             = module.aws-vpc-2.vpc-id
    aws_eips           = module.nodes-2.test-node-eips

    depends_on = [
      module.nodes-2,
      module.nodes-config-redis-2
    ]
}





