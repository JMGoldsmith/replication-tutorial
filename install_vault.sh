#!/bin/bash

# install vault and tools
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault-enterprise
sudo apt-get -y install jq
sudo apt-get -y install tree
# cmod 700 /home/vagrant

# set up license.
echo 'export VAULT_LICENSE=02MV4UU43BK5HGYYTOJZWFQMTMNNEWU33JJVVGWMKZNJITITL2IF2E22TLGVHHSMLNJZCFU2CMKRBGWWSEJV2E23KNGFMVIRTJLFLVM2KZNJMTGSLJO5UVSM2WPJSEOOLULJMEUZTBK5IWST3JJJWU4MSZPFHFI2DNLFUTC22OPJCTATCXJV4U2V2ZORHEITTLJVJTANKONJUGQWTKLE2VS6SNGFGTETLJJRBUU4DCNZHDAWKXPBZVSWCSOBRDENLGMFLVC2KPNFEXCSLJO5UWCWCOPJSFOVTGMRDWY5C2KNETMSLKJF3U22SFORGVIRLUJVCEMVKNKRCTMTKUJU3E4VCBOVGWUZ3YJZCFSMCNNJTXUV3JJFZUS3SOGBMVQSRQLAZVE4DCK5KWST3JJF4U2RCJPBGFIRLYJRKEC6CWIRAXOT3KIF3U62SBO5LWSSLTJFWVMNDDI5WHSWKYKJYGEMRVMZSEO3DULJJUSNSJNJEXOTLKJF2E2VCFORGUIRSVJVVE2NSOKRVTMTSUNN2U6VDLGVLWSSLTJFXFE3DDNUYXAYTNIYYGCVZZOVMDGUTQMJLVK2KPNFEXSTKEJF4UYVCFPBGFIQLYKZCES6SPNJKTKT3KKU2UY2TLGVHVM33JJRBUU53DNU4WWZCXJYYES2TPNFSG2RRRMJEFC2KMINFG2YSHIZXGG6KJGZSXSSTUMIZFEMLCI5LHUSLKOBRES3JRGFREQUTQJRLVE2SMLBHGUWKXPBWES2LXNFNDEOJSLJMEU5KZK42WUWSTGF3WEMTYOBMTG23JJRBUU2C2JBNGQYTNJZWFUQZRNNMVQUTIJRMEE6LCGNJGYWJTKJYGEMRUNFGEGSTILJEFU2DCNVHGYWSDGFVVSWCSNBGFQQTZMIZVE3CZGNJHAYRSGR2GCMSWGVGFOMLIMJWUM3S2K4YWYYTOKFUVQWBRHEXGCURWG5ZVM3SKNMZVC3KBG52DIL2PI5DHOV3WIR4HQRD2JBTFQUTKKFGWCRTXNR3DKMTZIZLUY23XIJFS62DZKNDTO2TDIJ2XEYLJIVZUMSCYJJ2EYQSYPEXUUQKMNU2EMVRVNJCHAMLEIFVWGYJUMRLDAMZTHBIHO3KWNRQXMSSQGRYEU6CJJE4UINSVIZGFKYKWKBVGWV2KORRUINTQMFWDM32PMZDW4SZSPJIEWSSSNVDUQVRTMVNHO4KGMUVW6N3LF5ZSWQKUJZUFAWTHKMXUWVSZM4XUWK3MI5IHOTBXNJBHQSJXI5HWC2ZWKVQWSYKIN5SWWMCSKRXTOMSEKE6T2' >> /home/vagrant/.bashrc

tee > config.hcl << EOF
listener "tcp" {
  address = "$HOSTIP:8200"
  tls_disable = 1
}

licence_path="/home/vagrant/vault.hclic"

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