sudo apt update
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install apt-transport-https ca-certificates curl software-properties-common python npm nodejs

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
sudo npm install -g @celo/celocli

docker pull us.gcr.io/celo-testnet/celo-node:alfajores
mkdir celo-data-dir
cd celo-data-dir

#create account
#docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "sleep 1 && geth account new"

export CELO_ACCOUNT_ADDRESS=ea267df8fbbbcd33acc8e87290e34a4d55691744
echo "export CELO_ACCOUNT_ADDRESS=ea267df8fbbbcd33acc8e87290e34a4d55691744" >> ~/.bashrc

#get genesis
docker run -v $PWD:/root/.celo $CELO_IMAGE init /celo/genesis.json

#add peer
docker run -v $PWD:/root/.celo --entrypoint cp $CELO_IMAGE /celo/static-nodes.json /root/.celo/

#start node
docker run --name celo-fullnode -d --restart always -p 127.0.0.1:8545:8545 -p 127.0.0.1:8546:8546 -p 30303:30303 -p 30303:30303/udp -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --rpc --rpcaddr 0.0.0.0 --rpcapi eth,net,web3,debug,admin,personal --lightserv 90 --lightpeers 1000 --maxpeers 1100 --etherbase $CELO_ACCOUNT_ADDRESS







#run a validator
#pull docker image
docker pull us.gcr.io/celo-testnet/celo-node:alfajores

#create 2 more accounts
cd ~/celo-dir-data
docker run -v `pwd`:/root/.celo --entrypoint /bin/sh -it us.gcr.io/celo-testnet/celo-node:alfajores 
geth account new

docker run -v `pwd`:/root/.celo --entrypoint /bin/sh -it us.gcr.io/celo-testnet/celo-node:alfajores 
geth account new

echo "export CELO_VALIDATOR_GROUP_ADDRESS=" >> ~/.bashrc
echo "export CELO_VALIDATOR_ADDRESS=" >> ~/.bashrc
source ~/.bashrc

#generate proof of posesion
$ docker run -v `pwd`:/root/.celo --entrypoint /bin/sh -it us.gcr.io/celo-testnet/celo-node:alfajores -c "geth account proof-of-possession $CELO_VALIDATOR_ADDRESS"
echo "export CELO_VALIDATOR_POP=" >> ~/.bashrc
source ~/.bashrc


