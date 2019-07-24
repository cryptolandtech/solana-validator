#!/bin/bash
sudo apt-get update
sudo apt-get install -y npm
sudo npm install pm2@latest -g

curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.16.6/install/solana-install-init.sh | sh -s
export PATH="/home/ubuntu/.local/share/solana/install/active_release/bin:$PATH"

#as a prerequisite you must attach a disk and mout it in ~/validator-config
#gcp: sudo fdisk /dev/sdb; sudo mkfs.ext4 /dev/sdb1; 
#aws: sudo fdisk /dev/nvme1n1; sudo mkfs.ext4 /dev/nvme1n1p1; 

#mkdir ~/validator-config
#gcp: sudo mount /dev/nvme1n1p1 ~/validator-config
#aws sudo mount /dev/nvme1n1p1 ~/validator-config

#solana-keygen new -o ~/validator-config/validator-keypair.json
# solana-wallet -k ~/validator-config/validator-keypair.json airdrop 800000


#deprecated
#sed -i 's/\$program "\${args\[@\]}"/pm2 start \$program -- "\${args\[@\]}"/g' /validator_data/active_release/multinode-demo/fullnode.sh

#should use tds.solana.com 
##validator.sh --identity ~/validator-config/validator-keypair.json --config-dir ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block testnet.solana.com
#sudo mkdir /var/log/pm2
#sudo chown ubuntu:ubuntu /var/log/pm2
cat <<EOF >> ecosystem.config.js
module.exports = {
  apps : [{
    name: "validator",
    script: "solana-install",
    cwd: "/home/ubuntu/.local/share/solana/install/active_release/bin/",
    args: ["run", "validator.sh", "--", "--identity", "~/validator-config/validator-keypair.json", "--config-dir", "~/validator-config", "--rpc-port", "8899", "--poll-for-new-genesis-block", "testnet.solana.com"],
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


#the above is not working after 0.1.16 release. do the following

#!/bin/bash
sudo apt-get update
sudo apt-get install -y npm
sudo npm install pm2@latest -g

curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.16.6/install/solana-install-init.sh | sh -s
export PATH="/home/ubuntu/.local/share/solana/install/active_release/bin:$PATH"

#sudo fdisk /dev/nvme1n1; 
#sudo mkfs.ext4 /dev/nvme1n1p1; 
#mkdir ~/validator-config
#sudo mount /dev/nvme1n1p1 ~/validator-config

#should use tds.solana.com 
#nohup validator.sh --identity ~/validator-config/validator-keypair.json --config-dir ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block testnet.solana.com &
nohup solana-install run validator.sh -- --identity ~/validator-config/validator-keypair.json --config-dir ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block testnet.solana.com &
