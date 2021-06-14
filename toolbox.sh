#!/bin/bash

function ChackInstall() {
	 echo "Not Finsh"
	 o=$(man ls)
}

function ChackPing() {
	 echo -e " [...] 正在检查网络情况 \c"
	 ping -c 3 8.8.8.8 | grep -q "0% packet loss" && result1=1 || result1=0
	 if [ $result1 -eq 0 ];then
	 	 echo -e " [-] 未Ping到 8.8.8.8 \c"
	 	 ping -c 3 8.8.4.4 | grep -q "0% packet loss" && result2=1 || result2=0
		 if [ $result2 -eq 0 ];then
		 	  echo -e " [-] 无法连接到互联网"
			  exit -1
		 fi 
	 fi
	 echo "[Done.]"
}

while :
	do
		echo -e "\n 选项:"
		echo " [1] 系统"
		echo " [2] 漏洞库"
		echo " [3] 硬件设置"
		echo " [4] 无线攻击"
		echo " [5] 安装模块"
        echo " [6] 使用帮助"
		echo -e "\033[31m [9] 退出 \033[0m"
		echo ""
		read -p '[&] 选择功能: ' options
		echo "-------------------------------------------\
----------------------------------"

    if [ $options == 1 ]; then
	     o1="system"
    elif [ $options == 2 ]; then
    	 o1="Scan"
	elif [ $options == 3 ]; then
    	 o1="hardware"
    elif [ $options == 4 ]; then
	     o1="IEEE"
    elif [ $options == 5 ]; then
    	 o1="install"
    elif [ $options == 6 ]; then
         o1="Help"
    elif [ $options == 9 ]; then
 	     exit 0
    else
	     echo -e "\n[-] 未知选项: $options"
    fi

	if [ $o1 == system ]; then
    	#判断是否安装
		while :
	    	do
			echo -e "\n 选项:"
			echo " [1] 系统详情"
			echo " [2] 软件更新"
			echo -e "\033[31m [9] 返回 \033[0m"
			echo ""
			read -p '[&] 选择选项: ' o2
			echo "-------------------------------------------\
----------------------------------"
			if [ $o2 == 1 ]; then
				 echo "[+] 系统详情:"
    			 neofetch #Use:neofetch
    			 date
			elif [ $o2 == 2 ]; then
				 ChackPing
				 sudo apt update && sudo apt upgrade \
&& sudo apt autoremove && sudo apt autoclean
			elif [ $o2 == 9 ]; then
				 continue 2			 
			else
				 echo -e "\n[-] 未知选项: $o2"
			fi
		 done
	fi
	
	if [ $o1 == Scan ]; then
	 while :
	    do
		echo -e "\n 选项:"
		echo " [1] 扫描漏洞"
		echo " [2] 漏洞库"
		echo -e "\033[31m [9] 返回 \033[0m"
		echo ""
		read -p '[&] 选择选项: ' o2
		echo "-------------------------------------------\
----------------------------------"
		if [ $o2 == 1 ]; then
			 read -p '[&] 输入需要扫描的IP: ' nmapScan
			 echo "需要一点时间去扫描IP: $nmapScan"
			 sudo nmap -sV -p --script vuln --script-args unsafe $nmapScan
			 break 2
		elif [ $o2 == 2 ]; then
			 bash code/Melware.sh
			 break 2
		elif [ $o2 == 9 ]; then
			 continue 2			 
		else
			 echo -e "\n[-] 未知选项: $o2"
		fi
	 done
	fi

	if [ $o1 == hardware ]; then
		 bash code/netcard.sh
	fi

	if [ $o1 == IEEE ]; then
		while :
	    	do
			echo -e "\n 选项:"
			echo " [1] 嗅探网络"
			echo " [2] 协议攻击"
			echo -e "\033[31m [9] 返回 \033[0m"
			echo ""
			read -p '[&] 选择选项: ' o2
			echo "-------------------------------------------\
----------------------------------"
			if [ $o2 == 1 ]; then
				 bash code/scapy.sh
			elif [ $o2 == 2 ]; then
				 bash code/IEEE.sh
			elif [ $o2 == 9 ]; then
				 continue 2			 
			else
				 echo -e "\n[-] 未知选项: $o2"
			fi
		 done
	fi

	if [ $o1 == install ]; then
	 	ChackPing
	 	bash code/install_module.sh
	fi  

	if [ $o1 == Help ]; then
		 cat code/readme.txt
		 cat code/help.txt
		 echo ""
		 echo "-------------------------------------------\
----------------------------------"
	fi
done