curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt update
apt install -y python3 python3-pip libffi-dev python3-dev python3-virtualenv python3-venv python3-dev gcc nodejs python-dev software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install -y ethereum

ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip

pip install --upgrade setuptools
pip install wheel cytoolz pm

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
exit

#Link for requesting a test ETH https://goerli-faucet.slock.it/
#Link to discord NuCypher-bot  https://discord.gg/CmNNFjn
.getfunded <your_eth_checksumaddress>

nucypher stake init-stakeholder --provider ipc:///root/.ethereum/goerli/geth.ipc --network cassandra
nucypher stake create
nucypher stake restake --enable
nucypher stake list


#Worker
nucypher ursula init --provider ipc:///home/<your_username>/.ethereum/goerli/geth.ipc --poa --network cassandra --staker-address <your staker address>
nucypher stake set-worker

nucypher ursula run --teacher discover.nucypher.network:9151 --interactive


