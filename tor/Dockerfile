FROM ubuntu:14.04
LABEL maintainer="dan@dannygould.com"

RUN echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
RUN gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y tor deb.torproject.org-keyring

CMD ["tor", "-controlport", "9051", "-cookieauthentication", "1", "-cookieauthfile", "/shared/.tor/control_auth_cookie"]

