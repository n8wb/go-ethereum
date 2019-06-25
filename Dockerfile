FROM golang:1.12.5-stretch as built

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update &&\
    apt-get install -y apt-utils expect git git-extras software-properties-common \
    inetutils-tools wget ca-certificates curl build-essential libssl-dev make
# builds out geth
ADD . /go/src/github.com/ethereum/go-ethereum
WORKDIR /go/src/github.com/ethereum/go-ethereum

RUN make all


FROM ubuntu:18.04 as final

COPY --from=built /go/src/github.com/ethereum/go-ethereum/build/bin /usr/local/bin

RUN apt-get update && apt-get install -y iperf3 openssh-server iputils-ping vim tmux software-properties-common && apt-get clean

RUN add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y solc

WORKDIR /
#ENV PATH /go-ethereum/build/bin:${PATH}

ENTRYPOINT ["/bin/bash"]
