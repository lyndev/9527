---
title: Python-解决转excel到文件后中文乱码问题
date: 2020-05-04 19:16:52
tags: python
---

### 2.x版本
reload(sys)
sys.setdefaultencoding('utf-8')
### 3.x版本
将内容转utf8在转gbk
  str(内容.encode('utf-8').decode('gbk'))