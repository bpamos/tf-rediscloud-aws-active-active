# tf-rediscloud-aws-active-active
Deploy a Redis Cloud Active-Active AWS Subscription and create a new Redis DB using the Redis Cloud Terraform Provider ([link](https://registry.terraform.io/providers/RedisLabs/rediscloud/latest/docs)).

Deploy a new VPC in each region your Active-Active DB will reside.

Deploy and configure a "test node", an EC2 with Redis and Memtier Benchmark installed in each VPC.

VPC peer your Redis Cloud Active-Active subscription to a new VPC in each region.


# Overview

This repo is broken into Terraform modules. 
These modules break different components out into individual parts which can be updated or removed if needed.

There are eight different modules:
* `rc-aa-subscription` 
    * (This creates a brand new Redis cloud Active-Active AWS subscription for you)
    * A Redis Cloud Active-Active AWS subscription is comprised of the following componets
      * A brand new VPC in each region you choose to deploy
      * 3+ Nodes (VMs) with Redis Enterprise software installed to create the Redis Enterprise Cluster in each VPC
* `rc-aa-db` 
  * (This creates a brand new Redis DB in the newly provisioned Redis Cloud Active-Active subscription)
  * This module can be updated after it is run to update and scale the Redis Cloud DB. [Optional Steps](#i-want-to-update-my-existing-db-after-it-is-created)
* `aws-vpc-1` 
  * (This creates a brand new AWS VPC in region 1)
  * This VPC is supposed to contain the application that will communicate with Redis
  * If an existing VPC exists, then this can be commented out, (*instructions below*) [Optional Steps](#i-have-an-existing-aws-vpc-i-want-to-use)
* `aws-vpc-2` 
  * (This creates a brand new AWS VPC in region 2)
  * This VPC is supposed to contain the application that will communicate with Redis
  * If an existing VPC exists, then this can be commented out, (*instructions below*) [Optional Steps](#i-have-an-existing-aws-vpc-i-want-to-use)
* `rc-aa-vpc-peering-1` 
  * (This VPC Peers your Redis Cloud Subscription to the newly created or existing AWS VPC in Region 1)
  * Redis Cloud does most of the work on the VPC peering, but AWS requires a route table addition to the customer AWS Account which requires including the AWS Terraform provider.
* `rc-aa-vpc-peering-2` 
  * (This VPC Peers your Redis Cloud Subscription to the newly created or existing AWS VPC in Region 2)
  * Redis Cloud does most of the work on the VPC peering, but AWS requires a route table addition to the customer AWS Account which requires including the AWS Terraform provider.
* `nodes-1` 
  * (Region 1: This deploys and configures Test nodes (EC2) in the AWS VPC, each node has Redis and Miemtier installed on it)
  * The configuration of the node is done in ansible, so you will need to have ansible on your local machine. Please find instructions below. [Instuctions](#prerequisites-detailed-instructions)
* `nodes-2` 
  * (Region 2: This deploys and configures Test nodes (EC2) in the AWS VPC, each node has Redis and Miemtier installed on it)
  * The configuration of the node is done in ansible, so you will need to have ansible on your local machine. Please find instructions below. [Instuctions](#prerequisites-detailed-instructions)


Ok, now that we know what we have, we can get started

# Getting Started: Create a Redis Cloud Active-Active subscription from Terraform

#### Prerequisites
* aws account
* aws-cli (*aws access-key and secret-key*)
* redis cloud account ([link](https://redis.com/try-free/))
  * redis cloud API Key and Secret (*instructions below*) [API & Secret Key](#step-1-redis-cloud-account-steps)
* terraform installed on local machine
* ansible installed on local machine

Once you have the prerequisties we can get started.

#### Prerequisites (detailed instructions)
1.  Install `aws-cli` on your local machine and run `aws configure` ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)) to set your access and secret key.
    - If using an aws-cli profile other than `default`, `main.tf` may need to edited under the `provider "aws"` block to reflect the correct `aws-cli` profile.
2.  Download the `terraform` binary for your operating system ([link](https://www.terraform.io/downloads.html)), and make sure the binary is in your `PATH` environment variable.
    - MacOSX users:
        - (if you see an error saying something about security settings follow these instructions), ([link](https://github.com/hashicorp/terraform/issues/23033))
        - Just control click the terraform unix executable and click open. 
    - *you can also follow these instructions to install terraform* ([link](https://learn.hashicorp.com/tutorials/terraform/install-cli))
 3.  Install `ansible` via `pip3 install ansible` to your local machine.
     - A terraform local-exec provisioner is used to invoke a local executable and run the ansible playbooks, so ansible must be installed on your local machine and the path needs to be updated.

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
