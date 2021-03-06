#!/bin/bash

# install vault and tools
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul-enterprise
sudo apt-get -y install jq
sudo apt-get -y install tree

export HOSTIP=$(hostname -I | cut -d' ' -f2)
export ID=$(echo ${HOSTIP: -1})
export VAULT_ADDR="http://${HOSTIP}:8200"
echo "export VAULT_ADDR=${VAULT_ADDR}" >> /home/vagrant/.bashrc
# set up license.

tee > /etc/vault.d/vault.hcl << EOF
listener "tcp" {
  address = "$HOSTIP:8200"
  cluster_address = "$HOSTIP:8201"
  tls_disable = 1
}

license_path="/opt/vault/vault.hclic"

storage "raft" {
  path = "/opt/vault/data"
  node_id = "raft_node_$ID"
  leader_api_addr = "http://192.168.50.21:8200"
  retry_join {
    leader_api_addr = "http://192.168.50.21:8200"
  }
  retry_join {
    leader_api_addr = "http://192.168.50.22:8200"
  }
  retry_join {
    leader_api_addr = "http://192.168.50.23:8200"
  }
}

cluster_addr = "http://$HOSTIP:8201"
api_addr = "http://$HOSTIP:8200"
EOF

mv /home/vagrant/vault.hclic /opt/vault/vault.hclic
chown vault: /opt/vault/vault.hclic

sudo systemctl enable vault.service
sudo systemctl start vault.service