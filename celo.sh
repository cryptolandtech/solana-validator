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


export CELO_IMAGE=us.gcr.io/celo-testnet/celo-node:baklava
export NETWORK_ID=12219

docker pull $CELO_IMAGE

mkdir celo-accounts-node
cd celo-accounts-node
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "sleep 1 && geth account new"
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "sleep 1 && geth account new"

echo "export CELO_VALIDATOR_GROUP_ADDRESS=" > ~/.bashrc
echo "export CELO_VALIDATOR_ADDRESS=" > ~/.bashrc
source ~/.bashrc

# genesis and peers
docker run -v $PWD:/root/.celo $CELO_IMAGE init /celo/genesis.json
docker run -v $PWD:/root/.celo --entrypoint cp $CELO_IMAGE /celo/static-nodes.json /root/.celo/

#run the node
# On your local machine
docker run --name celo-accounts --restart always -p 8545:8545 -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --rpc --rpcaddr 0.0.0.0 --rpcapi eth,net,web3,debug,admin,personal

#run a validator

export CELO_IMAGE=us.gcr.io/celo-testnet/celo-node:baklava
export NETWORK_ID=12219
mkdir celo-validator-node
cd celo-validator-node
docker run -v $PWD:/root/.celo $CELO_IMAGE init /celo/genesis.json
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "sleep 1 && geth account new"
echo "export CELO_VALIDATOR_SIGNER_ADDRESS=" > ~/.bashrc
source ~/.bashrc

#create proof of possession
#export CELO_VALIDATOR_ADDRESS=<CELO-VALIDATOR-ADDRESS>
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "geth account proof-of-possession $CELO_VALIDATOR_SIGNER_ADDRESS $CELO_VALIDATOR_ADDRESS"

#save keys

echo "export CELO_VALIDATOR_SIGNER_ADDRESS=" > ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_SIGNATURE=" > ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_PUBLIC_KEY=" > ~/.bashrc
source ~/.bashrc

#prove possession
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "geth account proof-of-possession $CELO_VALIDATOR_SIGNER_ADDRESS $CELO_VALIDATOR_ADDRESS --bls"

#save signatures
echo "export CELO_VALIDATOR_SIGNER_BLS_SIGNATURE=" > ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_BLS_PUBLIC_KEY=" > ~/.bashrc
source ~/.bashrc

#unlock the keys
#celocli account:unlock --account ea267df8fbbbcd33acc8e87290e34a4d55691744


### proxy ###

echo "export CELO_IMAGE=us.gcr.io/celo-testnet/celo-node:baklava" > ~/.bashrc
source ~/.bashrc

mkdir celo-proxy-node
cd celo-proxy-node
docker run -v $PWD:/root/.celo $CELO_IMAGE init /celo/genesis.json
docker run -v $PWD:/root/.celo --entrypoint cp $CELO_IMAGE /celo/static-nodes.json /root/.celo/

# On the proxy machine
# Note that you'll have to export CELO_VALIDATOR_SIGNER_ADDRESS and $NETWORK_ID on this machine
export NETWORK_ID=12219
echo "export CELO_VALIDATOR_SIGNER_ADDRESS=f49e1283350c618c3ac84fbfecc90b1f8b6adfaa" >> ~/.bashrc
source ~/.bashrc

docker run --name celo-proxy --restart always -p 30313:30303 -p 30313:30303/udp -p 30503:30503 -p 30503:30503/udp -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --proxy.proxy --proxy.proxiedvalidatoraddress $CELO_VALIDATOR_SIGNER_ADDRESS --proxy.internalendpoint :30503 --etherbase $CELO_VALIDATOR_SIGNER_ADDRESS --ethstats=moonlet-proxy@baklava-ethstats.celo-testnet.org

