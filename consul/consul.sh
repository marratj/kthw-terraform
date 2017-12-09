#!/bin/sh

curl -L https://releases.hashicorp.com/consul/1.0.0/consul_1.0.0_linux_amd64.zip > /tmp/consul.zip

unzip /tmp/consul.zip -d /usr/local/bin/

[ -d /etc/consul.d  ] || mkdir -p /etc/consul.d
[ -d /tmp/consul  ] || mkdir -p /tmp/consul

# cp -f /tmp/openshift.json /etc/consul.d/openshift.json

cp -f /tmp/consul.service /etc/systemd/system
cp -f /tmp/consul.env /etc/default/consul

systemctl enable consul
systemctl start consul