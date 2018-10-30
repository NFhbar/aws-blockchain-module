Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
apt-get update -y
apt-add-repository -y ppa:bitcoin/bitcoin
apt-get -y update
apt-get -y install bitcoind
mkdir -p "/home/ubuntu/.bitcoin"
echo "
rpcuser=${user}
rpcpassword=${pass}
rpcallowip=0.0.0.0/0
rpcthreads=128
server=1
testnet=${testnet_opt} "> /home/ubuntu/.bitcoin/bitcoin.conf
chown ubuntu -R "/home/ubuntu/.bitcoin"
sudo -H -u ubuntu bash -c "bitcoind -daemon -server"
--//
