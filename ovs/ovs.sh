#!/bin/bash

ETH_IFACE=enp89s0
WIFI_IFACE=wlo1

ip netns add client
ovs-vsctl add-br OVS1

ip link add veth0 type veth peer veth1

ip link set veth0 netns client
ovs-vsctl add-port OVS1 veth1
ovs-vsctl add-port OVS1 $ETH_IFACE 
#ovs-vsctl add-port OVS1 $WIFI_IFACE

ip link set veth1 up
ip netns exec client ip addr add 192.168.1.204/24 dev veth0
ip netns exec client ip link set dev veth0 up
ip link set dev $ETH_IFACE up
