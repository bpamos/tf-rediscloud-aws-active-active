
output "private_endpoint" {
  description = "A map of which private endpoints can to access the database per region, uses region name as key."
  value = rediscloud_active_active_subscription_database.database-resource.private_endpoint
}

output "private_endpoints_list" {
  description = "A list of private endpoints per region."
  value = [
    for region, endpoint in rediscloud_active_active_subscription_database.database-resource.private_endpoint : {
      region = region
      endpoint = {
        hostname = regex("^(.*):\\d+$", endpoint)[0] // Extract hostname
        port     = regex(":(\\d+)$", endpoint)[0]    // Extract port
      }
    }
  ]
}