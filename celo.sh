curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common python nodejs

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

echo "export CELO_VALIDATOR_GROUP_ADDRESS=" >> ~/.bashrc
echo "export CELO_VALIDATOR_ADDRESS=" >> ~/.bashrc
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
echo "export CELO_VALIDATOR_SIGNER_ADDRESS=" >> ~/.bashrc
source ~/.bashrc

#create proof of possession
#export CELO_VALIDATOR_ADDRESS=<CELO-VALIDATOR-ADDRESS>
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "geth account proof-of-possession $CELO_VALIDATOR_SIGNER_ADDRESS $CELO_VALIDATOR_ADDRESS"

#save keys

echo "export CELO_VALIDATOR_SIGNER_ADDRESS=" >> ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_SIGNATURE=" >> ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_PUBLIC_KEY=" >> ~/.bashrc
source ~/.bashrc

#prove possession
docker run -v $PWD:/root/.celo --entrypoint /bin/sh -it $CELO_IMAGE -c "geth account proof-of-possession $CELO_VALIDATOR_SIGNER_ADDRESS $CELO_VALIDATOR_ADDRESS --bls"

#save signatures
echo "export CELO_VALIDATOR_SIGNER_BLS_SIGNATURE=" >> ~/.bashrc
echo "export CELO_VALIDATOR_SIGNER_BLS_PUBLIC_KEY=" >> ~/.bashrc
source ~/.bashrc

#unlock the keys
#celocli account:unlock --account ea267df8fbbbcd33acc8e87290e34a4d55691744


### proxy ###

echo "export CELO_IMAGE=us.gcr.io/celo-testnet/celo-node:baklava" >> ~/.bashrc
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

docker run --name celo-proxy --restart always -p 30303:30303 -p 30303:30303/udp -p 30503:30503 -p 30503:30503/udp -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --proxy.proxy --proxy.proxiedvalidatoraddress $CELO_VALIDATOR_SIGNER_ADDRESS --proxy.internalendpoint :30503 --etherbase $CELO_VALIDATOR_SIGNER_ADDRESS --ethstats=moonlet-proxy@baklava-ethstats.celo-testnet.org


# get enode and ip
echo $(docker exec celo-proxy geth --exec "admin.nodeInfo['enode'].split('//')[1].split('@')[0]" attach | tr -d '"')
#echo $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' celo-proxy)

echo "export PROXY_ENODE=" >> ~/.bashrc
echo "export export PROXY_IP==" >> ~/.bashrc
source ~/.bashrc

#on the Validator, connect to proxy
# On the validator machine
echo <VALIDATOR-SIGNER-PASSWORD> > .password
docker run --name celo-validator --restart always -p 30303:30303 -p 30303:30303/udp -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --mine --istanbul.blockperiod=5 --istanbul.requesttimeout=3000 --etherbase $CELO_VALIDATOR_SIGNER_ADDRESS --nodiscover --proxy.proxied --proxy.proxyenodeurlpair=enode://$PROXY_ENODE@$PROXY_IP:30503\;enode://$PROXY_ENODE@$PROXY_IP:30303  --unlock=$CELO_VALIDATOR_SIGNER_ADDRESS --password /root/.celo/.password --ethstats=<YOUR-VALIDATOR-NAME>@baklava-ethstats.celo-testnet.org


#check balance
celocli account:balance $CELO_VALIDATOR_GROUP_ADDRESS
celocli account:balance $CELO_VALIDATOR_ADDRESS

#unlock accounts
# On your local machine
celocli account:unlock --account $CELO_VALIDATOR_GROUP_ADDRESS
celocli account:unlock --account $CELO_VALIDATOR_ADDRESS

#register name
celocli account:register --from $CELO_VALIDATOR_GROUP_ADDRESS --name moonlet
celocli account:register --from $CELO_VALIDATOR_ADDRESS --name moonlet1

# show details
celocli account:show $CELO_VALIDATOR_GROUP_ADDRESS
celocli account:show $CELO_VALIDATOR_ADDRESS

# Lock up gold
celocli lockedgold:lock --from $CELO_VALIDATOR_GROUP_ADDRESS --value 10000000000000000000000
celocli lockedgold:lock --from $CELO_VALIDATOR_ADDRESS --value 10000000000000000000000

#show lock details
celocli lockedgold:show $CELO_VALIDATOR_GROUP_ADDRESS
celocli lockedgold:show $CELO_VALIDATOR_ADDRESS


#run for election
#register validator signing key
celocli account:authorize --from $CELO_VALIDATOR_ADDRESS --role validator --signature 0x$CELO_VALIDATOR_SIGNER_SIGNATURE --signer 0x$CELO_VALIDATOR_SIGNER_ADDRESS

#check key
celocli account:show $CELO_VALIDATOR_ADDRESS

#register group
celocli validatorgroup:register --from $CELO_VALIDATOR_GROUP_ADDRESS --commission 0.1

# show group
celocli validatorgroup:show $CELO_VALIDATOR_GROUP_ADDRESS

#register validator
celocli validator:register --from $CELO_VALIDATOR_ADDRESS --ecdsaKey $CELO_VALIDATOR_SIGNER_PUBLIC_KEY --blsKey $CELO_VALIDATOR_SIGNER_BLS_PUBLIC_KEY --blsSignature $CELO_VALIDATOR_SIGNER_BLS_SIGNATURE

# afiliate validator to group
celocli validator:affiliate $CELO_VALIDATOR_GROUP_ADDRESS --from $CELO_VALIDATOR_ADDRESS

#accept affiliation
celocli validatorgroup:member --accept $CELO_VALIDATOR_ADDRESS --from $CELO_VALIDATOR_GROUP_ADDRESS

#check if validator is part of the group
celocli validator:show $CELO_VALIDATOR_ADDRESS
celocli validatorgroup:show $CELO_VALIDATOR_GROUP_ADDRESS

#authorize vote signer
celocli election:vote --from $CELO_VALIDATOR_ADDRESS --for $CELO_VALIDATOR_GROUP_ADDRESS --value 10000000000000000000000
celocli election:vote --from $CELO_VALIDATOR_GROUP_ADDRESS --for $CELO_VALIDATOR_GROUP_ADDRESS --value 10000000000000000000000

#doublecheck the votes cast successfully
# On your local machine
celocli election:show $CELO_VALIDATOR_GROUP_ADDRESS --group
celocli election:show $CELO_VALIDATOR_GROUP_ADDRESS --voter
celocli election:show $CELO_VALIDATOR_ADDRESS --voter

#submit transaction to enable rewards
celocli election:activate --from $CELO_VALIDATOR_ADDRESS --wait && celocli election:activate --from $CELO_VALIDATOR_GROUP_ADDRESS --wait

#check vote activation
celocli election:show $CELO_VALIDATOR_GROUP_ADDRESS --voter
celocli election:show $CELO_VALIDATOR_ADDRESS --voter

#check rewards
celocli lockedgold:show $CELO_VALIDATOR_GROUP_ADDRESS
celocli lockedgold:show $CELO_VALIDATOR_ADDRESS

#see election list
celocli election:list

#check elected validators
celocli election:current

### Atestation service ###

echo "export CELO_IMAGE=us.gcr.io/celo-testnet/celo-node:baklava" >> ~/.bashrc
echo "export NETWORK_ID=12219" >> ~/.bashrc
echo "export CELO_VALIDATOR_ADDRESS=<CELO_VALIDATOR_ADDRESS>" >> ~/.bashrc
source ~/.bashrc
mkdir celo-attestations-node
cd celo-attestations-node
docker run -v $PWD:/root/.celo $CELO_IMAGE init /celo/genesis.json
docker run -v $PWD:/root/.celo --entrypoint cp $CELO_IMAGE /celo/static-nodes.json /root/.celo/
docker run -v $PWD:/root/.celo -it $CELO_IMAGE account new
echo "export CELO_ATTESTATION_SIGNER_ADDRESS=<YOUR-ATTESTATION-SIGNER-ADDRESS>" >> ~/.bashrc
source ~/.bashrc

#generate proof of possession
docker run -v $PWD:/root/.celo -it $CELO_IMAGE account proof-of-possession $CELO_ATTESTATION_SIGNER_ADDRESS $CELO_VALIDATOR_ADDRESS

# Authorize the attestation signer on the validator vm***
echo "export CELO_ATTESTATION_SIGNER_SIGNATURE= >> "~/.bashrc
echo "export CELO_ATTESTATION_SIGNER_ADDRESS= >> "~/.bashrc
source ~/.bashrc
celocli account:authorize --from $CELO_VALIDATOR_ADDRESS --role attestation --signature 0x$CELO_ATTESTATION_SIGNER_SIGNATURE --signer 0x$CELO_ATTESTATION_SIGNER_ADDRESS

#run the atestation service
echo <ATTESTATION-SIGNER-PASSWORD> > .password
docker run --name celo-attestations -it --restart always -p 8545:8545 -v $PWD:/root/.celo $CELO_IMAGE --verbosity 3 --networkid $NETWORK_ID --syncmode full --rpc --rpcaddr 0.0.0.0 --rpcapi eth,net,web3,debug,admin --unlock $CELO_ATTESTATION_SIGNER_ADDRESS --password /root/.celo/.password

#installing the db
apt install postgresql
sudo -u postgres createdb attestation-service
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '<DATABASE_PASSWORD>';"
export DATABASE_URL="postgres://postgres:<DATABASE_PASSWORD>@localhost:5432/attestation-service"

#executing the atestation service
docker run --name celo-attestation-service -it --restart always --entrypoint /bin/bash --network host -e ATTESTATION_SIGNER_ADDRESS=0x$CELO_ATTESTATION_SIGNER_ADDRESS -e CELO_VALIDATOR_ADDRESS=0x$CELO_VALIDATOR_ADDRESS -e CELO_PROVIDER=$CELO_PROVIDER -e DATABASE_URL=$DATABASE_URL -e SMS_PROVIDERS=twilio -e TWILIO_MESSAGING_SERVICE_SID=$TWILIO_MESSAGING_SERVICE_SID -e TWILIO_ACCOUNT_SID=$TWILIO_ACCOUNT_SID -e TWILIO_BLACKLIST=$TWILIO_BLACKLIST -e TWILIO_AUTH_TOKEN=$TWILIO_AUTH_TOKEN -e PORT=80 -p 80:80 $CELO_IMAGE_ATTESTATION -c " cd /celo-monorepo/packages/attestation-service && yarn run db:migrate && yarn start "

#Register metadata 
celocli account:create-metadata ./metadata.json --from 0x$CELO_VALIDATOR_ADDRESS
celocli account:claim-attestation-service-url ./metadata.json --url $ATTESTATION_SERVICE_URL --from 0x$CELO_VALIDATOR_ADDRESS
celocli account:claim-account ./metadata.json --address 0x$CELO_VALIDATOR_GROUP_ADDRESS --from 0x$CELO_VALIDATOR_ADDRESS

celocli account:register-metadata --url <METADATA_URL> --from $CELO_VALIDATOR_ADDRESS


#test atestation

celocli identity:test-attestation-service --from $CELO_VALIDATOR_ADDRESS --phoneNumber <YOUR-PHONE-NUMBER-E164-FORMAT> --message <YOUR_MESSAGE>



#get the peer count
docker exec -ti celo-proxy geth attach --exec "net"

#get blok number
docker exec -ti celo-accounts geth attach --exec "eth.blockNumber"
echo $((`curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' -H "Content-type: application/json" localhost:8545 |jq -r '.result'`))

