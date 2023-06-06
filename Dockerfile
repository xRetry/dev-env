FROM ubuntu

RUN apt-get update && apt-get install -y curl

ENV HOME="/root"
RUN curl https://raw.githubusercontent.com/xRetry/dev-env/main/setup_env.sh | sh -s -- c rust
