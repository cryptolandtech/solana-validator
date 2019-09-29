export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$PATH" >> ~/.bashrc
#source ~/.bashrc 

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt upgrade -y
#go 1.13
sudo apt-get install -y golang-go make gcc python jq 

git clone https://github.com/terra-project/core/
cd core
make

terrad version --long
terracli version --long

#/etc/security/limits.conf
#*                soft    nofile          65535
#*                hard    nofile          65535

terrad init moonlet
wget https://raw.githubusercontent.com/terra-project/launch/master/columbus-2/columbus-2-genesis.json
mv columbus-2-genesis.json ../.terrad/config/genesis.json
vi ../.terrad/config/config.toml 
#add:
#seeds = "b416f0b04e2c71b8d76f993468352030e2dcf2a9@public-seed-node.columbus.certus.one:26656, 0621acccfc2c847e67d84eb234bcc26323a103c3@public-seed.terra.dev:26656, 46bba3a2c615ea5b569f086344f932fa11e81c01@public-seed2.terra.dev:26656"
#persistent_peers = "e6325ba7c490ba371135c9f3fcead66da1bd8cf1@terra-sentry01.dokia.cloud:26656, dba5defd7b120937da37aea7f37d06870637558d@terra-sentry02.dokia.cloud:26656, eb4ce12133c450ba6665e06309570ea2843e21d8@167.86.104.33:26656"
terrad unsafe-reset-all
terrad start



output
-------------
ubuntu@ip-172-31-47-217:~/core$ terrad version --long
name: terra
server_name: terrad
client_name: terracli
version: 0.2.2-36-g7a12827
commit: 7a128270b363e53fe95c3befff7c1c296ebd9812
build_tags: netgo,ledger
go: go version go1.13 linux/amd64

ubuntu@ip-172-31-47-217:~/core$ terrad init moonlet
{"app_message":{"accounts":[],"auth":{"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"send_enabled":true},"crisis":{"constant_fee":{"amount":"1000","denom":"uluna"}},"distribution":{"base_proposer_reward":"0.010000000000000000","bonus_proposer_reward":"0.040000000000000000","community_tax":"0.020000000000000000","delegator_starting_infos":[],"delegator_withdraw_infos":[],"fee_pool":{"community_pool":[]},"outstanding_rewards":[],"previous_proposer":"","validator_accumulated_commissions":[],"validator_current_rewards":[],"validator_historical_rewards":[],"validator_slash_events":[],"withdraw_addr_enabled":true},"genutil":{"gentxs":null},"gov":{"deposit_params":{"max_deposit_period":"172800000000000","min_deposit":[{"amount":"10000000","denom":"uluna"}]},"deposits":null,"proposals":null,"starting_proposal_id":"1","tally_params":{"quorum":"0.334000000000000000","threshold":"0.500000000000000000","veto":"0.334000000000000000"},"votes":null,"voting_params":{"voting_period":"172800000000000"}},"market":{"params":{"daily_luna_delta_cap":"0.005000000000000000","max_swap_spread":"1.000000000000000000","min_swap_spread":"0.020000000000000000"}},"oracle":{"missed_votes":{},"params":{"min_valid_votes_per_window":"0.050000000000000000","reward_band":"0.010000000000000000","reward_fraction":"0.010000000000000000","slash_fraction":"0.000100000000000000","vote_period":"10","vote_threshold":"0.500000000000000000","votes_window":"1000"},"voting_infos":{}},"params":null,"slashing":{"missed_blocks":{},"params":{"downtime_jail_duration":"600000000000","max_evidence_age":"120000000000","min_signed_per_window":"0.500000000000000000","signed_blocks_window":"100","slash_fraction_double_sign":"0.050000000000000000","slash_fraction_downtime":"0.010000000000000000"},"signing_infos":{}},"staking":{"delegations":null,"exported":false,"last_total_power":"0","last_validator_powers":null,"params":{"bond_denom":"uluna","max_entries":7,"max_validators":100,"unbonding_time":"1814400000000000"},"redelegations":null,"unbonding_delegations":null,"validators":null},"supply":{"supply":[]},"treasury":{"params":{"mining_increment":"1.070000000000000000","reward_policy":{"cap":{"amount":"0","denom":"unused"},"change_max":"0.025000000000000000","rate_max":"0.900000000000000000","rate_min":"0.050000000000000000"},"seigniorage_burden_target":"0.670000000000000000","tax_policy":{"cap":{"amount":"1000000","denom":"usdr"},"change_max":"0.000250000000000000","rate_max":"0.010000000000000000","rate_min":"0.000500000000000000"},"window_long":"52","window_probation":"12","window_short":"4"},"reward_weight":"0.050000000000000000","tax_rate":"0.001000000000000000"}},"chain_id":"test-chain-gkk8JY","gentxs_dir":"","moniker":"moonlet","node_id":"ebd2c344faf9e6823f0181aa40d3bf0c4dfd4efb"}
ubuntu@ip-172-31-47-217:~/core$ wget https://raw.githubusercontent.com/terra-project/launch/master/columbus-2/columbus-2-genesis.json
--2019-09-29 20:51:08--  https://raw.githubusercontent.com/terra-project/launch/master/columbus-2/columbus-2-genesis.json
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.16.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.16.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3916371 (3.7M) [text/plain]
Saving to: ‘columbus-2-genesis.json’

columbus-2-genesis.json                                    100%[========================================================================================================================================>]   3.73M  17.8MB/s    in 0.2s    

2019-09-29 20:51:09 (17.8 MB/s) - ‘columbus-2-genesis.json’ saved [3916371/3916371]

ubuntu@ip-172-31-47-217:~/core$ mv columbus-2-genesis.json ../.terrad/config/genesis.json
ubuntu@ip-172-31-47-217:~/core$ vi ../.terrad/config/config.toml
ubuntu@ip-172-31-47-217:~/core$ terrad unsafe-reset-all
I[2019-09-29|20:52:13.236] Removed all blockchain history               module=main dir=/home/ubuntu/.terrad/data
I[2019-09-29|20:52:13.249] Reset private validator file to genesis state module=main keyFile=/home/ubuntu/.terrad/config/priv_validator_key.json stateFile=/home/ubuntu/.terrad/data/priv_validator_state.json
ubuntu@ip-172-31-47-217:~/core$ terrad start
I[2019-09-29|20:52:20.352] Starting ABCI with Tendermint                module=main 
panic: stored supply should not have been nil

goroutine 1 [running]:
github.com/cosmos/cosmos-sdk/x/supply/internal/keeper.Keeper.GetSupply(0xc000158f50, 0x163d120, 0xc0001b6360, 0x164d5a0, 0xc000159810, 0x16505a0, 0xc000a960e0, 0xc0009dbda0, 0x164c520, 0xc0000b4030, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/x/supply/internal/keeper/keeper.go:50 +0x18f
github.com/cosmos/cosmos-sdk/x/supply/internal/keeper.TotalSupply.func1(0x164c520, 0xc0000b4030, 0x165dfe0, 0xc0002fa9c0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/x/supply/internal/keeper/invariants.go:27 +0xe7
github.com/cosmos/cosmos-sdk/x/crisis/internal/keeper.Keeper.AssertInvariants(0xc000139400, 0xb, 0x10, 0xc000158f50, 0x163d120, 0xc0001b63a0, 0x163d160, 0xc0001b63f0, 0xc000b4f0a0, 0x6, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/x/crisis/internal/keeper/keeper.go:74 +0x36d
github.com/cosmos/cosmos-sdk/x/crisis.AppModule.InitGenesis(0xc0001f3248, 0x164c520, 0xc0000b4030, 0x165dfe0, 0xc0002fa9c0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/x/crisis/module.go:113 +0x2dd
github.com/terra-project/core/x/crisis.AppModule.InitGenesis(...)
        /home/ubuntu/core/x/crisis/module.go:112
github.com/cosmos/cosmos-sdk/types/module.(*Manager).InitGenesis(0xc00013cc40, 0x164c520, 0xc0000b4030, 0x165dfe0, 0xc0002fa9c0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/types/module/module.go:258 +0x278
github.com/terra-project/core/app.(*TerraApp).InitChainer(0xc0001f2e00, 0x164c520, 0xc0000b4030, 0x165dfe0, 0xc0002fa9c0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
        /home/ubuntu/core/app/app.go:259 +0x11d
github.com/cosmos/cosmos-sdk/baseapp.(*BaseApp).InitChain(0xc000490900, 0x0, 0xed48aa2e0, 0x0, 0xc00003a580, 0xa, 0xc0002fa900, 0xc0000e9000, 0x34, 0x34, ...)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/baseapp/baseapp.go:392 +0x2c7
github.com/tendermint/tendermint/abci/client.(*localClient).InitChainSync(0xc0000bad80, 0x0, 0xed48aa2e0, 0x0, 0xc00003a580, 0xa, 0xc0002fa900, 0xc0000e9000, 0x34, 0x34, ...)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/abci/client/local_client.go:223 +0x101
github.com/tendermint/tendermint/proxy.(*appConnConsensus).InitChainSync(0xc0001b7340, 0x0, 0xed48aa2e0, 0x0, 0xc00003a580, 0xa, 0xc0002fa900, 0xc0000e9000, 0x34, 0x34, ...)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/proxy/app_conn.go:65 +0x6b
github.com/tendermint/tendermint/consensus.(*Handshaker).ReplayBlocks(0xc0030870f0, 0xa, 0x0, 0x1242db8, 0x6, 0xc00003a580, 0xa, 0x0, 0x0, 0x0, ...)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/consensus/replay.go:309 +0x666
github.com/tendermint/tendermint/consensus.(*Handshaker).Handshake(0xc0030870f0, 0x1660b60, 0xc0001245b0, 0x80, 0x10a8e00)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/consensus/replay.go:267 +0x485
github.com/tendermint/tendermint/node.doHandshake(0x165fee0, 0xc0000b8470, 0xa, 0x0, 0x1242db8, 0x6, 0xc00003a580, 0xa, 0x0, 0x0, ...)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/node/node.go:274 +0x199
github.com/tendermint/tendermint/node.NewNode(0xc000183e00, 0x1646e20, 0xc000a7c1e0, 0xc0001b6940, 0x162cca0, 0xc000185b40, 0xc0001b6e70, 0x14426b0, 0xc0001b6ea0, 0x164d060, ...)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/node/node.go:584 +0x334
github.com/cosmos/cosmos-sdk/server.startInProcess(0xc000185220, 0x1443060, 0x1d, 0x0, 0x0)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/server/start.go:129 +0x4c1
github.com/cosmos/cosmos-sdk/server.StartCmd.func1(0xc000138000, 0x2105690, 0x0, 0x0, 0x0, 0x0)
        /home/ubuntu/go/pkg/mod/github.com/cosmos/cosmos-sdk@v0.37.0/server/start.go:43 +0xb4
github.com/spf13/cobra.(*Command).execute(0xc000138000, 0x2105690, 0x0, 0x0, 0xc000138000, 0x2105690)
        /home/ubuntu/go/pkg/mod/github.com/spf13/cobra@v0.0.5/command.go:826 +0x460
github.com/spf13/cobra.(*Command).ExecuteC(0xc00048e500, 0x126880e, 0xc000b8dea0, 0x597142)
        /home/ubuntu/go/pkg/mod/github.com/spf13/cobra@v0.0.5/command.go:914 +0x2fb
github.com/spf13/cobra.(*Command).Execute(...)
        /home/ubuntu/go/pkg/mod/github.com/spf13/cobra@v0.0.5/command.go:864
github.com/tendermint/tendermint/libs/cli.Executor.Execute(0xc00048e500, 0x1443480, 0x124d581, 0x10)
        /home/ubuntu/go/pkg/mod/github.com/tendermint/tendermint@v0.32.2/libs/cli/setup.go:89 +0x3c
main.main()
        /home/ubuntu/core/cmd/terrad/main.go:71 +0x85c

