echo "#!/bin/bash" > /etc/default/cjdns
echo "CONF=/etc/cjdroute.conf" >> /etc/default/cjdns
echo "CJDPATH=/opt/" >> /etc/default/cjdns
chmod +x /etc/default/cjdns

cd /opt
## TMP HAX TILL CJD ACCEPTS PULL #226
#git clone https://github.com/cjdelisle/cjdns.git cjdns
git clone https://github.com/thefinn93/cjdns.git cjdns
cd cjdns
git checkout initscript
./do
./cjdroute --genconf > /tmp/cjdroute.conf
./build/cleanconfig < /tmp/cjdroute.conf > /etc/cjdroute.conf

/vagrant/scripts/configure-cjdns.py

chmod 600 /etc/cjdroute.conf

chown vagrant:vagrant /home/vagrant/.cjdnsadmin

cp scripts/cjdns.sh /etc/init.d/cjdns	# need to make this work well first
chmod +x /etc/init.d/cjdns
update-rc.d cjdns defaults
service cjdns start

cp /opt/cjdns/contrib/python/cjdns.py /opt/cjdns/contrib/python/bencode.py /usr/lib/python2.7/
cp /opt/cjdns/contrib/python/cexec /opt/cjdns/contrib/python/cjdnslog /opt/cjdns/contrib/python/dumptable /opt/cjdns/contrib/python/findnodes /usr/bin/
