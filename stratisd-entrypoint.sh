#!/bin/bash
echo -n "tumbler.ecdsakeyaddress=" >> /home/shared/.breezeserver/breeze.conf
/home/stratis/bin/stratisd  && sleep 10s && /home/stratis/bin/stratisd getnewaddress >> /home/shared/.brezeserver/breeze.conf
