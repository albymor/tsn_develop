#!/bin/bash

sudo ip netns del client
sudo ovs-vsctl del-br OVS1
for bridge in `ovs-vsctl list-br`; do
    sudo ovs-vsctl del-br $bridge
done
