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
sudo sudo mkdir /var/log/pm2
sudo chown ubuntu:ubuntu /var/log/pm2/

curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.16.6/install/solana-install-init.sh | sh -s
export PATH="/home/ubuntu/.local/share/solana/install/active_release/bin:$PATH"

#sudo fdisk /dev/nvme1n1; 
#sudo mkfs.ext4 /dev/nvme1n1p1; 
#mkdir ~/validator-config
#sudo mount /dev/nvme1n1p1 ~/validator-config

#should use tds.solana.com 
#nohup validator.sh --identity ~/validator-config/validator-keypair.json --config-dir ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block testnet.solana.com &
nohup solana-install run validator.sh -- --identity ~/validator-config/validator-keypair.json --config-dir ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block testnet.solana.com &






#dry run 2
#curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.17.1/install/solana-install-init.sh | sh -s - 0.18.0-pre0

#check cluster status
solana-wallet -k ~/validator-keypair.json --url http://tds.solana.com:8899 balance
solana-gossip --entrypoint tds.solana.com:8001 spy

#run validator
validator.sh --identity ~/validator-keypair.json --voting-keypair ~/validator-vote-keypair.json --ledger ~/validator-config --rpc-port 8899 --poll-for-new-genesis-block tds.solana.com --no-airdrop

#validator catch up
solana-wallet -k ~/validator-keypair.json get-slot
solana-wallet -k ~/validator-keypair.json --url http://127.0.0.1:8899 get-slot

#stake
VOTE_PUBKEY=$(solana-keygen pubkey ~/validator-vote-keypair.json)
#solana-keygen new -o ~/validator-stake-keypair.json
solana-wallet -k ~/validator-keypair.json --url http://tds.solana.com:8899 delegate-stake ~/validator-stake-keypair.json $VOTE_PUBKEY 8589934592


#solana-wallet deactivate-stake ~/validator-stake-keypair.json



#Dryrun3 
##############

#curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.17.1/install/solana-install-init.sh | sh -s - 0.18.0-pre1

#check balance
solana-wallet --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 balance

#airdrop
solana-wallet -k validator-keypair.json --url http://tds.com:8899 airdrop 17179869184000

#check network
solana-gossip --entrypoint tds.solana.com:8001 spy
solana-wallet --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 ping

#run validator
nohup solana-validator --identity ~/validator-keypair.json --voting-keypair ~/validator-vote-keypair.json --ledger ~/volume/validator-config/ --rpc-port 8899 --entrypoint tds.solana.com:8001 &

#create vote account
solana-wallet --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 create-vote-account ~/validator-vote-keypair.json ~/validator-keypair.json 1

#get slot
solana-wallet --url http://127.0.0.1:8899 get-slot
solana-wallet  --url http://tds.solana.com:8899 get-slot

#after the validator cought up, add stake
solana-wallet --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 delegate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json 8589934592

#get epoch info
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getEpochInfo"}' http://localhost:8899

#get vote accounts
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVoteAccounts"}' http://localhost:8899|jq

#get leader schedule
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getLeaderSchedule"}' http://localhost:8899

#show stake info
solana-wallet show-stake-account ~/validator-stake-keypair.json

#deactivate stake before stopping the validator
#solana-wallet deactivate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getLeaderSchedule"}' http://localhost:8899




#Dryrun4 
##############

#sudo apt-get update
#sudo apt-get install -y npm
#sudo npm install pm2@latest -g
#sudo mkdir /var/log/pm2; sudo chown ubuntu:ubuntu /var/log/pm2


#Modify lambda function to point to tds.solana.com


#curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v0.18.0/install/solana-install-init.sh | sh -s - 0.18.0

#check balance
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 balance

#airdrop
#solana -k validator-keypair.json --url http://tds.solana.com:8899 airdrop 17179869184000

#check network
solana-gossip --entrypoint tds.solana.com:8001 spy
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 ping

#run validator
nohup solana-validator --identity ~/validator-keypair.json --voting-keypair ~/validator-vote-keypair.json --ledger ~/volume/validator-config/ --rpc-port 8899 --entrypoint tds.solana.com:8001 &

#create vote account
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 create-vote-account ~/validator-vote-keypair.json ~/validator-keypair.json 1

#get slot
solana --url http://127.0.0.1:8899 get-slot
solana  --url http://tds.solana.com:8899 get-slot
echo "me: $(solana --url http://127.0.0.1:8899 get-slot | grep '^[0-9]\+$'), cluster: $(solana --url http://tds.solana.com:8899 get-slot | grep '^[0-9]\+$')"

#after the validator cought up, add stake
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 delegate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json 8589934592

#publish info
solana-validator-info publish -u http://tds.solana.com:8899 -w "http://moonlet.xyz" -d "moonlet validator" ~/validator-keypair.json moonlet

#get epoch info
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getEpochInfo"}' http://localhost:8899

#get vote accounts
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVoteAccounts"}' http://localhost:8899|jq

#get leader schedule
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getLeaderSchedule"}' http://localhost:8899|jq

#show stake info
solana show-stake-account ~/validator-stake-keypair.json

#get public key
solana -k ~/validator-keypair.json -u http://tds.solana.com:8899 address

#aproximative uptime
solana show-vote-account ~/validator-vote-keypair.json
#for each epoch, roughly credits earned / slots in epoch

#crate a new voting key
solana-keygen new -o ~/validator-vote-keypair.json

#deactivate stake before stopping the validator
#solana deactivate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json 


######Restart validator

#undelegate
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 deactivate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json

#stop validator
pm2 stop 0

#recreate vote key
solana-keygen new -o ~/validator-vote-keypair.json

#recreate vote account
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 create-vote-account ~/validator-vote-keypair.json ~/validator-keypair.json 1

#start validator
pm2 start

#recreate stake key
solana-keygen new -o ~/validator-stake-keypair.json

#wait to catchup & delegate
echo "me: $(solana --url http://127.0.0.1:8899 get-slot | grep '^[0-9]\+$'), cluster: $(solana --url http://tds.solana.com:8899 get-slot | grep '^[0-9]\+$')"
solana --keypair ~/validator-keypair.json --url http://tds.solana.com:8899 delegate-stake ~/validator-stake-keypair.json ~/validator-vote-keypair.json 8589934592


