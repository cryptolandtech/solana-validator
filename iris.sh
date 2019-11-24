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

git clone --branch v0.15.4 https://github.com/irisnet/irishub
cd irishub
# source scripts/setTestEnv.sh # to build or install the testnet version
make get_tools install

iris version
iriscli version


iris init --moniker=titan --chain-id=irishub
curl -o ~/.iris/config/config.toml https://raw.githubusercontent.com/irisnet/mainnet/master/config/config.toml
curl -o ~/.iris/config/genesis.json https://raw.githubusercontent.com/irisnet/mainnet/master/config/genesis.json

iriscli keys add moonlet
iriscli keys list

#add pm2 file
pm2 start

#see if caught up
iriscli status | jq .sync_info.catching_up


