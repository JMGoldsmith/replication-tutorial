VAULT_NODE_COUNT = 3

Vagrant.configure("2") do |config|

  (1..VAULT_NODE_COUNT).each do |i|
    config.vm.define "vault-#{i}" do |node|
    config.vm.box = "ubuntu/bionic64"
    config.vm.provision "file", source: "config.hcl", destination: "$HOME/config.hcl"
    config.vm.provision "shell",
      path: "install_vault.sh",
      env: {"VAULT_RAFT_NODE_ID" => "raft_node_#{i}"}
    end
  end

end
