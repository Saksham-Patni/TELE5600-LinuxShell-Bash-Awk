
#!/bin/bash

. .datafile

YLW='\e[1;33m'
NC='\e[0m' # No Color

switch(){
  while [ $option -ne 8 ]; do

     case "$option" in

    1 ) echo -e "${YLW}Should the port be active at boot time?${NC} Yes/No"
        read ans
        if [[ "$ans" == "Yes" || "$ans" == "No" ]]; then
         sed -i -c "s/\(ONBOOT *= *\).*/\1$ans/" ifcfg-eth$port
         echo -e "${YLW}Thank you. Updated config is: ${NC}"
         cat ifcfg-eth$port|column -t -s'=' 2>/dev/null
        else
         echo -e "${YLW}Invalid value${NC}"
        fi;;

   2 ) echo -e "${YLW}How should the port get an ip?${NC} Choose between none/bootp/dhcp"
       read ans2
       if [[ "$ans2" == "none" || "$ans2" == "bootp" || "$ans2" == "dhcp" ]]; then
          sed -i -c "s/\(BOOTPROTO *= *\).*/\1$ans2/" ifcfg-eth$port
          echo -e "${YLW}Thank you. Updated config is: ${NC}"
          cat ifcfg-eth$port|column -t -s'='  2>/dev/null
       else
          echo -e "${YLW}Invalid value${NC}"
       fi;;

   3 ) echo -e "${YLW}What is the NETMASK?${NC}"
       read ans3
       echo $ans3 |grep -E -q '^(254|252|248|240|224|192|128)\.0\.0\.0|255\.(254|252|248|240|224|192|128|0)\.0\.0|255\.255\.(254|252|248|240|224|192|128|0)\.0|255\.255\.255\.(254|252|248|240|224|192|128|0)'
       if [ $? -eq 0 ];then
         sed -i -c "s/\(NETMASK *= *\).*/\1$ans3/" ifcfg-eth$port
         echo -e "${YLW}Thank you. Updated config is: ${NC}"
         cat ifcfg-eth$port|column -t -s'='  2>/dev/null
       else
         echo -e "${YLW}Invalid value${NC}"
       fi;;

  4 ) echo -e "${YLW}Whats the IP address?${NC}"
      read ans4
      
      if [[ "$ans4" =~ ^((1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]];then
        sed -i -c "s/\(IPADDR *= *\).*/\1$ans4/" ifcfg-eth$port
        echo -e "${YLW}Thank you. Updated config is: ${NC}"
        cat ifcfg-eth$port|column -t -s'='  2>/dev/null
      else 
        echo -e "${YLW}Invalid IP address${NC}"
      fi;;

  5 ) echo -e "${YLW}Would you want non-root users control interface setup?${NC} Yes/No" 
      read ans5
      if [[ "$ans5" == "Yes" || "$ans5" == "No" ]];then
         sed -i -c "s/\(USERCTL *= *\).*/\1$ans5/" ifcfg-eth$port
         echo -e "${YLW}Thank you. Updated config is: ${NC}"
         cat ifcfg-eth$port|column -t -s'='  2>/dev/null
      else
         echo -e "${YLW}Invalid value${NC}"
      fi;;

  6 ) echo -e "${YLW}Would you want to set a value for PEERDNS?${NC} Yes/No"
      read ans6
      if [[ "$ans6" == "Yes" || "$ans6" == "No" ]];then
        sed -i -c "s/\(PEERDNS *= *\).*/\1$ans6/" ifcfg-eth$port
        echo -e "${YLW}Thank you. Updated config is: ${NC}"
        cat ifcfg-eth$port|column -t -s'='  2>/dev/null
      else
        echo -e "${YLW}Invalid value${NC}"
      fi;;

  7 ) echo -e "${YLW}Should IPv6 be enabled on this port?${NC} Yes/No"
      read ans7
      if [[ "$ans7" == "Yes" || "$ans7" == "No" ]]; then
         sed -i -c "s/\(IPV6INIT *= *\).*/\1$ans7/" ifcfg-eth$port
         echo -e "${YLW}Thank you. Updated config is: ${NC}"
         cat ifcfg-eth$port|column -t -s'='  2>/dev/null
      else
         echo -e "${YLW}Invalid value${NC}"
      fi;;

  * ) echo -e "${YLW}Invalid option chosen${NC}";;

  esac

  echo -e "${YLW}Any other parameter that you wish to configure?${NC} \n1-ONBOOT\n2-BOOTPROTO\n3-NETMASK\n4-IPADDR\n5-USERCTL\n6-PEERDNS\n7-IPV6INIT\n8-QUIT"
  read option
  done
}

interfaces()
{
  echo -e "${YLW}Choose the port you would like to configure: ${NC}"
  echo -e "0. ETH0  \n1. ETH1  \n2. ETH2  \n3. ETH3"
  read -p "RESPONSE [0-4]: " port
  if [[ $port == 0 ]] || [[ $port == 1 ]] || [[ $port == 2 ]] || [[ $port == 3 ]]; then
     echo -e "${YLW}Okay. The current configuration of that port is: ${NC}"
     cat ifcfg-eth$port| column -t -s'='  2>/dev/null
     echo -e "${YLW}What parameter would you like to edit. Select from the following options: ${NC}\n1-ONBOOT\n2-BOOTPROTO\n3-NETMASK\n4-IPADDR\n5-USERCTL\n6-PEERDNS\n7-IPV6INIT\n8-QUIT"
     read -p "RESPONSE [1-8]: " option
switch
else
  echo -e "${YLW}Invalid port number${NC}"
 fi

}

hosts(){
                cat -n $HOSTS
                echo -e "${YLW}To delete an entry; type line number \nelse type 0${NC}"
                read -p "Your Response: " lineNum
                if [[ ! $lineNum == "0" ]]; then
                        sed -i -e "$lineNum d" $HOSTS
                cat -n $HOSTS
                        break
                else
                echo -e "${YLW}Type IP and Hostname to add an entry; \notherwise type 0${NC}"
                read -p "Your Response: " newEntry

                if [[ ! $newEntry == "0" ]]; then
                        abc='(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])'
                        if [[ $newEntry =~ ^$abc\.$abc\.$abc\.$abc\ .*$ ]];then
                        echo $newEntry >> $HOSTS
                cat -n $HOSTS
                else
                echo "Enter valid IP and Hostname"
                        fi
                fi
                continue
                break
                fi

}

sysctl(){

printf "\n"
column -t -s'=' $SYSCTL 2>/dev/null| grep -v '#'
printf "\n"
echo -e "${YLW}Enter the parameter to edit: ${NC}"
read parameter
if [[ $parameter =~ "net.ipv4.ip_forward"|"net.ipv4.conf.default.rp_filter"|"net.ipv4.conf.default.accept_source_route"|"kernel.sysrq"|"kernel.core_uses_pid"|"net.ipv4.tcp_synack_retries"|"net.ipv4.conf.all.send_redirects"|"net.ipv4.conf.default.send_redirects"|"net.ipv4.conf.all.accept_source_route"|"net.ipv4.conf.all.accept_redirects"|"net.ipv4.conf.all.secure_redirects"|"net.ipv4.conf.all.log_martians"|"net.ipv4.conf.default.accept_source_route"|"net.ipv4.conf.default.accept_redirects"|"net.ipv4.conf.default.secure_redirects"|"net.ipv4.icmp_echo_ignore_broadcasts"|"net.ipv4.tcp_syncookies"|"net.ipv4.conf.all.rp_filter"|"net.ipv4.conf.default.rp_filter"|"net.ipv6.conf.default.router_solicitations"|"net.ipv6.conf.default.accept_ra_rtr_pref"|"net.ipv6.conf.default.accept_ra_pinfo"|"net.ipv6.conf.default.accept_ra_defrtr"|"net.ipv6.conf.default.autoconf"|"net.ipv6.conf.default.dad_transmits"|"net.ipv6.conf.default.max_addresses"|"kernel.exec-shield"|"kernel.randomize_va_space"|"fs.file-max"|"kernel.pid_max"|"net.ipv4.ip_local_port_range" ]];then               
                while true
                do
                        printf "\n"
                        echo -e "${YLW}Enter the value:${NC}"
                        read sysctl
                        if [[ $sysctl =~ ^([0-9]{1,5}) ]];
                        then

                                sed -i -e "s/\($parameter = \).*/\1$sysctl/" $SYSCTL
                                column -t -s'=' $SYSCTL 2>/dev/null| grep -v '#'

                        else
                                echo -e "${YLW}Enter a valid input${NC}"
                        continue
                        fi
                        break
                done
fi
                printf "\n"
                echo -e "${YLW}The updated file is:${NC}" 
                column -t -s'=' $SYSCTL 2>/dev/null| grep -v '#'

}

resolv(){
                cat -n $RESOLV
                echo -e "${YLW}To delete an entry; type line number \nelse type 0${NC}"
                read -p "Your Response: " lineNum
                if [[ ! $lineNum == "0" ]]; then
                        sed -i -e "$lineNum d" $RESOLV
                cat $RESOLV
                        break
                else
                echo -e "${YLW}type IP and Domain name to add an entry; \notherwise type 0${NC}"
                read -p "IP: " newEntry
                if [[ ! $newEntry == "0" ]]; then
                        abc='(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])'
                        if [[ $newEntry =~ ^$abc\.$abc\.$abc\.$abc$ ]];then
                        read -p "Enter Domain name: " Domain
                        added=($Domain" "$newEntry)
                        echo $added >> $RESOLV

                cat $RESOLV
                        else
                        echo "${YLW}Enter valid IP and Domain name${NC}"
                        fi
                fi

                break
                fi
                cat $RESOLV
} 


networking=("Enable/Disable Networking" "Hostname")
network(){
cat $NETWORK
echo -e "${YLW}Choose the element you want to edit: ${NC}"
echo -e "1.Enable/Disable Networking\n2.Hostname"
read -p "Response: [1/2] " opt
case $opt in
        1)
                while true
                do
                        cat $NETWORK
                        printf "\n"
                        echo -e "${YLW}Enter the value (yes or no): ${NC}"
                        read value
                        if [[ $value =~ "yes"|"no" ]]
                        then
                        sed -i -e "1s/\(=\).*/\1$value/" $NETWORK
                        break
                        elif [[ ! -n "$value" ]]
                        then
                        break
                        else
                                echo -e "${YLW}Enter the correct value :${NC}"
                        continue
                        fi
                done;;

        2)
                while true
                do
                        cat $NETWORK
                        printf "\n"
                        echo -e "${YLW}Enter the hostname :${NC}"
                        read name
                        sed -i -e "2s/\(=\).*/\1$name/" $NETWORK
                        break
                        if [[ ! -n "$name" ]]
                        then
                               break
                        fi
                done;;

       *) echo -e "${YLW}Looks like you made no changes. Thank you${NC}"
          break
          ;;
esac

echo -e "${YLW}Thank you, here is the updated network file.${NC}"
cat $NETWORK

}

OPTS=`getopt -o dhinpsSI: -n 'parse-options' -- "$@"`

if [[ $# != 0 ]]; then
eval set -- "$OPTS"

while true; do
 case "$1" in
      -i)
          interfaces
          exit 0;;

      -s) 
         echo -e "${YLW}The current configuration is: ${NC}\n"
         echo -e "${YLW}Interfaces: ${NC}\n" &&  cat ${ETH0} && cat ${ETH1} && cat ${ETH2} && cat ${ETH3} \n
         echo -e "${YLW}Hosts: ${NC}" && cat ${HOSTS} \n
         echo -e "${YLW}DNS: ${NC}\n" && cat ${RESOLV} \n
         echo -e "${YLW}Network: ${NC}\n" && cat ${NETWORK} \n
         echo -e "${YLW}Sysctl: ${NC}\n" &&  column -t -s'=' $SYSCTL 2>/dev/null| grep -v '#'
         exit 0;;

      -d)
          resolv
          exit 0;;

      -h)
          hosts
          exit 0;;

      -S)
          sysctl
          exit 0;;

      -n)
          network
          exit 0;;

      -I)           
           if [[ $2 == 0 ]] || [[ $2 == 1 ]] || [[ $2 == 2 ]] || [[ $2 == 3 ]]; then
     echo -e "${YLW}Okay. The current configuration of that port is: ${NC}"
     cat ifcfg-eth$2| column -t -s'='  2>/dev/null
     echo -e "${YLW}What parameter would you like to edit. Select from the following options: ${NC}\n1-ONBOOT\n2-BOOTPROTO\n3-NETMASK\n4-IPADDR\n5-USERCTL\n6-PEERDNS\n7-IPV6INIT\n8-QUIT" 
     read -p "RESPONSE [1-8]: " option
     switch
           fi
          exit 0;;

 esac
done
fi

adddate() {
        IFS= read -r 
        echo "$(date) $line"
        script_name=`basename "$0"`
        echo "$script_name"
        break
}  

log_file="/home/saksham/Downloads/logfile"
PS3='choose the file you want to edit: '
options=("Interfaces" "DNS" "sysctl" "Hosts" "Network")
select opt in "${options[@]}"
do
case $opt in
        "Interfaces")
                interfaces
                adddate
                break;;

        "DNS")
                resolv
                adddate
                break;;

        "sysctl")
                sysctl
                adddate
                break;;

        "Hosts")
                hosts
                adddate
                break;;

        "Network")
                network
                adddate
                adddate >> $log_file
                break;;

        *)
                echo "invalid option";;
esac
done
