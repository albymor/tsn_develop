#!/bin/bash

sudo ip link set dev enp89s0 down
sudo tc qdisc del dev enp89s0 root
sudo ./config-taprio-single.sh enp89s0
sudo ip link set dev enp89s0 up
sudo ip addr add 192.168.1.206/24 dev enp89s0

