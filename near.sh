sudo hostnamectl set-hostname near
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common python
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}

git clone https://github.com/nearprotocol/nearcore.git
cd nearcore
sudo ./scripts/start_stakewars.py --init --account-id=moonletX
sudo ./scripts/start_stakewars.py --init --signer-keys --account-id=moonletX
