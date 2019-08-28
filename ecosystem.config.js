module.exports = {
  apps : [{
    name: "solana-validator",
    cwd: "/home/ubuntu/.local/share/solana/install/active_release/bin",
    script: "solana-validator",
    args: ["--identity",  "/home/ubuntu/validator-keypair.json", "--voting-keypair", "/home/ubuntu/validator-vote-keypair.json", "--ledger", "/home/ubuntu/volume/validator-config/", "--rpc-port", "8899", "--entrypoint", "edge.testnet.solana.com:8001"],
    error_file: "/var/log/pm2/validator-err.log",
    out_file: "/var/log/pm2/validator-out.log",
    log_file: "/var/log/pm2/validator-combined.log",
    instances: 1,
    autorestart: true,
    min_uptime: "100s",
    watch: false,
    //max_memory_restart: '1G',
  }],
};
