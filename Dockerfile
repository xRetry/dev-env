FROM ubuntu

RUN apt-get update && apt-get install -y curl
RUN curl https://raw.githubusercontent.com/xRetry/dev-env/main/setup_ubuntu.sh | sh -s -- -t marco -l python -l rust -l c
