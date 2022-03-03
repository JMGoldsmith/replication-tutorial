# Build your own replication environment.

This repo will guide you through creating your own replication environments. We will first use Vagrant as it will allow you access to the host machine in order to understand what is going on inside the node. Next we will set up a Docker image and then deploy both locally and to various platforms for container orchestration.

## Working with this repo

This repo is intended to be educational. 

If you have changes to a tutorial you would like to make, or add your own, please create a new branch and open a PR. 


## Adding a tutorial

When adding a tutorial, we would like to ensure there are several criteria when creating the tutorial to ensure that it is easy to follow and has relevant links to further learning.

1. It should include a read me with step by step instructions. 
2. It should include a final project folder that does not include any images or secrets.
3. For container based tutorials any base images should be publicly accessible.
4. Any scripting or code should have examples and links to learning.
5. Try to use HashiCorp products where available. Terraform is great!
6. It should be reproducible across environments(except for ARM devices vs. Intel)
7. If using cloud resources, ensure that your tutorial has a way to remove the created resources _completely_.
8. Currently this is built for Vault but tutorials from the other support teams are very welcome!

### Naming and structure

1. Any final build of the tutorial should be labeled final-NAME.
2. tutorial guides will go in the `tutorial` folder. They should be labeled with number-platform-flavor, like 01-vagrant-raft.
3. This is subject to change, so make sure any dependencies or links can work if adjustments are made.