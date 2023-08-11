# rediscloud-terraform
Deploy a Redis Cloud AWS Subscription and create a new Redis DB using the Redis Cloud Terraform Provider ([link](https://registry.terraform.io/providers/RedisLabs/rediscloud/latest/docs)). 
VPC peer your Redis Cloud subscription to a new or existing AWS VPC.

This repo will also create a new AWS VPC from scratch and VPC peering it to Redis Cloud.
If you have an existing AWS VPC you would like to use, please navigate to the [Optional Steps](#i-have-an-existing-aws-vpc-i-want-to-use)
to update the inputs.

# Overview

This repo is broken into Terraform modules. 
These modules break different components out into individual parts which can be updated or removed if needed.

There are four different modules:
* `rc-subscription` 
    * (This creates a brand new Redis cloud AWS subscription for you)
    * A Redis Cloud AWS subscription is comprised of the following componets
      * A brand new VPC
      * 3+ Nodes (VMs) with Redis Enterprise software installed to create the Redis Enterprise Cluster
* `rc-create-db` 
  * (This creates a brand new Redis DB in the newly provisioned Redis Cloud subscription)
  * This module can be updated after it is run to update and scale the Redis Cloud DB. [Optional Steps](#i-want-to-update-my-existing-db-after-it-is-created)
* `aws-vpc` 
  * (This creates a brand new AWS VPC)
  * This VPC is supposed to contain the application that will communicate with Redis
  * If an existing VPC exists, then this can be commented out, (*instructions below*) [Optional Steps](#i-have-an-existing-aws-vpc-i-want-to-use)
* `rc-aws-vpc-peering` 
  * (This VPC Peers your Redis Cloud Subscription to the newly created or existing AWS VPC)
  * Redis Cloud does most of the work on the VPC peering, but AWS requires a route table addition to the customer AWS Account which requires including the AWS Terraform provider.

Ok, now that we know what we have, we can get started

# Getting Started: Create a Redis Cloud subscription from Terraform

#### Prerequisites
* aws account
* aws-cli (*aws access-key and secret-key*)
* redis cloud account ([link](https://redis.com/try-free/))
  * redis cloud API Key and Secret (*instructions below*) [API & Secret Key](#step-1-redis-cloud-account-steps)
* terraform installed on local machine
* VS Code

Once you have the prerequisties we can get started.

## Step 1: Redis Cloud Account Steps
1. Navigate to your Redis Cloud Account ([link](https://app.redislabs.com/))
2. Log in and click "Access Management"
3. Click API Keys

![Alt text](images/rc-accessmanagment-1.png?raw=true "Title")

4. Click the "+" icon and create a new API Key User.

![Alt text](images/rc-accessmanagment-2.png?raw=true "Title")

5. Save the API `Account Key` & the `Secret Key` information
  * This info will be saved into the `terraform.tfvars` file.

## Step 2: AWS Account Steps

1. Gather required AWS Account information
* AWS Account ID (12-digit account number)
  * can be found under account settings
* aws-cli (*aws access-key and secret-key*)

## Step 3: Terraform.tfvars

Fill in the `terraform.tfvars` file with variable information to 
create the Redis Cloud subscription, create a brand new VPC and VPC peer it to your Redis Cloud subscription.
And create a new database in your Redis Cloud subscription.

1. Step 1, utilize the `terraform.tfvars.example` file and replace/fill in the variable values

Copy the `terraform.tfvars.example` and rename it 'terraform.tfvars'
```bash
  cp terraform.tfvars.example terraform.tfvars
```
Update terraform.tfvars with your variable entries.


## Step 4: Run Terraform!

Now that you have filled in all the variable values
you can run terraform and create your Redis Cloud subscription, database, 
AWS VPC and VPC peer it to the Redis Cloud Subscription.

Now you are ready to go!
    * Open a terminal in VS Code:
    ```bash
    # create virtual environment
    python3 -m venv ./venv
    # ensure ansible is in path (you should see an output showing ansible is there)
    # if you see nothing refer back to the prerequisites section for installing ansible.
    ansible --version
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes

## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
```


## Optional Steps: (Update the DB & or use an existing AWS VPC)

### I want to update my existing DB after it is created

After you have successfully deployed the Redis Cloud subscription and db
you might want to update it to test the scaling capabilities of Redis Cloud.
To do this, you simply update the values inside your `rc-create-db` module inside the `modules.tf` file.

Change a few of the variable values and re-run the `terraform plan`.
This will show you an example of what will happen, explaining that it will *update inplace*.
Then run `terraform apply` to apply the changes.

Please see the example below:

```
###########
########### Create a Redis Enterprise database in the Redis Cloud Subscription
########### To scale or update the db, simply update the parameters after it has been created.
module "rc-create-db" {
    source                                      = "./modules/rc-create-db"
    rediscloud_subscription_id                  = module.rc-subscription.rediscloud_subscription_id
    rc_db_average_item_size_in_bytes            = var.rc_db_average_item_size_in_bytes
    rc_db_replication                           = var.rc_db_replication
    rc_db_external_endpoint_for_oss_cluster_api = var.rc_db_external_endpoint_for_oss_cluster_api
    rc_db_support_oss_cluster_api               = var.rc_db_support_oss_cluster_api
    rc_db_throughput_measurement_value          = var.rc_db_throughput_measurement_value
    rc_db_throughput_measurement_by             = var.rc_db_throughput_measurement_by
    rc_db_data_persistence                      = var.rc_db_data_persistence
    rc_db_memory_limit_in_gb                    = var.rc_db_memory_limit_in_gb
    rc_db_name                                  = var.rc_db_name
    rc_db_modules                               = var.rc_db_modules

    depends_on = [
      module.rc-subscription
    ]
}

## You could change the values inside the variables, 
## or change the variable values directly in the module
### EXAMPLE
module "rc-create-db" {
    source                                      = "./modules/rc-create-db"
    rediscloud_subscription_id                  = module.rc-subscription.rediscloud_subscription_id
    rc_db_average_item_size_in_bytes            = var.rc_db_average_item_size_in_bytes
    rc_db_replication                           = 'true'
    rc_db_external_endpoint_for_oss_cluster_api = var.rc_db_external_endpoint_for_oss_cluster_api
    rc_db_support_oss_cluster_api               = var.rc_db_support_oss_cluster_api
    rc_db_throughput_measurement_value          = '25000'
    rc_db_throughput_measurement_by             = var.rc_db_throughput_measurement_by
    rc_db_data_persistence                      = var.rc_db_data_persistence
    rc_db_memory_limit_in_gb                    = '50'
    rc_db_name                                  = 'updated-db-name'
    rc_db_modules                               = var.rc_db_modules

    depends_on = [
      module.rc-subscription
    ]
}

```

Now you have seen Redis Cloud scale up!

### I have an existing AWS VPC I want to use:

You might already have an existing AWS VPC that you would like to utlize.
If so, you can follow these steps.

Navigate to the `modules.tf` file. Comment out the `vpc-module` module and its outputs.
By commenting this module and its outputs out, you will **not run** the new VPC creation.
Please comment out the following module and outputs in the `modules.tf` file.

```
  ########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "aws-vpc" {
    source             = "./modules/aws-vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.aws_customer_application_vpc_region
    prefix_name        = var.prefix_name
    vpc_cidr           = var.aws_customer_application_vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids" {
  value = module.aws-vpc.subnet-ids
}

output "vpc-id" {
  value = module.aws-vpc.vpc-id
}

output "vpc_name" {
  description = "get the VPC Name tag"
  value = module.aws-vpc.vpc-name
}

output "route-table-id" {
  description = "route table id"
  value = module.aws-vpc.route-table-id
}
```

Now that you are not creating a new VPC you will need to enter in your 
existing VPC values into the `rc-aws-vpc-peering` module.

Please find the following info from your existing AWS VPCs
* **aws_customer_application_vpc_region** (your existing aws vpcs region)
* **aws_customer_application_aws_account_id** (your aws account id)
* **aws_customer_application_vpc_id** (your existing aws vpc id)
* **aws_customer_application_vpc_cidr** (your existing aws vpc cidr)
  * **MUST NOT OVERLAP WITH REDIS CLOUD VPC CIDR**
* **aws_vpc_route_table_id** (your existing aws vpc route table id)

**and remove `module.aws-vpc` from the depends on.**

Please enter in these value into their respective places in the `rc-aws-vpc-peering` module
in the `modules.tf` file.

Please see example of what it might look like below.
```
################################## VPC PEERING
############## Redis Cloud VPC peering to Application VPC in AWS account
########## This requires adding a route to the applicaiton VPC in the customers AWS account
module "rc-aws-vpc-peering" {
    source                                  = "./modules/rc-aws-vpc-peering"
    rediscloud_subscription_id              = module.rc-subscription.rediscloud_subscription_id
    aws_customer_application_vpc_region     = 'us-east-1'
    aws_customer_application_aws_account_id = '123456789123'
    aws_customer_application_vpc_id         = 'vpc-124df234235'
    aws_customer_application_vpc_cidr       = '10.0.0.0/24'
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr
    aws_vpc_route_table_id                  = 'rt-124df234235'

    depends_on = [
      module.rc-subscription
    ]
}
```

Now you can run the terrafrom plan and apply and VPC peer to your existing VPC.

After you are all done, please clean up!


## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
```
