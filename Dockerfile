FROM ubuntu:22.04

RUN useradd -ms /bin/bash marco

USER root
RUN apt-get update && apt-get install -y curl
RUN curl https://raw.githubusercontent.com/xRetry/dev-env/main/setup_ubuntu.sh | sh -s -- -t marco

