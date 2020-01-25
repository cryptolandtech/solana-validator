sudo apt update
sudo apt install python3
sudo apt install libffi-dev
sudo apt install python3-dev
sudo apt install python3-virtualenv
sudo apt-get install python3-venv
sudo apt-get install python3-dev

python3 -m venv ./nucypher-venv
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
