#!/bin/bash
#
# Copyright (c) 2018, Intel Corporation
#
# SPDX-License-Identifier: BSD-3-Clause
#

# 1681903180596746905

IFACE=$1

if [ -z $IFACE ]; then
    echo "You must provide the network interface as first argument"
    exit -1
fi

i=$((`date +%s%N`))
echo $i
#BASE_TIME=$(($i - ($i % 1000000000)))
BASE_TIME=$((($i / 1000000000 + 1) * 1000000000))
BATCH_FILE=taprio.batch

cat > $BATCH_FILE <<EOF
qdisc replace dev $IFACE parent root handle 100 taprio \\
      num_tc 3 \\
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
      queues 1@0 1@1 2@2 \\
      sched-entry S 01 300000 \\
      sched-entry S 02 300000 \\
      sched-entry S 04 400000 \\
      flags 0x2

qdisc replace dev $IFACE parent 100:1 etf \\
      offload delta 200000 clockid CLOCK_TAI skip_sock_check

qdisc replace dev $IFACE parent 100:2 etf clockid CLOCK_TAI \\
      delta 200000 offload deadline_mode skip_sock_check
EOF

tc -batch $BATCH_FILE

echo "Base time: $BASE_TIME"
echo "Configuration saved to: $BATCH_FILE"
