#ports
#no ingress ports required. only SSH 22

#sudo apt-get install software-properties-common
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt upgrade -y
#go 1.13
sudo apt-get install -y golang-go make gcc python jq liblz4-tool npm
sudo npm install -g pm2@latest 


mkdir go && echo "export GOPATH=$HOME/go" >> ~/.profile
source ~/.profile

mkdir -p $GOPATH/src/github.com/ElrondNetwork
cd $GOPATH/src/github.com/ElrondNetwork

git clone https://github.com/ElrondNetwork/elrond-go
cd elrond-go && git checkout tags/v1.0.20
git pull
cd ..
git clone https://github.com/ElrondNetwork/elrond-config
cd elrond-config && git checkout tags/dry-run-02-BoN
git pull

cp *.* ../elrond-go/cmd/node/config
cd ../elrond-go
GO111MODULE=on go mod vendor
cd cmd/node && go build -i -v -ldflags="-X main.appVersion=$(git describe --tags --long --dirty)"

#Generate keys
#cd ../keygenerator
#go build
#./keygenerator

cp initialBalancesSk.pem ./../node/config/
cp initialNodesSk.pem ./../node/config/
ulimit -n 65535
cd ../node
screen node -use-prometheus
Ctrl+A+D / screen -ls / screen -R
./node -use-log-view
