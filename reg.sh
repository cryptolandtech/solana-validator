sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt upgrade -y
#go 1.13
sudo apt-get install -y golang-go make gcc python jq g++ build-essential

#Install regen
mkdir -p $GOPATH/src/github.com/regen
cd $GOPATH/src/github.com/regen
git clone -b v0.5.2 https://github.com/regen-network/regen-ledger
cd regen-ledger
make install

xrnd version --long
xrncli version --long



 xrnd init --chain-id=algradigon-1 Moonlet
 xrncli keys add moonlet

#get genesis
curl https://raw.githubusercontent.com/regen-network/testnets/master/algradigon-1/genesis.json > $HOME/.xrnd/config/genesis.json

#add peers
vi $HOME/.xrnd/config/config.toml
#seeds = "15ee12ae5fe8256ee94d1065e0000893e52532d9@regen-seed-eu.chorus.one:36656,ca130fd7ca16a957850a96ee9bdb74a351c4929f@regen-seed-us.chorus.one:36656"

ulimit -n 4096

https://github.com/regen-network/testnets
https://github.com/regen-network/testnets/blob/master/algradigon-1/upgrades/papua-upgrade-guide.md#configure-papua-upgrade

systemctl enable xrnd
systemctl start xrnd
journalctl -u xrnd -f --lines 50


xrncli keys show moonlet --bech=val
xrncli keys show moonlet

xrncli q account xrn:1czqefutujemr7cat6jxyvkeht26jkn2mdwf4z9 --chain-id algradigon-1

xrnd tendermint show-validator
xrnd tendermint show-address


xrncli tx staking create-validator --amount=9000000utree --pubkey=$(xrnd tendermint show-validator)   --moniker="Moonlet"   --chain-id=algradigon-1   --commission-rate="0.03"   --commission-max-rate="0.20"   --commission-max-change-rate="0.01"   --min-self-delegation="1"   --gas="auto"  --from=moonlet

#see votes
xrncli query gov votes 4 --chain-id algradigon-1 -o json --node localhost:26657|jq

#vote to proposal 4
xrncli tx gov vote 4 yes --from=moonlet --trust-node --node=localhost:26657 --chain-id=algradigon-1




#cosmos  Cosmos Account Address
#cosmospub  Cosmos Account Public Key
#cosmosvalcons  Cosmos Validator Consensus Address
#cosmosvalconspub  Cosmos Validator Consensus Public Key
#cosmosvaloper  Cosmos Validator Operator Address
#cosmosvaloperpub  Cosmos Validator Operator Public Key

git clone https://github.com/cosmos/cosmos-sdk.git
cd cosmos-sdk
git checkout v0.34.9; GO111MODULE=on; make install

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
