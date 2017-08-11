FROM ubuntu:14.04
LABEL maintainer="dan@dannygould.com"
# Install dependencies
# -------------------------------------

# necessary prereqs for dotnet-dev-1.0.4
# TODO: look into if the whole update is necessary
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B02C46DF417A0893
RUN apt-get update

# Install stratisX  & other dependencies
RUN apt-get install -y \
  dotnet-dev-1.0.4 \
  libminiupnpc-dev \
  libdb++-dev \
  libdb-dev \
  libcrypto++-dev \
  libqrencode-dev \
  libboost-all-dev \
  build-essential \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-thread-dev \
  libboost-filesystem-dev  \
  libboost-program-options-dev \
  libboost-thread-dev \
  libssl-dev \
  libdb++-dev \
  libssl-dev \
  ufw \
  git \
  tor


# Run stratisX
# -------------------------------------
RUN adduser stratis --disabled-password
USER stratis
RUN mkdir /home/stratis/src /home/stratis/bin

# TODO: run from a copy
WORKDIR /home/stratis/src
RUN git clone https://github.com/stratisproject/stratisX.git
WORKDIR /home/stratis/src/stratisX/src
RUN make -f makefile.unix
RUN mkdir /home/stratis/.stratis
RUN cp -a stratisd /home/stratis/bin

# Stratis user should be running this
COPY stratis.conf /home/stratis/.stratis/stratis.conf

RUN echo "PATH=$HOME/bin:$PATH" >> /home/stratis/.bashrc
# Source the bashrc with ~/bin in path
RUN . /home/stratis/.bashrc



# Run Bitcoin Core
# -------------------------------------
USER root
RUN useradd --create-home -s /bin/bash breeze

USER breeze
WORKDIR /home/breeze/
RUN mkdir /home/breeze/.bitcoin
RUN mkdir /home/breeze/.bitcoin/testnet3
COPY bitcoin.conf /home/breeze/.bitcoin/bitcoin.conf
COPY bitcoin-0.13.1-x86_64-linux-gnu.tar.gz /home/breeze/bitcoin-0.13.1-x86_64-linux-gnu.tar.gz
RUN tar -xzf bitcoin-0.13.1-x86_64-linux-gnu.tar.gz
RUN /home/breeze/bitcoin-0.13.1/bin/bitcoind --daemon

# Run BreezeServer
# --------------------------------------

USER breeze

COPY BreezeServer /home/breeze/BreezeServer
RUN mkdir /home/breeze/.ntumblebitserver
RUN mkdir /home/breeze/.ntumblebitserver/TestNet
COPY server.config /home/breeze/.ntumblebitserver/TestNet/server.config
RUN mkdir /home/breeze/.breezeserver
COPY breeze.conf /home/breeze/.breezeserver/breeze.conf

USER root
RUN chown -R breeze /home/breeze/

USER breeze
RUN dotnet restore /home/breeze/BreezeServer/BreezeServer.sln



# Copy new bitcoin address to breeze.conf 
# (Requires share of data from stratis to breeze)
# -------------------------------------

USER root
RUN mkdir /home/public
RUN /usr/sbin/groupadd share
RUN chown -R root.share /home/public
RUN /usr/bin/gpasswd -a breeze share
RUN /usr/bin/gpasswd -a stratis share
RUN chmod ug+rwx -R /home/public
RUN chmod g+s /home/public

USER stratis
RUN echo -n "tumbler.ecdsakeyaddress=" >> /home/public/breeze.conf
RUN /home/stratis/bin/stratisd && sleep 10s && /home/stratis/bin/stratisd getnewaddress >> /home/public/breeze.conf;

USER root
RUN cat /home/public/breeze.conf >> /home/breeze/.breezeserver/breeze.conf
RUN cat /home/breeze/.breezeserver/breeze.conf

# Build & serve over tor
# -------------------------------------
USER breeze
RUN dotnet build /home/breeze/BreezeServer/Breeze.BreezeServer/Breeze.BreezeServer.csproj

RUN tor -controlport 9051

CMD dotnet run --project /home/breeze/BreezeServer/Breeze.BreezeServer/Breeze.BreezeServer.csproj -testnet
