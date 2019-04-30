FROM ubuntu:16.04
MAINTAINER phm87
ARG REPOSITORY=https://github.com/jl777/chips3
ARG BINARY=chips
ARG FOLDER=chips
ARG P2P_PORT_A=57777
ARG RPC_PORT_A=12454

ENV user=user
ENV P2P_PORT=P2P_PORT_A
ENV RPC_PORT=RPC_PORT_A

RUN apt-get -y update \
 && apt-get -y install unzip wget \
 && apt-get -y install software-properties-common autoconf git build-essential libtool libprotobuf-c-dev libgmp-dev libsqlite3-dev python python3 zip jq libevent-dev pkg-config libssl-dev libcurl4-gnutls-dev cmake \
 && add-apt-repository ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install software-properties-common libbz2-dev libicu-dev g++ python-dev autotools-dev bsdmainutils \
 && add-apt-repository -y ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install libdb4.8-dev libdb4.8++-dev

RUN cd /home && wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.zip \
 && unzip boost_1_64_0.zip \
 && cd boost_1_64_0 \
 && ./bootstrap.sh \
 && ./b2 \
 && ./b2 install

RUN cd ~/ \
 && git clone ${REPOSITORY} \
 && cd ~/chips3 \
 && ./autogen.sh \
 && ./configure --with-boost=/usr/local/ \
 && cd src \
 && make -j2 chipsd \
 && make chips-cli \
 && cp chips-cli /usr/bin \
# just need to get chips-cli to work from command line
# make -> will build everything, including QT wallet
 && ldconfig /usr/local/lib
# thanks smaragda!

# ./chipsd -addnode=5.9.253.195 &

RUN apt-get install bash && mkdir /root/.${FOLDER}

COPY ${BINARY}.conf /root/.${FOLDER}
COPY entry.sh /root/coind
RUN chmod +x /root/coind/entry.sh

# cd
# git clone https://github.com/jl777/lightning
# cd lightning
# make
# daemon/lightning-cli stop; lightningd/lightningd --log-level=debug &
# cd privatebet
# ./m_bet
# ./client or ./host

WORKDIR ~/

CMD ["bash", "entry.sh"]

EXPOSE ${P2P_PORT} ${RPC_PORT}
