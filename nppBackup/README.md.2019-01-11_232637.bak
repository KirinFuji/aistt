# A.I.S.T.T

Automated ICMP Subnet Testing Tool is a tool designed to automate the task of finding what nodes on a subnet respond and then testing the responsive nodes further to gather data.

# To Install:

1. mkdir -p ~/bin/ && cd ~/bin/ 

2. git clone https://github.com/KirinFuji/aistt.git

3. chmod +x ./aistt/aistt

4. mv ./aistt ./.aistt-dir

5. ln -s ./.aistt_dir/aistt

# Or all at once!: 

mkdir -p ~/bin/ && cd ~/bin/ && git clone https://github.com/KirinFuji/aistt.git && chmod +x ./aistt/aistt && mv ./aistt ./.aistt-dir && ln -s ./.aistt-dir/aistt

# To Run

aistt NetworkAddress/CIDRmask

Ex.

aistt 10.0.0.0/30 

# To remove:

rm -rf ~/bin/.aistt-dir ~/bin/aistt

# Help Text:

Welcome to A.I.S.T.T please enter a valid Network Address/CIDRmask to begin.

Examples: 10.0.50.96/29 192.168.25.96/28 172.17.17.32/27

You can scan subnets down to a /30 and up to a /24

Ensure you enter the Network Address of the subnet or you will ping outside of the subnet.

# Sample Output:

~/bin/aistt 10.10.10.64/27

Testing Subnet 10.10.10.64/27

Subnet Includes:
10.10.10.65
10.10.10.67
10.10.10.68
10.10.10.69
10.10.10.70
10.10.10.71
10.10.10.66
10.10.10.72
10.10.10.73
10.10.10.74
10.10.10.75
10.10.10.76
10.10.10.77
10.10.10.78
10.10.10.79
10.10.10.80
10.10.10.81
10.10.10.82
10.10.10.83
10.10.10.84
10.10.10.85
10.10.10.86
10.10.10.87
10.10.10.88
10.10.10.89
10.10.10.90
10.10.10.91
10.10.10.92
10.10.10.93
10.10.10.94

Found ICMP Service on Hosts:
10.10.10.81
10.10.10.94
10.10.10.68

Pingtest Result:

--- 10.10.10.81 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 20190ms
rtt min/avg/max/mdev = 0.121/0.140/0.221/0.023 ms

--- 10.10.10.94 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 20189ms
rtt min/avg/max/mdev = 0.125/0.155/0.202/0.019 ms

--- 10.10.10.68 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 20195ms
rtt min/avg/max/mdev = 0.022/0.023/0.026/0.005 ms