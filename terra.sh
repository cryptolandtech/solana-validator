sudo apt update
sudo apt upgrade -y

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

sudo apt-get install golang-go make gcc python jq
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$PATH" >> ~/.bashrc
source ~/.bashrc 

git clone https://github.com/terra-project/core/
cd core
#if there is a problem with golangci-lint, go to go.mod and add the latest version
make

terrad version --long
terracli version --long

#/etc/security/limits.conf
#*                soft    nofile          65535
#*                hard    nofile          65535

terrad init moonlet
wget https://raw.githubusercontent.com/terra-project/launch/master/columbus-2/columbus-2-genesis.json
mv columbus-2-genesis.json ../.terrad/config/genesis.json
vi ../.terrad/config/config.toml 
#add:
#seeds = "b416f0b04e2c71b8d76f993468352030e2dcf2a9@public-seed-node.columbus.certus.one:26656, 0621acccfc2c847e67d84eb234bcc26323a103c3@public-seed.terra.dev:26656, 46bba3a2c615ea5b569f086344f932fa11e81c01@public-seed2.terra.dev:26656"
#persistent_peers = "e6325ba7c490ba371135c9f3fcead66da1bd8cf1@terra-sentry01.dokia.cloud:26656, dba5defd7b120937da37aea7f37d06870637558d@terra-sentry02.dokia.cloud:26656, eb4ce12133c450ba6665e06309570ea2843e21d8@167.86.104.33:26656"
terrad unsafe-reset-all
terrad start
