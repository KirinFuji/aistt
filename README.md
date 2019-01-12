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