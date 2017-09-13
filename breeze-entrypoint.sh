# COPY breeze.conf into /home/shared (Done in start.sh)
# echo -n "tumbler.ecdsakeyaddress=" >> breeze.conf (done in stratisd-entrypoint.sh)
# docker exec stratisd "stratisd getnewaddress" >> breeze.conf (^^^)
# docker exec tor "cp cookie_auth_file" >> cookie auth in volume" (done in tor-entrypoint.sh to /home/shared/cookie_auth_file)
# start breezeserver
exec dotnet run -testnet
