MCS: Minecraft Server (t3a.small)
RS: Render Server (t3.2xlarge)
WS: Web Server (t2.micro)

To start the server:
- spin up MCS
- install java and tmux
- copy server data into place
- start server in tmux session

To backup the world:
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
  - 