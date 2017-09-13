FROM notroot:latest
LABEL maintainer="dan@dannygould.com"
# Install dependencies
# -------------------------------------

RUN apt-get update

# Install stratisX  & other dependencies
RUN apt-get install -y \
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
  git

RUN mkdir /home/stratis
RUN mkdir /home/stratis/src /home/stratis/bin

WORKDIR /home/stratis/src
RUN git clone https://github.com/stratisproject/stratisX.git
WORKDIR /home/stratis/src/stratisX/src
RUN make -f makefile.unix
RUN mkdir /home/$USER/.stratis
RUN cp -a stratisd /home/stratis/bin

# Stratis user should be running this
COPY stratis.conf /home/$USER/.stratis/stratis.conf

RUN echo "PATH=$HOME/bin:$PATH" >> /home/stratis/.bashrc
# Source the bashrc with ~/bin in path
RUN . /home/stratis/.bashrc

CMD ["/home/stratis/bin/stratisd"]

