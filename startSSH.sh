#!/bin/bash
echo "Please enter the number of SSH containers you wish to start: "
read num
echo "[+] Starting $num containers"

# Create the docker containers
for ((i=1; i <= num; i++)); do
	echo "[+] Starting ssh$i"
	docker run -d -P --name ssh$i rastasheep/ubuntu-sshd
done

cat /etc/haproxy/haproxy.cfg.clean > /etc/haproxy/haproxy.cfg

# Get the port numbers
for ((j=1; j <= num; j++)); do
	port=$(docker port ssh$j)
	temp=$(sed 's/.*://' <<< $port)
	echo -e "\tserver rserve$j 127.0.1.1:$temp check" >> /etc/haproxy/haproxy.cfg
done	

echo "[+] Config written..."
echo "[+] Starting haproxy..."
service ssh stop
service haproxy start
sleep 2
echo "[+] Done!"
