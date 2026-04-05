### setup
* .env ファイルを作成し、OPENAI_API_KEY="*****" を記載してください

### build
* Dockerfile, docker-compose.yml ファイルがあるフォルダで以下コマンドを実行
```
sudo docker compose build
```

### make container
* posershell　で以下実行
```
docker run -p 15789:15789 -p 15791:15791 openclaw-docker-desktop-app
```

* docker compose で起動
```
docker compose up -d --build
```

### データの保存
* WSL2 経由でWindowsのC:\tmp\docker\openclaw\home\node にopenclawの設定を保存しています。
* Windows側にはあらかじめフォルダを作成し、初回起動時の.openclawフォルダを作成しておく必要があります。
