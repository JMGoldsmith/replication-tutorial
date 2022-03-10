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

In the install_vault.sh script, place the following:

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault-enterprise
sudo apt-get -y install jq
sudo apt-get -y install tree

export HOSTIP=$(hostname -I | cut -d' ' -f2)
```

This will install the most recent version of Vault enterprise. If you need to change the version, simply add an `=` to the end of the install binary, like `vault-enterprise=1.8.1+ent`.
It will also install the tools `tree` and `jq`. You can install other items as needed by adding them to the script.

### Setting up the Vault configuration file

After the above stanza, you will want to add the following block as well. This will write you Vault configuration file to `/etc/vault.d/vault.hcl`. 

```
tee > /etc/vault.d/vault.hcl << EOF
listener "tcp" {
  address = "$HOSTIP:8200"
  tls_disable = 1
}

storage "raft" {
 path    = "$HOME/raft-vault/"
}

license_path="/home/vagrant/vault.hclic"

EOF
```

### Setting it up in Vagrant

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
  node.vm.provision "shell",
    path: "install_vault.sh"
  end
end
```

### Your license file

https://license.hashicorp.services/

### Copying files.

```
Vagrant.configure("2") do |config|
  node.vm.box = "ubuntu/bionic64"
  node.vm.provision "file", source: "vault.hclic", destination: "$HOME/"
  node.vm.provision "shell",
    path: "install_vault.sh"
  end
end
```

## Adding your script

To add the changes you have made, simply run `vagrant provision`. As you add more files or do not wish to re-provision other existing pieces, simply run `vagrant provision --provision-with shell` to re-provision the `shell` provisioner or the other provisioners you have created.

## unsealing 

To unseal Vault, start the server using `vault server -config=/etc/vault.d/vault.hcl` and then `vault operator init -key-shares=1 -key-threshold=1`. This will initialize your single vault node and return 1 root token and one unseal key.