MCS: Minecraft Server (t3a.small)
RS: Render Server (t3.2xlarge)
WS: Web Server (t2.micro)

To start the server:
- spin up MCS
- On MCS
  - install java and tmux
  - copy server data into place
  - start server in tmux session

To backup the world:
- On MCS
  - zip server directory
  - copy to s3

To render the map:
- spin up RS
- On MCS
  - zip world directory
  - scp to RS
- On RS
  - unzip world directory
  - create texture directory
  - wget textures
  - install python3-distutils python3-pip python3-pillow python3-numpy python3-dev
  - clone overviewer
  - build overviewer
  - render outworld
  - zip outworld
  - scp outworld to WS
  - spin down
- On WS
  - unzip outworld to /data/www/
  - rm zipfile