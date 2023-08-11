
################# redis cloud active active subscription
data "rediscloud_payment_method" "card" {
  card_type = var.cc_type
  last_four_numbers = var.cc_last_4
}

resource "rediscloud_active_active_subscription" "subscription-resource" {
    name = var.rediscloud_subscription_name
    payment_method_id = data.rediscloud_payment_method.card.id
    cloud_provider = "AWS"

    creation_plan {
      memory_limit_in_gb = var.rc_cp_memory_limit_in_gb
      quantity = var.rc_cp_quantity
      region {
          region = var.rc_region_1
          networking_deployment_cidr = var.rc_networking_deployment_cidr_1
          write_operations_per_second = var.rc_cp_write_operations_per_second_1
          read_operations_per_second = var.rc_cp_read_operations_per_second_1
      }
      region {
          region = var.rc_region_2
          networking_deployment_cidr = var.rc_networking_deployment_cidr_2
          write_operations_per_second = var.rc_cp_write_operations_per_second_2
          read_operations_per_second = var.rc_cp_read_operations_per_second_2
      }
    }
}

# ################# redis cloud active active subscription database
# resource "rediscloud_active_active_subscription_database" "database-resource" {
#     subscription_id = rediscloud_active_active_subscription.subscription-resource.id
#     name = var.rc_db_name
#     memory_limit_in_gb = var.rc_db_memory_limit_in_gb
#     global_data_persistence = var.rc_db_data_persistence
#     global_alert {
#     name = "dataset-size"
#     value = 70
#     }
 
#     override_region {
#         name = var.rc_region_1
#         override_global_data_persistence = "none"       
#    }
# }

# ################# redis cloud active active subscription regions 
# resource "rediscloud_active_active_subscription_regions" "regions-resource" {
#     subscription_id = rediscloud_active_active_subscription.subscription-resource.id
#     delete_regions = false
#     region {
#       region = var.rc_region_1
#       networking_deployment_cidr = var.rc_networking_deployment_cidr_1
#       database {
#             database_id = rediscloud_active_active_subscription_database.database-resource.db_id
#           database_name = rediscloud_active_active_subscription_database.database-resource.name
#             local_write_operations_per_second = var.local_write_operations_per_second_1
#             local_read_operations_per_second = var.local_read_operations_per_second_1
#       }
#     }
#     region {
#       region = var.rc_region_2
#       networking_deployment_cidr = var.rc_networking_deployment_cidr_2
#       database {
#             database_id = rediscloud_active_active_subscription_database.database-resource.db_id
#           database_name = rediscloud_active_active_subscription_database.database-resource.name
#             local_write_operations_per_second = var.local_write_operations_per_second_2
#             local_read_operations_per_second = var.local_read_operations_per_second_2
#       }
#     }
#  }