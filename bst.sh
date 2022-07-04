#!/bin/bash

##
# Color  Variables - bash color codes
##
green='\e[32m'
blue='\e[34m'
lblue='\e[1;34m'
cyan='\e[36m'
lcyan='\e[1;36m'
green='\e[32m'
lgreen='\e[1;32m'
magneta='\e[35m'
lpurple='\e[1;35m'
red='\e[31m'
yellow='\e[33m'
clear='\e[0m'

##
# Color Functions - echo commands with diferent colors
##

ColorLightCyan(){
	echo -ne $lcyan$1$clear
}
ColorGreen(){
	echo -ne $green$1$clear
}
ColorLightGreen(){
	echo -ne $lgreen$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}
ColorLightBlue(){
	echo -ne $lblue$1$clear
}
ColorMagneta(){
	echo -ne $magneta$1$clear
}
ColorLightPurple(){
	echo -ne $lpurple$1$clear
}
ColorRed(){
	echo -ne $red$1$clear
}
ColorYellow(){
	echo -ne $yellow$1$clear
}

##
# Functions used in application
##

server_name=$(hostname)   # variable association with hostname command result
##
# Main Menu 1) System information Function - list informations from system
function system_info() {
	clear   # clear the terminal
	echo -e "\n\n\n"   # 3 empty line
	ColorLightCyan "\t ----- System Information on ${server_name} -----"   # title
	echo -e "\n"
	echo -e "\tManufacturer:\t\t\t"`cat /sys/class/dmi/id/chassis_vendor`   # get chassis_vendor
	echo -e "\tProduct Name:\t\t\t"`cat /sys/class/dmi/id/product_name`     # get product_name
	echo -e "\tArchitecture:\t\t\t"`uname -m`                               # get arch. model
	echo -e "\tSystem name:\t\t\t"`uname`                                   # get operating system type
	echo -e "\tOperating System:\t\t"`cat /etc/issue | awk '{print $1,$2,$3}'` # get operating system name
	echo -e "\tKernel version:\t\t\t"`uname -r`                             # get linux kernel version
	echo -e "\tKernel version info:\t\t"`uname -v`                          # get linux kernel version since info
	echo -e "\tSystem is up since:\t\t"`uptime -s`                          # get system up since
	echo -e "\t\t\t=> System is "`uptime -p`                                # get time of system up
	echo -e "\tHostname:\t\t\t${server_name}"                               # get a hostname
	echo ""  
	ColorLightBlue "\t\tPress any key to continue...      "                 # write a message
	read -s -n 1                           # wait for key press - read -n1 - this means wait for one key and not need to press enter
}

##
# Main Menu 2) System monitoring Function - show system parameters with 2sec refresh
function system_monitoring() {
	while true; do
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- System monitoring on ${server_name} ---"   # title
	echo -e "\n\n"
	echo -e "\tTotal CPU core number:\t\t\t"`grep processor /proc/cpuinfo | wc -l`   # get total number of cpu cores
	echo -e "\tAverage CPU load for 1,5,15 minutes:\t"`cat /proc/loadavg | awk '{ print $1,$2,$3 }'` # get system average load
	echo -e "\n\tFirst 10 processess ordered by CPU usage:\t"
	ps -eo pid,comm,pcpu,pmem --sort -pcpu | head
	echo -e "\n\tFirst 10 processess ordered by Memory usage:\t"
	ps -eo pid,comm,pcpu,pmem --sort -pmem | head
	echo -e "\n\tSystem Memory status in MB:\t"
	free -m
	echo -e "\n\tSCSI and SATA devices status:\t"
	df -h | head -1; df -h | grep sd | sort -d     # list the hard devices status
	ColorLightBlue "\n\n\tPress any key to exit,\t\v or wait 2 seconds for refresh\n"
	   if read -r -s -n 1 -t 2; then      # waiting for one key press(-n1) in a time 2sec(-t2) and don't show the pressed key
	        break
	   fi
	done
}

##
# Main Menu 3) Network information Function - list network informations
function network_info() {
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- Network Information on ${server_name} ---"   # title
	echo -e "\n\n"
	echo -e "\tHostname:\t\t\t\t\t"`hostname`                           # get a hostname
	myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"        # get a public ip address with dig command
	echo -e "\tPublic IP address:\t\t\t\t${myip}"
	echo -e "\tPrivate Local IP/netmask in CIDR notation:\t"`ip addr show |grep -w inet |grep -v 127.0.0.1|awk '{ print $2}'`
						# get a local/private ip with ip command and formated with grep, awk and print
	echo -e "\tMAC address:\t\t\t\t\t"`ip addr show | grep -w ether | awk '{ print $2 }'` # get a mac address
	echo -e "\tLocal Gateway:\t\t\t\t\t"`/sbin/ip route | awk '/^default/ { print $3 }'`  # get gateway ip from ip route command
	echo -e "\tLocal DNS Server:\t\t\t\t"`systemd-resolve --status | grep 'DNS Servers' | awk '{ print $3}'` # get the DNS server
	# echo -e "\tLocal DNS Server:\t\t\t\t"`grep 'nameserver' /etc/resolv.conf | awk '{ print $2}'`
	echo ""  
	ColorLightBlue "\t\tPress any key to continue...      "
	read -s -n 1
}

##
# Main Menu 4) IP tools menu Function
function ip_tools_menu() {   # sub meniu for other functions
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t\t ------ IP tools ------"   # title
	echo -e "\n"
	echo -ne "
		$(ColorLightPurple '\tSub Menu')
		$(ColorLightPurple '\t--------')
		$(ColorGreen ' 1)')  ping a IP
		$(ColorGreen ' 2)')  trace route
		$(ColorGreen ' 3)')  IP lookup 
		$(ColorGreen ' 4)')  Back to Main Menu
		$(ColorRed ' 0)')  Exit 

		$(ColorLightBlue '\tChoose an option:') "
        read -n 1 c
        case $c in
	        1) ping_ip ; ip_tools_menu ;;
	        2) trace_route ; ip_tools_menu ;;
	        3) ip_lookup ; ip_tools_menu ;;
	        4) mainmenu ;;
		0) echo -e "\n"; ColorLightPurple "\t\t :-) Bye bye. :-)"; echo ; sleep 3; clear; exit 0 ;;
		*) ColorRed '\t Wrong option!' ; sleep 2; ip_tools_menu ;;
        esac
}

## Sub Menu 1) ping a IP Function
function ping_ip() {
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- Ping a custom ip address/host ---"   # title
	echo -e "\n\n"
	echo -ne "\tPlease enter a ip address/host: "; read pingip; echo              # wait for ip input
	echo -ne "\tPlease enter a ping count (default is 3): "; read pingcount; echo # wait for ping count
	pingcount=${pingcount:-3}   # default value 3 for variable pingcount
	ping -c ${pingcount} ${pingip}                       # the ping command
	echo -e "\n\n"  
	ColorLightBlue "\t\tPress any key to continue...      "
	read -s -n 1
	ip_tools_menu                                        # return to sub menu
}

## Sub Menu 2) trace route Function
function trace_route() {
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- Traceroute for a custom ip/host ---"   # title
	echo -e "\n\n"
	echo -ne "\tPlease enter a ip address/host: "; read traceip; echo
	traceroute ${traceip}                                # the traceroute command
	echo -e "\n\n"  
	ColorLightBlue "\t\tPress any key to continue...      "
	read -s -n 1
	ip_tools_menu                                        # return to sub menu
}

## Sub Menu 3) IP lookup Function
function ip_lookup() {
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- Lookup for a custom ip/host/FQDN ---"   # title
	echo -e "\n\n"
	echo -ne "\tPlease enter a ip/host/FQDN: "; read lookupaddress; echo
	host ${lookupaddress}                                # the lookup command for ip/host resolution
	echo -e "\n\n"  
	ColorLightBlue "\t\tPress any key to continue...      "
	read -s -n 1
	ip_tools_menu                                        # return to sub menu
}

##
# Main Menu 5) Web page status check Function -  check a web url http status code
function web_check() {
	clear
	echo -e "\n\n\n"
	ColorLightCyan "\t --- Check a web server status ---"   # title
	echo -e "\n\n"
	echo -ne "\tPlease enter a web url: "; read webpath; echo              # wait for url input
	status_code=$(curl --write-out %{http_code} --silent --output /dev/null ${webpath}) # get the http status code with curl command
	if [[ "$status_code" -ne 200 ]] ; then                                 # sort after diferent status codes
	  echo -e "\t\tSite http status code: $status_code\n"
	  if [[ "$status_code" -eq 302 ]] ; then
	  ColorYellow "\t :-|   The site: ${webpath} - is redirected!"
	  else
	  ColorRed "\t :-(   The site: ${webpath} - don't reachable!"
	  fi
	else
	  echo -e "\t\tSite http status code: $status_code\n"
	  ColorLightGreen "\t :-)   The site: ${webpath} - is reachable!"
	fi
	echo
	web_check_menu                                         # continue with web_check_menu menu
}

# Main Menu 5) Web page status check menu Function
function web_check_menu() {
	echo -e "\n\n\n"
	echo -ne "
		$(ColorGreen ' 1)')  Run other check
		$(ColorGreen ' 2)')  Back to Main Menu
		$(ColorRed ' 0)')  Exit

		$(ColorLightBlue '\tChoose an option:') "
	read -n 1 b
	case $b in
	        1) web_check ;;
	        2) mainmenu ;;
		0) echo -e "\n"; ColorLightPurple "\t\t\t :-) Bye bye. :-)"; echo ; sleep 3; clear; exit 0 ;;
		*) ColorRed '\t Wrong option!' ; sleep 2; clear; web_check_menu ;;
        esac
}

##
# Main Menu
##
mainmenu(){
clear
ColorLightCyan '\v\t\v BASIC \v SYSTEM \v TOOLS \v'   # application title
echo -ne "
$(ColorLightPurple '\tMain Menu')
$(ColorLightPurple '\t=========')
$(ColorGreen ' 1)')  System information
$(ColorGreen ' 2)')  System monitoring
$(ColorGreen ' 3)')  Network information 
$(ColorGreen ' 4)')  IP tools menu (IP Ping and custom ping, IP trace route, IP lookup)
$(ColorGreen ' 5)')  Web page status check
$(ColorRed ' 0)')  Exit 

$(ColorLightBlue '\tChoose an option:') "
        read -n 1 a
        case $a in
	        1) system_info ; mainmenu ;;
	        2) system_monitoring ; mainmenu ;;
	        3) network_info ; mainmenu ;;
	        4) ip_tools_menu ; mainmenu ;;
	        5) web_check ; mainmenu ;;
		0) echo -e "\n"; ColorLightPurple "\t :-) Bye bye. :-)"; echo ; sleep 3; clear; exit 0 ;;
		*) ColorRed '\t Wrong option!' ; sleep 2; mainmenu ;;
        esac
}

##
# Begining of the application - Call the mainmenu function
##
mainmenu

# END

