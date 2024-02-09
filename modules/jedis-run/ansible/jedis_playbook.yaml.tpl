---

- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  gather_facts: yes

  tasks:
    - name: jedis failover run cmd
      command: "mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args="--failover true --host ${private_endpoints_hostname1} --port ${private_endpoints_port1} --password ${db_password1} --host2 ${private_endpoints_hostname2} --port2 ${private_endpoints_port2} --password2 ${db_password2}""

