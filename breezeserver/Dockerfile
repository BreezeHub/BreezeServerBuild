FROM ubuntu:14.04
LABEL maintainer="dan@dannygould.com"

# Add the dotnet product feed
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

# Install .NET Core SDK
RUN apt-get update
RUN apt-get install -y dotnet-dev-1.0.4

COPY BreezeServer /home/BreezeServer
RUN dotnet restore /home/BreezeServer/BreezeServer.sln
WORKDIR /home/BreezeServer/Breeze.BreezeServer

# Add breeze.conf if it exists
COPY breeze.* /home/breeze/.breezeserver/breeze.conf

CMD ["dotnet", "run", "-testnet"]


