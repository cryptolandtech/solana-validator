export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$PATH" >> ~/.bashrc
#source ~/.bashrc

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt upgrade -y
#go 1.13
sudo apt-get install -y golang-go make gcc python jq liblz4-tool npm
sudo npm install pm2@latest -g

go get -d github.com/ovrclk/akash
cd $GOPATH/src/github.com/ovrclk/akash
make deps-install
make install

akash key list
akash query account


Deployment
==========

Deployment ID:          e6825d36473dd2c01d169767ba00e71ff2a26b1bc34128893597a84c13a18813          
Deployment Groups(s):   Group:          global                                                      
                        Requirements:                                                               
                        Resources:      Count:          1                                                   
                                        Price:          500                                                 
                                        CPU:            250                                                 
                                        Memory:         536870912                                           
                                        Disk:           1000000000                                          
Fulfillment(s):         GROUP   PRICE   PROVIDER                                                        
                        1       26      a34ee2789ba2e507656929c104e001d0cd42f3e7e5368672799397a9584a9b42
                        1       50      83cdd5cb917b893e3e1bc15c47c6ded88e6954e639aba453102aecbf98abc4e5

Lease(s)
========

Lease ID:       e6825d36473dd2c01d169767ba00e71ff2a26b1bc34128893597a84c13a18813/1/2/a34ee2789ba2e507656929c104e001d0cd42f3e7e5368672799397a9584a9b42
Services(s):    NAME    HOST(S) / IP(S)                                 AVAILABLE       TOTAL                                                                          
                web     x7qwayv8urw5z6dccn9yjj.kant.akashtest.net       0               1                                                                              
                web     147.75.78.35                                    0               1                                                                              






Deployment
==========

Deployment ID:          5c9897def26102a9cc785dd7257ee2d3a59ef8e8b61191c7cc50c6e18b364005          
Deployment Groups(s):   Group:          global                                                      
                        Requirements:                                                               
                        Resources:      Count:          1                                                   
                                        Price:          500                                                 
                                        CPU:            1000                                                
                                        Memory:         1073741824                                          
                                        Disk:           1000000000                                          
Fulfillment(s):         Group:          1                                                               
                        Price:          66                                                              
                        Provider:       d4a9d2283e2d6a442c95d7593ec9ad7bd22b68eca41905f1154b05d12430fa67

Lease(s)
========

Lease ID:       5c9897def26102a9cc785dd7257ee2d3a59ef8e8b61191c7cc50c6e18b364005/1/2/d4a9d2283e2d6a442c95d7593ec9ad7bd22b68eca41905f1154b05d12430fa67
Services(s):    NAME    HOST(S) / IP(S)                                 AVAILABLE       TOTAL                                                                      
                synapse akash2.moonlet.network                          0               0                                                                          
                synapse cbl7fe9zvnxav7vhejjacq.plato.akashtest.net      0               0                                                                          
                synapse 147.75.80.62                                    0               0                                                                          







Deployment
==========

Deployment ID:          67f5cfd3caf058d75bd30c4da0ad6a5debbdba6dfbcf4e5e94efa300cf285ffd          
Deployment Groups(s):   Group:          global                                                      
                        Requirements:                                                               
                        Resources:      Count:          1                                                   
                                        Price:          500                                                 
                                        CPU:            1000                                                
                                        Memory:         1073741824                                          
                                        Disk:           1000000000                                          
Fulfillment(s):         GROUP   PRICE   PROVIDER                                                        
                        1       134     a033e7b1768b2d05c26a71754c2811f6758b6f6434b1f5cbc2d7f25dbc2607e1
                        1       123     a34ee2789ba2e507656929c104e001d0cd42f3e7e5368672799397a9584a9b42

Lease(s)
========

Lease ID:       67f5cfd3caf058d75bd30c4da0ad6a5debbdba6dfbcf4e5e94efa300cf285ffd/1/2/d4a9d2283e2d6a442c95d7593ec9ad7bd22b68eca41905f1154b05d12430fa67
Services(s):    NAME    HOST(S) / IP(S)                                 AVAILABLE       TOTAL                                                                      
                synapse akash2.moonlet.network                          0               0                                                                          
                synapse q99aqvz588ckuydshkgfdj.plato.akashtest.net      0               0                                                                          
                synapse 147.75.80.62                                    0               0                                                                          





git clone https://github.com/cosmos/cosmos-sdk.git
cd cosmos-sdk
git checkout v0.34.9; GO111MODULE=on; make install

gaiad version --long
gaiad init moonlet
#gaiad unsafe-reset-all

vi .gaiad/config/gaiad.toml 
#minimum-gas-prices = "0.025uatom"

curl https://raw.githubusercontent.com/cosmos/launch/master/genesis.json > $HOME/.gaiad/config/genesis.json
wget http://quicksync.chainlayer.io/cosmos/cosmoshub-2.20190924.0605.tar.lz4	
lz4 -d  cosmoshub-2.20190924.0605.tar.lz4| tar xf -

#add seeds in .gaiad/config/config.toml
#seeds = "3e16af0cead27979e1fc3dac57d03df3c7a77acc@3.87.179.235:26656,ba3bacc714817218562f743178228f23678b2873@public-seed-node.cosmoshub.certus.one:26656" 
#get seeds from https://github.com/cosmos/launch or https://github.com/cosmos/gaia/blob/master/docs/join-mainnet.md

gaiad tendermint show-validator

gaiad start

#show status, if caught up
gaiacli status|jq

#show keys
#show address and pk
gaiacli keys list

#see valoper keys
gaiacli keys show moonlet --bech=val

#create new key
gaiacli keys add moonlet

#
gaiacli q account cosmos1wk7cej3utkgxexktwlf20x7zlv4575w8kafq8k --chain-id gaia-13006

#get validatior cosmosvalconspub
gaiad tendermint show-validator

#get validator address
gaiad tendermint show-address

#see your account
gaiacli q account <cosmosvalconspub>

#create a validator
gaiacli tx staking create-validator  --amount=1000000uatom --pubkey=$(gaiad tendermint show-validator) --moniker="moonlet" --chain-id=cosmoshub-2 --commission-rate="0.10" --commission-max-rate="0.20" --commission-max-change-rate="0.01" --min-self-delegation="1" --gas="auto" --gas-prices="0.025uatom" --from=moonlet

#verify you validator
gaiacli tx slashing unjail --from moonlet --chain-id=gaia-13006

#see all staking validators
gaiacli q staking validators --chain-id=gaia-13006


#get cosmosvaloper address
gaiacli keys show moonlet --bech=val

#delegate
gaiacli tx staking delegate cosmosvaloper 100muon --from account_name --gas auto --gas-adjustment 1.5 --chain-id=gaia-13006

#you should appear here
#https://hubble.figment.network/cosmos/chains/gaia-13006




#see all peers
curl -s http://localhost:26657/net_info |grep n_peers
 
#see valoper keys
gaiacli keys show moonlet --bech=val
 
#see validator details
gaiacli query staking validator cosmosvaloper --chain-id=gaia-1300

#check voting progress, jailed status, ..
gaiacli query slashing signing-info cosmosvalconspub --chain-id=gaia-13006

#check if validator is jailed
gaiacli q staking validator --validator cosmosvaloper... --trust-node

#unjail in case of downtime
gaiacli tx slashing unjail --from moonlet --chain-id=gaia-13006

#show voting. get address 
curl 0:26657/consensus_state

#peers that i'm connected to
curl 0:26657/net_info

#byte_address can be found in priv_validator_key.json

# get my peer info. node_id@ip:port (node_id found using gaiad tendermint show-node-id)
# gaiad tendermint show-node-id

#check if you have voted
curl localhost:26657/consensus_state -s | grep $(gaiacli status | jq -r .validator_info.address[:12])
