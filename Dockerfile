FROM ubuntu:16.04
MAINTAINER phm87
ARG REPOSITORY=clone https://github.com/jl777/chips3
ARG BINARY=chips
ARG FOLDER=chips
ARG PORT_A=9322
#ARG STR_PORT_A=4233

ENV user=user
#ENV port=4233
#ENV password=tu8tu5
ENV coin_folder=coin_folder_a
ENV coin_binary=coin_binary_a
ENV PORT=PORT_a
#ENV STR_PORT=STR_PORT_A

RUN apt-get -y update \
 && apt-get -y install git \
 && apt-get -y install software-properties-common autoconf git build-essential libtool libprotobuf-c-dev libgmp-dev libsqlite3-dev python python3 zip jq libevent-dev pkg-config libssl-dev libcurl4-gnutls-dev cmake
add-apt-repository ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install software-properties-common \
 && add-apt-repository -y ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install libdb4.8-dev libdb4.8++-dev

RUN mkdir cd ~/ \
 && wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.zip \
 && unzip boost_1_64_0.zip \
 && cd boost_1_64_0 \
 && ./bootstrap.sh \
 && ./b2 \
 && ./b2 install \
 && cd ~/ \
 && git clone https://github.com/jl777/chips3 \
 && cd ~/chips3 \
 && ./autogen.sh \
 && ./configure --with-boost=/usr/local/ \
 && cd src \
 && make -j2 chipsd \
 && make chips-cli \
 && cp chips-cli /usr/bin \ # just need to get chips-cli to work from command line
# make -> will build everything, including QT wallet
 && sudo ldconfig /usr/local/lib # thanks smaragda!

RUN wget bootstrap.tar.gz \ # To create and host somewhere

/*
./chipsd -addnode=5.9.253.195 &
*/

RUN apt-get install bash && mkdir /root/.${FOLDER}

COPY ${BINARY}.conf /root/.${FOLDER}
COPY entry.sh /root/coind
RUN chmod +x /root/coind/entry.sh

COPY blocknotify.sh /root/coind
RUN chmod +x /root/coind/blocknotify.sh

/*
cd
git clone https://github.com/jl777/lightning
cd lightning
make
daemon/lightning-cli stop; lightningd/lightningd --log-level=debug &
cd privatebet
./m_bet
./client or ./host
*/

WORKDIR ~/

CMD ["bash", "entry.sh"]

EXPOSE ${PORT} ${STR_PORT}
