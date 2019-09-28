sudo apt update
sudo apt upgrade -y

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update

sudo apt-get install golang-go make gcc python jq
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$PATH" >> ~/.bashrc
source ~/.bashrc 

https://github.com/cosmos/gaia.git
cd gaia & make install

curl https://raw.githubusercontent.com/cosmos/launch/master/genesis.json > $HOME/.gaiad/config/genesis.json

#add seeds = "35b9658ca14dd4908b37f327870cbd5007ee06f1@116.203.146.149:26656" in .gaiad/config/config.toml
#get seeds from https://github.com/cosmos/testnets

gaiad unsafe-reset-all

gaiad tendermint show-validator

gaiad start

#show status, if caught up
gaiacli status|jq

#show keys
#show address and pk
gaiacli keys list

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
gaiacli tx staking create-validator --commission-max-change-rate=0.1  --commission-max-rate=0.1 --commission-rate=0.1 --min-self-delegation=1 --amount 100000muon --pubkey=<cosmosvalconspub1> --moniker=<name> --chain-id="gaia-13006" --from=moonlet

#see all staking validators
gaiacli q staking validators --chain-id=gaia-13006

#delegate to your validator

