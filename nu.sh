sudo apt update


sudo apt install python3
apt install python3-pip
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
apt install libffi-dev
apt install python3-dev
apt install python3-virtualenv
apt-get install python3-venv
apt-get install python3-dev
apt-get install gcc

pip install --upgrade setuptools
pip install wheel
pip install cytoolz


#python3 -m venv ./nucypher-venv
source nucypher-venv/bin/activate

pip3 install -U nucypher
sudo apt install screen
screen
#And create a new console by pressing ctrl+a and c. 
#View available consoles ctrl+a and w. select console ctrl+a and "console number".
source nucypher-venv/bin/activate

#in each screen
source nucypher-venv/bin/activate

#install geth
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum

geth --goerli --syncmode light
