# setup.sh
#!/bin/sh

echo "Starting services..."

# setup clamav
freshclam
mkdir -p /var/run/clamav/ 
chown -R clamav:clamav /var/run/clamav 

echo "Cleaning old processes..."
pkill -9 clamd || true
rm -f /var/run/clamav/clamd.ctl

echo "Starting clamd..."
su -s /bin/sh clamav -c "clamd -c /etc/clamav/clamd.conf" &

echo "Waiting for clamd socket..."
for i in $(seq 1 15); do
  if [ -S /var/run/clamav/clamd.ctl ]; then
    echo "clamd is ready"
    break
  fi
  sleep 1
done

# 最終チェック
if [ ! -S /var/run/clamav/clamd.ctl ]; then
  echo "ERROR: clamd failed to start"
  exit 1
fi

# chmod cron file
chmod 0755 /etc/cron.d/e2scrub_all
service cron start || true

# main / openclaw setup
#node -c "openclaw onboard --install-daemon" || true
mkdir -p /home/node/.openclaw
chown -R node:node /home/node/.openclaw || true
chmod -R 755 /home/node/.openclaw || true
## execute in node user
su node -c "
  npm config set registry https://npm.flatt.tech  && \
  yarn config set registry https://npm.flatt.tech  && \
  exec openclaw gateway --port 18789 --allow-unconfigured
" &

sleep 5

echo "Starting socat..."

# transfer ports for OpenClaw
socat TCP-LISTEN:15789,fork TCP:127.0.0.1:18789 & 
echo $! >> /tmp/socat.pid
socat TCP-LISTEN:15791,fork TCP:127.0.0.1:18791 & 
echo $! >> /tmp/socat.pid

# print token for user
cat /home/node/.openclaw/openclaw.json | grep token
echo "Access URL: http://localhost:15789/?token=<tokenの値> "

wait