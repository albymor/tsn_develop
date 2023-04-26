#/usr/bin/python3

#tc -d -p -s qdisc show dev enp89s0 | grep "Sent.*dropped" | awk '{print $7} {print $9}'

import subprocess
import time
import json

time_test = [0, 1000, 2000, 5000, 10000, 20000, 50000, 100000]

def get_stat(l):
    l = l.split(' ')
    return list(map(int,[l[4], l[7][:-1], l[9]]))

res = {}
for t in time_test:
    print(f'running test for {t}')
    subprocess.run('./etf.sh', shell=True)

    time.sleep(3) 

    subprocess.run(f'sudo ./send_udp_tai -i enp89s0 -S 192.168.1.205 -t 3 -P 1000000 -o {t}', shell=True)   

    rr = subprocess.check_output('tc -d -p -s qdisc show dev enp89s0', shell=True).decode()
    rr = rr.split('\n\n')[1]

    rr = rr.split('\n')

    data = []
    get_next = False
    for i, l in enumerate(rr):
        if i == 0 or get_next == True:
            data.append(get_stat(l))
            get_next = False
        elif 'parent 100:1' in l:
            get_next = True
        else:
            pass

        

    res[t] = data

with open('result.json', 'w') as fp:
    json.dump(res, fp)
