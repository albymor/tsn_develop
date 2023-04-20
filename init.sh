#!/bin/bash
# tmux new-session -d bash

# tmux attach-session -d

#sudo phc2sys -s CLOCK_REALTIME -c enp89s0 -m -O 0 &

# tmux new-window

sudo ethtool -s enp89s0 advertise 32
sudo ./adjust_tai

sudo ./check_clocks enp89s0
