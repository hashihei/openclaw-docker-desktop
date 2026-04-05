FROM node:25-slim

RUN apt-get update && apt-get install -y \
    curl \
    socat \
    iproute2 \
    clamav \
    clamav-daemon \
    cron \
    vim

RUN freshclam || true

# npm インストール
ENV NODE_PATH=/usr/local/lib/node_modules
RUN npm install -g \
  openclaw@latest \
  grammy \
  @slack/web-api \
  @slack/bolt \
  axios \
  node-fetch \
  undici

# スクリプトをコピー
COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# 起動時に実行
USER root
CMD ["/usr/local/bin/setup.sh"]