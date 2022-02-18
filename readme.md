# Test-all environment

For quickly testing an integrated storage environment

## Usage

Spin up a fresh set when testing auto-unseal.

To change the config, update the config in the `install_vault.sh` file.

Run `vagrant provision --provision-with shell`

# Todo:

Add auto-unseal for AWS, GCP, Azure and Transit. Can also use soft HSM if needed.
Create TF for each type of seal.
Move this in to AWS. https://github.com/mitchellh/vagrant-awss

https://wiki.opendnssec.org/display/SoftHSMDOCS
https://azure.microsoft.com/en-us/services/key-vault/
https://aws.amazon.com/kms/
https://cloud.google.com/docs/authentication/getting-started

GCP kms will need to be recreated every so often due to accounts being wiped out.
