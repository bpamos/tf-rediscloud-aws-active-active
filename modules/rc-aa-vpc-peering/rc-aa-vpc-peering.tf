
############################# Peering 1
resource "rediscloud_active_active_subscription_peering" "peering-resource" {
   subscription_id = var.rediscloud_aa_subscription_id
   source_region = var.rc_region #requester (Redis Cloud VPC)
   destination_region = var.aws_customer_application_vpc_region  #accepter (applicaiton VPC)
   aws_account_id = var.aws_customer_application_aws_account_id #aws account Id
   vpc_id = var.aws_customer_application_vpc_id #accepter VCP id (destination)
   vpc_cidr = var.aws_customer_application_vpc_cidr #accepter VCP cidr (destination)
}

resource "aws_vpc_peering_connection_accepter" "aws-peering-resource" {
  vpc_peering_connection_id = rediscloud_active_active_subscription_peering.peering-resource.aws_peering_id
  auto_accept               = true

}


# Declare the data source
data "aws_vpc_peering_connection" "pc" {
  peer_vpc_id     = var.aws_customer_application_vpc_id
  peer_cidr_block = var.aws_customer_application_vpc_cidr #AWS Customer VPC CIDR block
  cidr_block      = var.rc_networking_deployment_cidr #Redis Cloud Subscription VPC CIDR block
  status          = "active"

  depends_on      = [aws_vpc_peering_connection_accepter.aws-peering-resource]
}

## output of the sub id
output "aws_vpc_peering_connection" {
  value = data.aws_vpc_peering_connection.pc.id
}

# Create a route
resource "aws_route" "r1" {
  route_table_id            = var.aws_vpc_route_table_id
  destination_cidr_block    = var.rc_networking_deployment_cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.pc.id
}