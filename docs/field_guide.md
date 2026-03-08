🛠️ Section 1: The Core Infrastructure (Ubuntu/Linux)

These are your bread-and-butter commands for maintaining the "Host" health.
📈 System Health & Monitoring

    Disk Space: df -h (Monitor that 1TB SSD usage).

    Memory/CPU: htop (Visual) or free -h (Quick stats).

    I/O Pressure: iostat -xtdz 1 (Verify if nodes are disk-bound).

    Thermals: sensors (Crucial for sustained syncs).

    Network Connections: ss -tuln (See what ports your nodes are actually listening on).

🛡️ Hardening & Security

    Firewall (UFW): * sudo ufw status numbered

        sudo ufw allow 8333/tcp (BTC P2P)

        sudo ufw allow 9735/tcp (LND P2P)

    Fail2Ban: sudo fail2ban-client status sshd (Check for blocked brute-force attempts).

    Ownership Fix: sudo chown -R $USER:$USER /path/to/dir (Fixing those 'Permission Denied' errors).

⛓️ Section 2: Multi-Chain Management CLI

Once your Docker stack is up, you will mostly use docker exec to run these commands inside the containers.
🟠 Bitcoin (BTC)

    Sync Progress: bitcoin-cli getblockchaininfo | jq .verificationprogress

    Peer Health: bitcoin-cli getpeerinfo | jq '.[].addr'

    Mempool Depth: bitcoin-cli getmempoolinfo

    Stop Gracefully: bitcoin-cli stop (Always use this over kill -9).

⚡ Lightning Network (LND)

    Node Info: lncli getinfo (Shows your URI and sync status).

    Wallet Balance: lncli walletbalance (On-chain) / lncli channelbalance (Off-chain).

    Open Channel: lncli openchannel [pubkey] [amount_sats]

    List Peers: lncli listpeers

🔹 Ethereum (Geth/Lighthouse)

    Sync Status: geth attach --exec "eth.syncing" (Returns false when finished).

    Peer Count: geth attach --exec "net.peerCount"

    Logs (Lighthouse): docker logs -f lighthouse-beacon (Crucial for proof-of-stake health).

🚀 Algorand (Goal)

    Node Status: goal node status -d /var/lib/algorand

    Catchup: goal node catchup [checkpoint_id] (Fast sync method).

    Account List: goal account list

₳ Cardano (Cardano-CLI)

    Tip Hash: cardano-cli query tip --mainnet (Verify you are on the latest slot).

    UTXO Check: cardano-cli query utxo --address [addr] --mainnet

    Protocol Params: cardano-cli query protocol-parameters --mainnet --out-file params.json

🐳 Section 3: Docker Sentinel Commands

Since we've moved your vault into a containerized workflow:

    Startup All: docker-compose up -d

    Shutdown All: docker-compose down (Use stop to keep containers).

    Resource Usage: docker stats (See exactly how much RAM BTC vs. ETH is taking).

    Live Logs: docker-compose logs -f --tail=20

📜 Section 4: The "Safe Shutdown" Script

If you ever need to move the hardware or perform maintenance, run this sequence to prevent database corruption:
Bash

# 1. Stop high-I/O apps first
docker-compose stop
# 2. Stop bare-metal services
sudo systemctl stop bitcoind geth algod cardano-node
# 3. Flush filesystem buffers
sync
# 4. Power down
sudo shutdown -h now


🏗️ 1. Multi-Chain Command Center

This section covers the direct binary interactions and Docker equivalents for your stack.
Chain	Tool	Key Command	Context
BTC	bitcoin-cli	getblockchaininfo	Monitor sync, block height, and headers.
LND	lncli	getinfo	Verify Lightning sync and network URI.
ETH	geth	attach --exec "eth.syncing"	Check if Execution layer is caught up.
ETH	beacon	curl localhost:5052/eth/v1/node/health	Health check for Lighthouse Consensus layer.
ALGO	goal	node status -d /var/lib/algorand	Verify catchup status and protocol version.
ADA	cardano-cli	query tip --mainnet	Check current Slot/Epoch for Cardano.

🛡️ 2. Security & Hardening (The Perimeter)

As a DevSecOps professional, your baseline is Zero Trust.
Firewall (UFW) - Essential Ports

Run sudo ufw status and ensure only these are open:

    SSH: 22/tcp (Limit to your local IP if possible)

    BTC: 8333/tcp (P2P)

    LND: 9735/tcp (P2P)

    ETH: 30303/tcp (P2P), 9001/tcp (Lighthouse)

    ALGO: 4160/tcp (P2P)

    ADA: 3001/tcp (P2P)

Intrusion Prevention

    Fail2Ban: sudo fail2ban-client status sshd (Monitor blocked brute-force IPs).

    Audit Logs: sudo journalctl -u ssh -f (Watch real-time login attempts).

🐳 3. Docker Infrastructure Management

Once you perform the "Flip" tonight, these are your primary levers.

    Check Resource Stress: docker stats (Crucial for balancing the 32GB RAM).

    Container Health: docker inspect --format='{{json .State.Health}}' btc-sentinel-vault

    Network Inspection: docker network inspect sentinel-net (Verify LND can see BTC).

    Purge Old Data: docker system prune --volumes (CAUTION: Only use this if you've moved your vault data out of Docker-managed volumes).

🚑 4. Emergency & Maintenance Scripts

Save these as .sh scripts in your repo for 1-click execution.
The "Clean Exit" (Prevention of Database Corruption)
Bash

# Graceful shutdown sequence
docker-compose stop
sudo systemctl stop bitcoind geth lighthouse algod cardano-node
sync && sleep 2
sudo shutdown -h now

The "Permission Reset" (The Consultant's Fix)
Bash

# If Docker or any service logs "Permission Denied"
sudo chown -R nodeadmin:nodeadmin ~/sentinel-btc-vault /mnt/blockchain-vault
sudo chmod -R 750 /mnt/blockchain-vault
