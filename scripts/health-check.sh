#!/bin/bash
BLOCKS=$(bitcoin-cli -conf=/etc/bitcoin/bitcoin.conf getblockcount 2>/dev/null || echo "Starting...")
PROGRESS=$(bitcoin-cli -conf=/etc/bitcoin/bitcoin.conf getblockchaininfo | grep -po '"verificationprogress": \K[0-9.]+' || echo "0")
echo "--- Sentinel Status ---"
echo "Block: $BLOCKS | Progress: $PROGRESS"
sensors | grep "Core 0"
