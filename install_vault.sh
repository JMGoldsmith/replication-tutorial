#!/bin/bash

# install vault and tools
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault-enterprise
sudo apt-get -y install jq
sudo apt-get -y install tree

# cmod 700 /home/vagrant

# set up license.

tee > /etc/vault.d/vault.hcl << EOF
listener "tcp" {
  address = "$HOSTIP:8200"
  tls_disable = 1
}

licence_path="/opt/vault/vault.hclic"

storage "raft" {
  path = "/opt/vault/data"
  node_id = "raft_node_$ID"
  retry_join {
    leader_api_addr = "http://192.168.50.11:8200"
  }
  retry_join {
    leader_api_addr = "http://192.168.50.12:8200"
  }
  retry_join {
    leader_api_addr = "http://192.168.50.13:8200"
  }
}

cluster_addr = "http://$HOSTIP:8201"
api_addr = "http://$HOSTIP:8200"
EOF