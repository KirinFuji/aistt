#!/bin/bash

#  MIT License
#  
#  Copyright (c) 2019 KirinFuji
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.

# Written By KirinFuji With Love A LongTimeAgo ♥

#Automated ICMP Subnet Testing Tool (A.I.S.T.T)
#Please use resposibily. You really should not use this on a subnet larger than /27.
#Tool will spawn many background processes as it is designed to be FAST.
#The larger the subnet the more processes and bandwidth will be used.

# - - - - - START_OF_DATA_ARRAYS  - - - - - #

conversion_array=(
0.0.0.0
128.0.0.0
192.0.0.0
224.0.0.0
240.0.0.0
248.0.0.0
252.0.0.0
254.0.0.0
255.0.0.0
255.128.0.0
255.192.0.0
255.224.0.0
255.240.0.0
255.248.0.0
255.252.0.0
255.254.0.0
255.255.0.0
255.255.128.0
255.255.192.0
255.255.224.0
255.255.240.0
255.255.248.0
255.255.252.0
255.255.254.0
255.255.255.0
255.255.255.128
255.255.255.192
255.255.255.224
255.255.255.240
255.255.255.248
255.255.255.252
255.255.255.254
255.255.255.255)


# - - - - - START_OF_FUNCTIONS  - - - - - #

#Function to calculate the IP's contained within a CIDR block.
ip_calc_func()
{
#Huge thanks to the following for the code inside of ip_calc_func:
#https://stackoverflow.com/users/254868/scherand
#https://stackoverflow.com/users/4476404/kyoungs
#https://stackoverflow.com/questions/16986879/bash-script-to-list-all-ips-in-prefix
#https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
############################
##  Methods
############################
prefix_to_bit_netmask() {
    prefix=$1;
    shift=$(( 32 - prefix ));

    bitmask=""
    for (( i=0; i < 32; i++ )); do
        num=0
        if [ $i -lt $prefix ]; then
            num=1
        fi

        space=
        if [ $(( i % 8 )) -eq 0 ]; then
            space=" ";
        fi

        bitmask="${bitmask}${space}${num}"
    done
    echo $bitmask
}

bit_netmask_to_wildcard_netmask() {
    bitmask=$1;
    wildcard_mask=
    for octet in $bitmask; do
        wildcard_mask="${wildcard_mask} $(( 255 - 2#$octet ))"
    done
    echo $wildcard_mask;
}

check_net_boundary() {
    net=$1;
    wildcard_mask=$2;
    is_correct=1;
    for (( i = 1; i <= 4; i++ )); do
        net_octet=$(echo $net | cut -d '.' -f $i)
        mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
        if [[ $mask_octet -gt 0 ]]; then
            if [ $(( $net_octet&$mask_octet )) -ne 0 ]; then
                is_correct=0;
            fi
        fi
    done
    echo $is_correct;
}

#######################
##  MAIN
#######################
OPTIND=1;
getopts "fibh" force;

shift $((OPTIND-1))
if [ $force = 'h' ]; then
    echo ""
    echo -e "THIS SCRIPT WILL EXPAND A CIDR ADDRESS.\n\nSYNOPSIS\n  ./cidr-to-ip.sh [OPTION(only one)] [STRING/FILENAME]\nDESCRIPTION\n -h  Displays this help screen\n -f  Forces a check for network boundary when given a STRING(s)\n    -i  Will read from an Input file (no network boundary check)\n  -b  Will do the same as –i but with network boundary check\n\nEXAMPLES\n    ./cidr-to-ip.sh  192.168.0.1/24\n   ./cidr-to-ip.sh  192.168.0.1/24 10.10.0.0/28\n  ./cidr-to-ip.sh  -f 192.168.0.0/16\n    ./cidr-to-ip.sh  -i inputfile.txt\n ./cidr-to-ip.sh  -b inputfile.txt\n"
    exit
fi

if [ $force = 'i' ] || [ $force = 'b' ]; then

    old_IPS=$IPS
    IPS=$'\n'
    lines=($(cat $1)) # array
    IPS=$old_IPS
        else
            lines=$@
fi

for ip in ${lines[@]}; do
    net=$(echo $ip | cut -d '/' -f 1);
    prefix=$(echo $ip | cut -d '/' -f 2);
    do_processing=1;

    bit_netmask=$(prefix_to_bit_netmask $prefix);

    wildcard_mask=$(bit_netmask_to_wildcard_netmask "$bit_netmask");
    is_net_boundary=$(check_net_boundary $net "$wildcard_mask");

    if [ $force = 'f' ] && [ $is_net_boundary -ne 1 ] || [ $force = 'b' ] && [ $is_net_boundary -ne 1 ] ; then
        read -p "Not a network boundary! Continue anyway (y/N)? " -n 1 -r
        echo    ## move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            do_processing=1;
        else
            do_processing=0;
#Kfuji-Edit
			exit 100
#Kfuji-Edit
        fi
    fi

    if [ $do_processing -eq 1 ]; then
        str=
        for (( i = 1; i <= 4; i++ )); do
            range=$(echo $net | cut -d '.' -f $i)
            mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
            if [[ $mask_octet -gt 0 ]]; then
                range="{$range..$(( $range | $mask_octet ))}";
            fi
            str="${str} $range"
        done
        ips=$(echo $str | sed "s, ,\\.,g"); ## replace spaces with periods, a join...

        eval echo $ips | tr ' ' '\n'
else
exit
    fi

done
}

#Function that runs the other function, in the background. This causes isup_func to complete near instantaniously as all it was supposed to do was spawn isup_func_func in the background. This was the key to testing each IP in the subnet simultaniously.
isup_func()
{

#Function to ping an IP a few times to see if its up.
    isup_func_func()
	
        {

        for arg
        do
		
			/bin/ping -c 4 "$arg" > /dev/null

				if [ $? -eq 0 ];
				then
					echo node $arg UP
				else
					echo node $arg DOWN
				fi
        done

        }

for arg
do
	isup_func_func $arg &
done
}

#Spawns 1 background process per ip, to longtest each each ip that was found to be pingable with the previous short test.
multiping_func() 
{
for arg
do

	/bin/ping $arg -c 100 -i 0.20 | grep -v bytes &

done
}

# - - - - - END_OF_FUNCTIONS - - - - - #

# - - - - - START_OF_SANITISATION - - - - - 
#Check user input and exit if supplied with more than one argument.
if [ $# -gt 1 ];
	then
	echo "Too many arguments. Use -h for help."
	exit 1 #Failure
fi

#Check user iput and print helpful messages if they input correctly.
if [[ $1 =~ ^(-h|-help|--help)$ ]];
then
	echo ""
	echo "Welcome to A.I.S.T.T please enter a valid Network Address/CIDRmask to begin."
	echo "Examples: 10.0.50.96/29 192.168.25.96/28 172.17.17.32/27"
	echo "You can scan subnets down to a /30 and up to a /24"
	echo "Ensure you enter the Network Address of the subnet or you will ping outside of the subnet."
	echo ""
	exit 101 # Help Success
fi

#Check user input for "a valid Network Address/CIDRmask between /24 and /30" and exit with helpful messages if anything else.
if [[ ! $1 =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([2][4-9]|30))$ ]];
then
	echo "You did not enter a valid Network Address/CIDRmask between /24 and /30. Use -h for help."
	exit 1 #Failure
fi

# - - - - - END_OF_SANITISATION - - - - - #

# - - - - - START_OF_MAIN  - - - - - 

host_input=$(echo $1 | cut -d '/' -f 1)
cidr_input=$(echo $1 | cut -d '/' -f 2)
netmask=${conversion_array[$cidr_input]}

printf "Debug:\n host_input:$host_input\n cidr_input:$cidr_input\n netmask:$netmask"

IFS=. read -r i1 i2 i3 i4 <<< "$host_input"
IFS=. read -r m1 m2 m3 m4 <<< "$netmask"
network_addr=$(printf "%d.%d.%d.%d" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))")


echo ""
printf "Testing Subnet $network_addr/$cidr_input"
echo ""

			#Calculate and store all the individual IP address within the subnet the user input, removing the network address and broadcast address.
	list_of_ips=$(ip_calc_func -f $network_addr/$cidr_input | sed '1d;$d')

echo "Subnet Includes:"
echo "$list_of_ips"
echo ""
echo "Found ICMP Service on Hosts:"

			#Run a background process that pings each IP within the subnet and stores the IP's that test positive for ICMP service. 
	list_of_up_ips=$(isup_func $list_of_ips | grep UP | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' )

	if [ "$list_of_up_ips" = "" ]
	then
		echo "No hosts up."
		echo ""
		exit 100 # Partial Success
	fi	
			
echo "$list_of_up_ips"
echo ""
				
			#Run a final full length pingtest against all the nodes that where found to respond to ICMP.
	multiping_func $list_of_up_ips		

echo "Pingtest Result:"
		
wait # Wait for all Background/related process to finish.
	
echo ""

exit 0 # Success
# - - - - - END_OF_MAIN  - - - - - #
#KFuji
