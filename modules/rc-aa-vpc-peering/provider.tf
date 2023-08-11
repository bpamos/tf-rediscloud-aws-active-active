terraform {
 required_providers {
   rediscloud = {
     source = "RedisLabs/rediscloud"
     version = "1.3.1"
   }
   aws = {
      source = "hashicorp/aws"
   } 
 }
}