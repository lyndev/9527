---
title: Python-解决str转长数值字符，自动转成科学计数法问题
date: 2020-05-04 19:16:55
tags: python
---

最近策划这边遇到用写python写的转标工具，很长数值，被自动输出了科学计数问题：
正确的结果应该是如下：
![image.png](https://upload-images.jianshu.io/upload_images/4743656-a296f5bc1590df27.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

怎么去解决python,str输出的数值不转成科学计数法呢：
###  利用： "%.f" % float(value)
value使我们要转换的值
这里我截取部分代码：
```
      _v = str(value)
      if _v.find("e+") != -1:
            __v = "%.f" % float(value)
            return '"'+ str(__v) +'"'
        return '"' + str(value) + '"'
```
