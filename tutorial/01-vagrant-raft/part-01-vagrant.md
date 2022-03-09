# An introduction to replicating with Vagrant.

## Your first vagrant box.
https://www.vagrantup.com/docs/index

Install Vagrant - `brew install vagrant`
https://www.vagrantup.com/downloads

Vagrantfile

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
end
```

`vagrant up`

## Scripting the install.

### Installing Vault and other pieces
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault-enterprise
sudo apt-get -y install jq
sudo apt-get -y install tree

export HOSTIP=$(hostname -I | cut -d' ' -f2)
```

### Setting up the Vault configuration file

tee > /etc/vault.d/vault.hcl << EOF
listener "tcp" {
  address = "$HOSTIP:8200"
  tls_disable = 1
}

license_path="/home/vagrant/vault.hclic"

EOF

### Setting it up in Vagrant

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
  node.vm.provision "shell",
    path: "install_vault.sh"
  end
end
```

## Your license file

https://license.hashicorp.services/

## Copying files.

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
  node.vm.provision "file", source: "vault.hclic", destination: "$HOME/"
  node.vm.provision "shell",
    path: "install_vault.sh"
  end
end
```



## unsealing 

vault operator init -key-shares=1 -key-threshold=1