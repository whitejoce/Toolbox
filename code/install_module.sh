#!/bin/bash

function aptLinux() {
    #apt software
    o3="0"
    while :
    do
	    echo " [=] 选项:"
    	echo ""
    	echo " [1] apt"
    	echo " [2] apt-get"
    	echo -e "\033[31m [9] 返回 \033[0m"
	    echo ""
    	read -p '[&] 选择下载方式: ' o2
	    echo "-------------------------------------------\
----------------------------------"
    	if [ $o2 == 1 ]; then
	    	install_way="apt"
            o3="1"
            break
	    elif [ $o2 == 2 ]; then
		    install_way="apt-get"
            o3="1"
            break
	    elif [ $o2 == 9 ]; then
		    break			 
	    else
		    echo -e "\n [-] 未知选项: $o2"
	    fi
    done
    if [ $o3 == 1 ]; then
        echo -e " [./] 将使用$install_way来下载，\c"
        read -rsp $'回车键继续...\n'
        sudo ${install_way} update
        sudo ${install_way} -y install neofetch
        sudo ${install_way} -y install aircrack-ng
        sudo ${install_way} -y install mdk3
        sudo ${install_way} -y install macchanger
        sudo ${install_way} -y install nmap


        #wafw00f
         read -rsp $'即将下载wafw00f（可使用Ctrl+C退出）,按回车键继续...\n'
        git clone https://github.com/EnableSecurity/wafw00f.git
        sudo chmod -R 777 wafw00f
        cd wafw00f
		python3 setup.py install
		cd ..
        #fluxion
        read -rsp $'即将下载fluxion（可能下载后会自己启动，可使用Ctrl+C退出）,按回车键继续...\n'
        git clone https://www.github.com/FluxionNetwork/fluxion.git
		sudo chmod -R 777 fluxion
        cd fluxion
		sudo ./fluxion.sh -i 
        cd ..
        #airgeddon
        read -rsp $'即将下载airgeddon（下载后启动依赖环境自检，可使用Ctrl+C退出）,按回车键继续...\n'
		git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git
        sudo chmod -R 777 airgeddon
		sudo bash airgeddon/airgeddon.sh
		cd ..
        echo ""
        echo "-------------------------------------------\
----------------------------------"
    else
        echo ""
    fi
}

function yumLinux() {
    #yum software
    read -rsp $'回车键继续...\n'
    sudo yum clean all
    sudo yum makecache
    echo " [!] 暂不支持."
    #sudo yum -y install neofetch
    #sudo yum -y install aircrack-ng
    #sudo yum -y install mdk3
    #sudo yum -y install macchanger
}

function pipLinux() {
    #pip3 install
    read -rsp $' [./] 回车键下载...\n'
    pip3 install requests
    pip3 install beautifulsoup4
    echo ""
    echo "-------------------------------------------\
----------------------------------"
}


if [[ $(id -u) -ne 0 ]]; then 
	echo " [!] 需要root权限运行" 
	exit 1
fi

echo "-------------------------------------------\
----------------------------------"
while :
do
	echo -e "[=] 选项:"
	echo ""
	echo "  [1] 全部下载"
	echo "  [2] 引用软件"
	echo "  [3] python库"
    echo "  [4] 展示下载内容"
	echo -e "\033[31m  [9] 退出 \033[0m"
	echo ""
	read -p '[&] 选择要下载的软件范围 :' options
	echo "-------------------------------------------\
----------------------------------"
    if [ $options == 1 -o $options == 2 ]; then
        aptLinux
    elif [ $options == 3 ]; then
        pipLinux
    elif [ $options == 4 ]; then
        echo " [pip]  beautifulsoup4(用于解析html),requests(用于爬取新闻)"
        echo " [Git]  fluxion,airgeddon"
        echo " [软件] neofetch(显示系统详情),nmap"
        echo "        aircrack-ng,mdk3,macchanger(更改网卡的MAC地址)"
        echo ""
        read -rsp $' [./] 回车键返回菜单...'
        echo -e "\n-------------------------------------------\
----------------------------------"
    elif [ $options == 9 ]; then
        exit 0
    else
        echo -e "\n[-] 未知选项: $options"
    fi

done