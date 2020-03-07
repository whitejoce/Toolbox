# Toolbox
One code.
*   Toolbox  
    

使用Python编写,Shell脚本调用系统指令(工具脚本).

Python版本: 3

系统环境(已测试): Kali,Ubuntu,Raspbian.

* * *

  

*   一键下载所需工具(aircrack-ng,mdk3,neofetch):
    

```python
$ python --install
```

*   功能:  
    

一键apt更新(-U or --update): 相当于apt \[update,upgrade,autoremove.\].  

制造SSID为新闻标题的AP(--newsAP):  新闻摘自[http://news.sina.com.cn/china/](http://news.sina.com.cn/china/ "Sina") .

快速使用Namp扫描系统漏洞(--Nvuln):不用记指令了.

了解系统详情(-V or --sysver):使用neofetch工具.

*   使用制造AP功能需要网卡支持监听模式,还请注意是否更改mac问题(可以选择).  
    

更多功能还请看源代码(toolbox.py),欢迎交流.

  

功能(badAP,WEP,WAP2)还未实现,后续更新:

badAP : 无赖AP

WEP:破解wep

WPA2:基于四次握手尝试破解wpa

  

* * *

*   使用方法:
    

```python
$ pyhton toolbox.py -h
```

*   选项:
    

```python
$ python toolbox.py -{h,V,i,U,d:}
``````python
$ python toolbox.py --{sysver,update,apmaker,install,download,Nvuln,
info,newsAP,badAP,WEP,WPA2}
```
