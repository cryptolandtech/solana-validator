#!/bin/bash
sudo apt-get update
sudo apt-get install -y npm
sudo npm install pm2@latest -g

curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.16.5/install/solana-install-init.sh | sh -s

#as a prerequisite you must attach a disk and mout it in /validator_data/
#gcp: sudo fdisk /dev/sdb; sudo mkfs.ext4 /dev/sdb1; sudo mount /dev/sdb1 /validator_data/
#aws: sudo fdisk /dev/nvme1n1; sudo mkfs.ext4 /dev/nvme1n1p1; 

#sudo mkdir /validator_data
sudo chown ubuntu /validator_data/
#gcp: sudo mount /dev/nvme1n1p1 /validator_data/
#aws sudo mount /dev/nvme1n1p1 /validator_data/

solana-install init --data-dir /validator_data/
export PATH="/validator_data/active_release/bin:$PATH"

#solana-keygen new -o /validator_data/validator-keypair.json
clear-config.sh
# solana-wallet -k /validator_data/validator-keypair.json airdrop 800000

#deprecated
#sed -i 's/\$program "\${args\[@\]}"/pm2 start \$program -- "\${args\[@\]}"/g' /validator_data/active_release/multinode-demo/fullnode.sh

#should use tds.solana.com 
##validator.sh --identity /validator_data/validator-keypair.json --no-airdrop --stake 500000 testnet.solana.com
#sudo mkdir /var/log/pm2
#sudo chown ubuntu:ubuntu /var/log/pm2
cat <<EOF >> ecosystem.config.js
module.exports = {
  apps : [{
    name: "validator",
    script: "fullnode.sh",
    cwd: "/validator_data/active_release/multinode-demo/"
    // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
    args: ["--validator", "--identity", "/validator_data/validator-keypair.json", "--stake", "500000", "testnet.solana.com"],
    error_file: "/var/log/pm2/validator-err.log",
    out_file: "/var/log/pm2/validator-out.log",
    merge_logs: true,
    instances: 1,
    autorestart: true,
    min_uptime: "100s",
    watch: false,
    //max_memory_restart: '1G',
  }],
};
EOF

pm2 start
