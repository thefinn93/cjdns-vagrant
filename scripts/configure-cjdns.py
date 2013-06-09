#!/usr/bin/env python2
import json,os,sys

original = json.load(open("/etc/cjdroute.conf"))

original['interfaces']['ETHInterface'] = []
original['interfaces']['ETHInterface'].append({"bind": "eth0", "beacon": 2, "connectTo": {}})

for peerfile in os.listdir("/vagrant/peers/"):
    try:
        peers = json.load(open(peerfile))
        for interface in peers:
            for peer in peers[interface]:
                original['interfaces'][interface]['connectTo'][peer] = peers[interface][peer]
    except e:
        sys.stderr.write("Failed to import peer: " + e)

conf = open("/etc/cjdroute.conf", "a")
conf.write(json.dumps(original, sort_keys=True, indent=4, separators=(',', ': ')))
conf.close()


cjdnsadmin = {}
cjdnsadmin['addr'] = "127.0.0.1"
cjdnsadmin['port'] = 11234
cjdnsadmin['password'] = original['admin']['password']

admin = open("/home/vagrant/.cjdnsadmin", "a")
admin.write(json.dumps(cjdnsadmin, sort_keys=True, indent=4, separators=(',', ': ')))
admin.close()
