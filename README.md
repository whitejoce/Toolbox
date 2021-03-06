# Pentest-Toolbox

      _/_/_/_/_/                    _/  _/ 
         _/      _/_/      _/_/    _/  _/_/_/      _/_/    _/    _/ 
        _/    _/    _/  _/    _/  _/  _/    _/  _/    _/    _/_/ 
       _/    _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/ 
      _/      _/_/      _/_/    _/  _/_/_/      _/_/    _/    _/ 

    --------------------------------------------------------------- 


* 声明
 
     本代码仓库采用MIT许可协议（[The MIT License](https://github.com/whitejoce/Wireless-Toolbox/blob/master/LICENSE)）
 
     此脚本仅做学习交流（以及快速配置渗透审计工具），切勿用于任何非法用途！
 
 * 关于
 
     现已全部汉化，以后还是以中文来编写，如果对此脚本感兴趣，还请星标，感谢支持！:)
 
     切换至模块化代码，各个部分可以单独调用
 
* * *

* Toolbox  

     >使用`Shell`脚本调用系统指令,`Python`爬虫；
     >
     >Bash版本：4.2+ ,Python版本：3.x
     >
     >系统环境（兼容"apt类Linux"）: Kali(已测试),Ubuntu(已测试),Raspbian(已测试).
     > 
     >此脚本在于快速使用或实现某一功能，所以部分功能依赖于其他软件(需要下载);
     > 
     >功能的调用为命令行菜单式，更加方便

* * *

*   使用方法:
    
     `~#: bash toolbox.sh`


* * *

*   菜单式界面

*   一键下载所需工具

    >现已整合[fluxion](https://github.com/FluxionNetwork/fluxion)，[airgeddon](https://github.com/v1s1t0r1sh3r3/airgeddon)脚本
    

* 功能:  
    

    1.一键apt更新: 相当于apt \[update,upgrade,autoremove,autoclean\]；

    2.快速使用Namp扫描系统漏洞:不用记指令了；
 
    3.了解系统详情:使用neofetch工具；
 
    4.无线网卡快速设置
    
    5.一键更新漏洞库（[Exploit-DB](https://www.exploit-db.com/)）
    
    6.扫描WAF
 
 * * *
 
 * 针对网络协议(IEEE 802.11):
 
   分为三个选项(在引导菜单中可以看到):
 
   创建大量AP：新闻AP(SSID)，随机AP(SSID);
 
   制造SSID为新闻标题的AP: 新闻摘自[Sina](https://news.sina.com.cn/china/)；
 
   WEP,WPS,WPA,WPA2的破解（使用脚本[airgeddon](https://github.com/v1s1t0r1sh3r3/airgeddon)）
   
   无赖AP（evil twin）, MITM: 中间人攻击(基于[fluxion](https://github.com/FluxionNetwork/fluxion))
 
  使用制造AP功能需要网卡支持监听模式,还请注意是否更改mac地址问题(可以选择)；
    
  更多功能还请看源代码,欢迎交流。

  
***

*   以下功能还未实现,后续更新:

    无线网络嗅探: 嗅探隐藏SSID，嗅探Probe，FTP账号以及登录口令嗅探；

    Wireless: 蓝牙(CC2540 USB),ZigBee(CC2531 USB)和无线(HackRF One)方面的快速调试;
 
     [pwnagotchi](https://github.com/evilsocket/pwnagotchi): 处理“吃”来的握手包
  

 *    推荐书籍
  
   > 《Kali Linux无线渗透测试指南》 作者：[英]Cameron Buchanan,[印度]Vivek Ramachandran [此书链接](https://www.epubit.com/bookDetails?id=N13524);
   >
   > 《Python绝技：运用Python成为顶级黑客》 作者：[美]TJ O'Connor [此书链接](http://www.broadview.com.cn/book/4495);
 
 * * *
 
 * 功能提示
 
    在`getnews.py`文件中，Python版本应为3

 * 帮助
 
    如提示设备未托管，无法上网，请将`/etc/NetworkManager/NetworkManager.conf `
    中的`managed=false`改为`managed=true`,保存后重启(或者`sudo service network-manager restart`)；
 
 
 * * *
 
 * Welcome translation into English（Sorry for my poor English）.
