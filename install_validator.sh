#!/bin/bash
curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.16.5/install/solana-install-init.sh | sh -s

#as a prerequisite you must attach a disk and mout it in /validator_data/
#sudo fdisk /dev/sdb; sudo mkfs.ext4 /dev/sdb1; sudo mount /dev/sdb1 /validator_data/
#sudo fdisk /dev/nvme1n1; sudo mkfs.ext4 /dev/nvme1n1p1; sudo mount /dev/nvme1n1p1 /validator_data/
solana-install init --data-dir /validator_data/

solana-keygen new -o ~/validator-keypair.json
clear-config.sh
solana-wallet -k ~/validator-keypair.json airdrop 800000
sudo apt-get install -y npm
sudo npm install pm2@latest -g

#for now we modify the fullnode.sh to use pm2
sed -i 's/\$program "\${args\[@\]}"/pm2 start \$program -- "\${args\[@\]}"/g' ~/.local/share/solana/install/releases/FcjCCW5gydpAJbnxXGxiKQD7jccpVxojGqvmzMtyQ8AV/solana-release/multinode-demo/fullnode.sh

#should use tds.solana.com 
validator.sh --identity ~/validator-keypair.json --no-airdrop --stake 500000 testnet.solana.com

