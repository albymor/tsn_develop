Far partire phc2sys

```bash
sudo phc2sys -s CLOCK_REALTIME -c enp89s0 -m -O 0
```

Settare la scheda a 1Gpbs

```bash
sudo ethtool -s enp89s0 advertise 32
```

Settare offset TAI

```bash
sudo ./adjust_tai
```

Verificare offset TAI. tra TAI e RT deve essere 37

```bash
sudo ./check_clocks enp89s0
```

Configurare taprio

```bash
sudo ip link set dev enp89s0 down
sudo tc qdisc del dev enp89s0 root
sudo ./config-taprio.sh enp89s0
sudo ip link set dev enp89s0 up
sudo ip addr add 192.168.1.206/24 dev enp89s0
```

Lanciare nuovo send_udp_tai
    
```bash
sudo ./send_udp_tai -i enp89s0 -S 192.168.1.205 -t 3 -P 1000000 -o 10000
# anche senza il parametro -S dovrebbe funzionare
```

Verificare che i pacchetti escano 

```bash
watch tc -d -p -s qdisc show dev enp89s0
```


## Osservazioni
- Non sempre i pacchetti escono. Lanciare diverse volte la configurazione di taprio. Se si becca il BASE_TIME corretto, i pacchetti escono.
- BASE_TIME funzionante 1681903410228854868. Provare a forzare questo BASE_TIME nella configurazione di taprio.


## Build dei programmi

```bash
gcc send_udp_tai.c -pthread -o send_udp_tai
gcc check_clocks.c -o check_clocks
gcc adjust_tai.c -o adjust_tai
```

## Test PTP
Con questa configurazione PTP resta sempre attivo. Quindi tutto ok... 

> ATTENZIONE
Controollare spesso phc2sys... spesso crasha...


