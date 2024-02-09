#### Generate ansible playbook for memtier from template file, 
#### run memtier data load and benchmark commands from tester node

#### Sleeper, just to make sure nodes module is complete and everything is installed
resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}

##### Generate extra_vars.yaml file
resource "local_file" "jedis-failover-app" {
    content  = templatefile("${path.module}/ansible/jedis_playbook.yaml.tpl", {
      private_endpoints_hostname1 = var.private_endpoints_list[0].endpoint.hostname
      private_endpoints_port1     = var.private_endpoints_list[0].endpoint.port
      db_password1                = var.rc_db_password
      private_endpoints_hostname2 = var.private_endpoints_list[1].endpoint.hostname
      private_endpoints_port2     = var.private_endpoints_list[1].endpoint.port
      db_password2                = var.rc_db_password
    })
    filename = "${path.module}/ansible/${var.vpc_name}_jedis_playbook.yaml"
}

