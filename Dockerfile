FROM ubuntu

RUN apt-get update

ENV HOME="/root"
COPY ./setup_env.sh $HOME/setup_env.sh
RUN $HOME/setup_env.sh rust c
