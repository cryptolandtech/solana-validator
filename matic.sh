 
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


#get private key
heimdalld show-privatekey

#show address
heimdalld show-account

#catchup?
curl http://localhost:26657/status|grep catching

#show block nb
curl http://localhost:26657/block
