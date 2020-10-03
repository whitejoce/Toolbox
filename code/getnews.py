#!/usr/bin/python
# _*_coding: utf-8 _*_

import os
import sys
import requests
from bs4 import BeautifulSoup


url = "https://news.sina.com.cn/china/" #IEEE.sh
res = requests.get(url)

res.encoding = 'utf-8'
#soup = BeautifulSoup(res.text, 'lxml')
#print(soup.title.text)
soup=BeautifulSoup(res.text,'html.parser')
#print(soup.text)
if os.path.exists("code/news.txt"):
    os.remove("code/news.txt")
getnews =""
for news in soup.select(".right-content"):
    #print(news)
    #print (news.select("a"))
    new_as=news.select("a")
    for news_a in new_as:
        getnews = getnews + (news_a.text) +('\n')

print("[+] 获取新闻(来自:" + url +"):" )
print(getnews)


with open('code/news.txt','w') as f:
       f.write(getnews)