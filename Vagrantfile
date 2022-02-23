VAULT_NODE_COUNT = 3

Vagrant.configure("2") do |config|

  (1..VAULT_NODE_COUNT).each do |i|
    config.vm.define "vault-#{i}" do |node|
      node.vm.box = "ubuntu/bionic64"
      node.vm.network "public_network", ip: "192.168.50.1#{i}", bridge: "en0: Wi-Fi (Wireless)"
      node.vm.provision "file", source: "vault.hclic", destination: "$HOME/"
      node.vm.provision "shell",
        path: "install_vault.sh"
      end
      
  end

end
