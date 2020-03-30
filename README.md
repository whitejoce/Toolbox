# Wireless-Toolbox
One code.
*   Toolbox  
    

 使用`Python`编写,`Shell`脚本调用系统指令(工具脚本)；

 Python版本: 3；

 系统环境(已测试): Kali,Ubuntu,Raspbian.

* * *

  

*   一键下载所需工具 :
    

 `$ python toolbox.py --install `

*   功能:  
    

 一键apt更新(`-U` or `--update`): 相当于apt \[update,upgrade,autoremove,autoclean\]；

 快速使用Namp扫描系统漏洞(`--Nvuln`):不用记指令了；
 
 创建恶意无线热点（`--fakeAP`）：已整合进fakeAP，选项：`random`; 
 
 无赖AP(`--fakeAP`):  已整合进fakeAP，针对以太网（evil twin），选项：`badAP`;
 
 制造SSID为新闻标题的AP(`--fakeAP`):  已整合进fakeAP，选项：`newsAP`,新闻摘自[Sina](https://news.sina.com.cn/china/)；
 
 了解系统详情(`-V `or `--sysver`):使用neofetch工具；
 
 WEP破解（`--fakeAP`): Caffe Latte,选项：`Caffe_Latte`；
 
 无线网络嗅探(`--Wifi`): 嗅探隐藏SSID`Probe,ALL`，嗅探Probe`Probe,Hidden`，FTP账号以及登录口令嗅探`Probe,FTP`；
 

*   使用制造AP功能需要网卡支持监听模式,还请注意是否更改mac地址问题(可以选择)；
    

 更多功能还请看源代码(`toolbox.py`),欢迎交流。

  
***

*   以下功能还未实现,后续更新:

 WEP: 破解wep(穷尽数据包)；

 WPA2: 根据四次握手尝试破解wpa;

 Wireless: 蓝牙(CC2540 USB),ZigBee(CC2531 USB)和无线(Hack-RF)方面的快速调试;
 
 MITM: 中间人攻击
  

* * *

*   使用方法:
    
 `$ pyhton toolbox.py -h`

*   选项(只能带一个选项):
    

 `$ python toolbox.py -{h,V,i,U,d}`

 `$ python toolbox.py --{sysver,update,fakeAP,install,download,Nvuln,
 info,Wifi}`
 
 
 * * *
*    推荐书籍
  
  《Kali Linux无线渗透测试指南》 作者：[英]Cameron Buchanan,[印度]Vivek Ramachandran 
  [此书链接](https://www.epubit.com/bookDetails?id=N13524);
