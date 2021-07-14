#!/bin/bash

#Coder:Whitejoce
#Ver  :0.2

function Banner() {
 echo ""
 echo ""
 echo -e "\033[36m   _/_/_/_/_/                    _/  _/ \033[0m"        
 echo -e "\033[36m      _/      _/_/      _/_/    _/  _/_/_/      _/_/    _/    _/ \033[0m"   
 echo -e "\033[36m     _/    _/    _/  _/    _/  _/  _/    _/  _/    _/    _/_/ \033[0m"      
 echo -e "\033[36m    _/    _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/ \033[0m"   
 echo -e "\033[36m   _/      _/_/      _/_/    _/  _/_/_/      _/_/    _/    _/ \033[0m"   
 echo ""
 echo -e "\033[36m -----------------------------------------\
---------------------- \033[0m"

}

function CheckPing() {
	 echo -e "[...] 正在检查网络情况 \c"
	 ping -c 3 8.8.8.8 | grep -q "0% packet loss" && result1=1 || result1=0
	 if [ $result1 -eq 0 ];then
	 	 echo -e "[-] 未Ping到 8.8.8.8 \c"
	 	 ping -c 3 8.8.4.4 | grep -q "0% packet loss" && result2=1 || result2=0
		 if [ $result2 -eq 0 ];then
		 	  echo -e "[-] 无法连接到互联网"
			  exit -1
		 fi 
	 fi
	 echo "[Done.]"
}

if [[ $EUID -ne 0 ]]; then 
	echo " [!] 需要root权限运行" 
	exit 1
fi

while :
	do
		Banner
		echo -e "\n[=] 选项:"
		echo ""
		echo "  [1] 系统方面"
		echo "  [2] 漏洞扫描"
		echo "  [3] 硬件设置"
		echo "  [4] 无线攻击"
		echo "  [5] 安装模块"
        echo "  [6] 使用帮助"
		echo -e "\033[31m  [9] 退出 \033[0m"
		echo ""
		read -p '[&] 选择功能: ' options

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
			echo "-------------------------------------------\
----------------------------------"
			echo -e " [=] 选项:"
			echo ""
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
				 echo "-------------------------------------------\
----------------------------------"

			elif [ $o2 == 2 ]; then
				 CheckPing
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
		echo "-------------------------------------------\
----------------------------------"
		echo -e "\n [=] 选项:"
		echo ""
		echo " [1] 扫描漏洞"
		echo " [2] 扫描WAF"
		echo " [3] 漏洞库更新"
		echo " [4] 如何使用?"
		echo -e "\033[31m [9] 返回 \033[0m"
		echo ""
		read -p '[&] 选择选项: ' o2
		echo "-------------------------------------------\
----------------------------------"
		if [ $o2 == 1 ]; then
			 read -p '[&] 输入需要扫描的IP: ' nmapScan
			 echo "[!] 需要一点时间去扫描IP: $nmapScan"
			 sudo nmap -v --script=smb-vuln-*.nse --script-args=unsafe=1 $nmapScan
			 continue 1
		elif [ $o2 == 2 ]; then
			 echo -e "[...] 检查工具是否安装 \c"
			 which wafw00f
			 if [ "$?" -ne 0 ]; then
			 	 echo " [!] 未安装相关工具" 
				 echo " [!] 需要安装wafw00f(快速安装可关注https://github.com/whitejoce/Software_Intsall)" 
				 exit 0 
			 fi
			 CheckPing
			 read -p '[&] 输入需要扫描的网站IP或域名: ' url
			 echo ""
			 wafw00f $url | grep "]"
			 continue 1
		elif [ $o2 == 3 ]; then
			 CheckPing]
			 read -rsp $' [./] 开始更新漏洞库，回车确认...\n'
             sudo searchsploit -u
			 #bash code/Malware.sh
			 continue 1
		elif [ $o2 == 4 ]; then
			 echo " [Q&A] 如何使用"
			 echo " 使用指令searchexploit可以查询exploit-db中的漏洞渗透模块"
			 echo " 使用查询到的Path就可以引用了"
			 continue 1
		elif [ $o2 == 9 ]; then
			 continue 2			 
		else
			 echo -e "\n [-] 未知选项: $o2"
		fi
	 done
	fi

	if [ $o1 == hardware ]; then
		 bash code/netcard.sh
	fi

	if [ $o1 == IEEE ]; then
		 echo "-------------------------------------------\
----------------------------------"
		 bash code/IEEE.sh
	fi

	if [ $o1 == install ]; then
	 	CheckPing
	 	bash code/install_module.sh
	fi  

	if [ $o1 == Help ]; then
		 cat code/readme.txt
		 echo ""
		 echo "-------------------------------------------\
----------------------------------"
	fi
done