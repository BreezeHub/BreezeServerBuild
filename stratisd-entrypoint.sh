#!/bin/bash
echo -n "tumbler.ecdsakeyaddress=" >> /shared/.breezeserver/breeze.conf
/home/stratis/bin/stratisd  && sleep 10s && /home/stratis/bin/stratisd getnewaddress >> /shared/.brezeserver/breeze.conf
