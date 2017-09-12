#!/bin/bash
echo -n "tumbler.ecdsakeyaddress=" >> /home/shared/breeze.conf
/home/stratis/bin/stratisd  && sleep 10s && /home/stratis/bin/stratisd getnewaddress >> /home/shared/breeze.conf
