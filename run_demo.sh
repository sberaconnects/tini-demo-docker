# run_demo.sh
#!/bin/bash

# Ensure old containers are stopped and removed
echo "[INFO] Stopping and removing old containers..."
docker-compose down -v --remove-orphans

# Build containers
echo "[INFO] Building containers..."
docker-compose build

# Start containers
echo "[INFO] Starting containers..."
docker-compose up -d

# Wait for processes to settle
echo "[INFO] Waiting 10 seconds for processes to settle..."
sleep 10

# Collect process state info
echo "[INFO] Capturing process info..."
echo "\n===== WITH TINI =====" > results.txt
docker exec tini-container ps -eo pid,ppid,stat,cmd >> results.txt

echo "\n===== WITHOUT TINI =====" >> results.txt
docker exec no-tini-container ps -eo pid,ppid,stat,cmd >> results.txt

echo "\n===== ZOMBIES IN WITHOUT-TINI =====" >> results.txt
docker exec no-tini-container ps -eo pid,ppid,stat,cmd | grep ' Z ' >> results.txt

# Final cleanup
echo "[INFO] Stopping and removing containers after test..."
docker-compose down -v --remove-orphans

echo "[DONE] Results written to results.txt"