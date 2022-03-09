# An introduction to replicating with Vagrant.

This guide is intended to teach you how to build your own replication box using Vagrant as well as Integrated (Raft) Storage. It does not load any engines, initialize the box, or any other type of configuration other than getting you an environment you can play with.

It is recommended to install [VirtualBox](https://www.virtualbox.org/) for this tutorial. 

# M1 users

M1 users will not be able to use VirtualBox as it is not M1 compatible yet. There are options for using M1s, such as [Multipass](https://multipass.run/) and [Lima](https://github.com/lima-vm/lima). There will be other tutorials on setting these up.

## Your first vagrant box.

The Vagrant [documentation](https://www.vagrantup.com/docs/index) has more information on what Vagrant can do.

First, you will need to install Vagrant. For Mac users, simply run `brew install vagrant`. You can also download the binary and set it up yourself from the [downloads](https://www.vagrantup.com/downloads) page

First, create a directory, then add the `Vagrantfile` to that directory. In that file, add the following information:

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
end
```

You can view a list of available releases [here](https://app.vagrantup.com/boxes/search).

Once you save the file, simply run `vagrant up` and let the box provision itself. Once it has completed, you can access the VM by running `vagrant ssh`. 

## Scripting the install.

Now that you have your own VM, you will want to add some things to it. Normally you could just add them when you create the VM, but scripting the installation will allow you to repeat the installation and creation of these items. Create a file called install_vault.sh and place it in the top level of your directory with the Vagrantfile.

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