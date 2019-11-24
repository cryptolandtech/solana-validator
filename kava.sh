#cosmos  Cosmos Account Address
#cosmospub  Cosmos Account Public Key
#cosmosvalcons  Cosmos Validator Consensus Address
#cosmosvalconspub  Cosmos Validator Consensus Public Key
#cosmosvaloper  Cosmos Validator Operator Address
#cosmosvaloperpub  Cosmos Validator Operator Public Key

echo '* soft nofile 65536' | sudo tee -a /etc/security/limits.conf
echo '* hard nofile 65536' | sudo tee -a /etc/security/limits.conf
echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session
prlimit --pid `pidof gaiad` --nofile=65536:65536

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$PATH" >> ~/.bashrc
#source ~/.bashrc

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt upgrade -y
#go 1.13
sudo apt-get install -y golang-go make gcc python jq liblz4-tool npm
sudo npm install pm2@latest -g

git clone https://github.com/Kava-Labs/kava.git
cd kava
git checkout v0.3.1 ; GO111MODULE=on; make install


kvd init titan --chain-id kava-1
kvcli keys add moonlet
kvcli keys list

#get genesis
get https://raw.githubusercontent.com/Kava-Labs/launch/master/kava-2/genesis.json -P ~/.kvd/config --backups=1

#seeds
#"c6e38d744462377273926daaf36816b96596f332@34.84.191.117:26656,ab1b544f594becea2a0af3c964568431896c03a4@35.228.68.223:26656,34870045ec4bd17ac2bbad23b7c15faf0186cbd4@140.82.8.156:26656,d21edfd1bdde037a2402e2eabf064cd8cd4b49b9@54.39.182.190:26656,43a8004ece305e1d9407d00bb26958591cbf8ce2@kava01.dokia.cloud:26656,c4ff82fa0cdcc60cea7551d5c9a179926ee622ed@51.68.172.150:26656,b1bcd6969f03940032f7f9c315ff3bbc1ee8cd20@185.181.103.135:26656,aafd0790e2abdffa44852eb33f9864904affbaa5@18.197.230.170:26656,43040b8c9516e2d7fc0b95f2e070a3cb37dc6c2e@35.245.180.181:26656"

#add pm2 file
pm2 start

#see if caught up
kvcli status |jq









gaiad version --long
gaiad init moonlet
#gaiad unsafe-reset-all

vi .gaiad/config/gaiad.toml 
#minimum-gas-prices = "0.025uatom"

curl https://raw.githubusercontent.com/cosmos/launch/master/genesis.json > $HOME/.gaiad/config/genesis.json
wget http://quicksync.chainlayer.io/cosmos/cosmoshub-2.20190924.0605.tar.lz4	
lz4 -d  cosmoshub-2.20190924.0605.tar.lz4| tar xf -

#add seeds in .gaiad/config/config.toml
#seeds = "3e16af0cead27979e1fc3dac57d03df3c7a77acc@3.87.179.235:26656,ba3bacc714817218562f743178228f23678b2873@public-seed-node.cosmoshub.certus.one:26656" 
#get seeds from https://github.com/cosmos/launch or https://github.com/cosmos/gaia/blob/master/docs/join-mainnet.md

gaiad tendermint show-validator

gaiad start

#show status, if caught up
gaiacli status|jq

#show keys
#show address and pk
gaiacli keys list

#see valoper keys
gaiacli keys show moonlet --bech=val

#create new key
gaiacli keys add moonlet

#
gaiacli q account cosmos1wk7cej3utkgxexktwlf20x7zlv4575w8kafq8k --chain-id gaia-13006

#get validatior cosmosvalconspub
gaiad tendermint show-validator

#get validator address
gaiad tendermint show-address

#see your account
gaiacli q account <cosmosvalconspub>

#create a validator
gaiacli tx staking create-validator  --amount=1000000uatom --pubkey=$(gaiad tendermint show-validator) --moniker="moonlet" --chain-id=cosmoshub-2 --commission-rate="0.10" --commission-max-rate="0.20" --commission-max-change-rate="0.01" --min-self-delegation="1" --gas="auto" --gas-prices="0.025uatom" --from=moonlet

#verify you validator
gaiacli tx slashing unjail --from moonlet --chain-id=gaia-13006

#see all staking validators
gaiacli q staking validators --chain-id=gaia-13006


#get cosmosvaloper address
gaiacli keys show moonlet --bech=val

#delegate
gaiacli tx staking delegate cosmosvaloper 100muon --from account_name --gas auto --gas-adjustment 1.5 --chain-id=gaia-13006

#you should appear here
#https://hubble.figment.network/cosmos/chains/gaia-13006




#see all peers
curl -s http://localhost:26657/net_info |grep n_peers
 
#see valoper keys
gaiacli keys show moonlet --bech=val
 
#see validator details
gaiacli query staking validator cosmosvaloper --chain-id=gaia-1300

#check voting progress, jailed status, ..
gaiacli query slashing signing-info cosmosvalconspub --chain-id=gaia-13006

#check if validator is jailed
gaiacli q staking validator --validator cosmosvaloper... --trust-node

#unjail in case of downtime
gaiacli tx slashing unjail --from moonlet --chain-id=gaia-13006

#show voting. get address 
curl 0:26657/consensus_state

#peers that i'm connected to
curl 0:26657/net_info

#byte_address can be found in priv_validator_key.json

# get my peer info. node_id@ip:port (node_id found using gaiad tendermint show-node-id)
# gaiad tendermint show-node-id

#check if you have voted
curl localhost:26657/consensus_state -s | grep $(gaiacli status | jq -r .validator_info.address[:12])
