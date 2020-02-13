curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt update
apt install -y python3 python3-pip libffi-dev python3-dev python3-virtualenv python3-venv python3-dev gcc nodejs python-dev software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install -y ethereum

pip install --upgrade setuptools
pip install wheel cytoolz npm

#python3 -m venv ./nucypher-venv
#source nucypher-venv/bin/activate
#pip3 install -U nucypher

screen
#And create a new console by pressing ctrl+a and c. 
#View available consoles ctrl+a and w. select console ctrl+a and "console number".

#in each screen
source nucypher-venv/bin/activate
geth --goerli --syncmode light
#DETACH CTRL+A+D

screen
source nucypher-venv/bin/activate

geth attach /root/.ethereum/goerli/geth.ipc
personal.newAccount()
personal.newAccount()
eth.accounts
web3.toChecksumAddress(eth.accounts[0])
web3.toChecksumAddress(eth.accounts[1])
eth.syncing

exit


#Staker

#Link for requesting a test ETH https://goerli-faucet.slock.it/
#Link to discord NuCypher-bot  https://discord.gg/CmNNFjn
.getfunded <your_eth_checksumaddress>

nucypher stake init-stakeholder --provider ipc:///root/.ethereum/goerli/geth.ipc --network cassandra
nucypher stake create
nucypher stake restake --enable
nucypher stake list
nucypher stake set-worker

#Worker

#install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt-cache policy docker-ce
apt install docker-ce
systemctl status docker

nucypher ursula init --provider ipc:///root/.ethereum/goerli/geth.ipc --poa --network cassandra --staker-address <your staker address>

nucypher ursula run --interactive

export NUCYPHER_KEYRING_PASSWORD=<YOUR KEYRING_PASSWORD>
export NUCYPHER_WORKER_ETH_PASSWORD=<YOUR WORKER ETH ACCOUNT PASSWORD>

# Interactive Ursula-Worker Initialization
docker run -it -v ~/.ethereum:/root/.ethereum -v ~/.local/share/nucypher:/root/.local/share/nucypher -e NUCYPHER_KEYRING_PASSWORD nucypher:latest nucypher ursula init --provider file:///root/.ethereum/goerli/geth.ipc --staker-address <YOUR STAKING ADDRESS> --network <NETWORK_NAME>

# Daemonized Ursula
docker run -d -v ~/.ethereum:/root/.ethereum -v ~/.local/share/nucypher:/root/.local/share/nucypher -p 9151:9151 -e NUCYPHER_KEYRING_PASSWORD -e NUCYPHER_WORKER_ETH_PASSWORD nucypher/nucypher:latest nucypher ursula run

# https://IP:9151/status


#phaes2
nucypher stake restake --disable
nucypher stake windown --enable
