sudo apt update
sudo apt upgrade -y

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go

sudo apt-get install make gcc python
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
