---
title: LayaAir-【Laya2.x-微信小游戏分包加载】微信已经提高到了12M
date: 2020-05-04 19:06:58
tags: laya
---

#### 如有遗漏、错误，麻烦各位指正。
#### 分包后的目录结构：![image.png](https://upload-images.jianshu.io/upload_images/4743656-5b2c3debc4179d72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 一、Laya IDE版本：###2.2.0
#### 二、单个脚本文件超过4M暂没处理这个（你为什么要吧这个代码文件超过4m自己解决下！！！！！！），单个分包不能超过4Mb
#### 三、加载流程，将wxgame目录下的libs下的，laya.core.js、laya.ui.js、laya.d3.js拷贝到子包目录下的libs（新建的目录）
![image.png](https://upload-images.jianshu.io/upload_images/4743656-c12cc262788cc6f7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000)
#### 四、代码修改
1.wxgame目录下index.js修改为：
```
loadLib("js/bundle.js");

```
2.wxgame目录下bundle.js修改为：（我测试了3个子包，总包大小一共11.3mb）
##### 注意：代码中的TODO部分，TODO部分是原本bundle.js的内容，简单说，之类就是必须等所有子包下载完成后并初始化以后才能去启动游戏代码
```
let wx = window.wx;
var _loadSubPackage = function (name, failCall, sucessCall) {
    wx.loadSubpackage({
        name: name,
        success: function (res) {
            console.log("加载" + name + "包成功！");
            sucessCall && sucessCall()
        },
        fail: function (res) {
            console.log("加载" + name + "分包失败！")
            failCall && failCall()
        }
    })
}
let NeedLoadSubPackageCount = 3
var allLoadFinish = function () {
    NeedLoadSubPackageCount--
    if (NeedLoadSubPackageCount == 0) {
      //TODO:这里是原本bundle.js的内容
    }
}

_loadSubPackage("subpackage", null, allLoadFinish)
_loadSubPackage("subpackage2", null, allLoadFinish)
_loadSubPackage("subpackage3", null, allLoadFinish)

```

###五、子包的配置
1.子包必须要有game.js
这里我的子包中的game.js：
```
window.loadLib = require;
require("index.js");
```
2.子包的index.js(根据自己的代码结构来），这里我是直接拷贝之前wxgame的index.js来加载laya类库
```
/**
 * 设置LayaNative屏幕方向，可设置以下值
 * landscape           横屏
 * portrait            竖屏
 * sensor_landscape    横屏(双方向)
 * sensor_portrait     竖屏(双方向)
 */
window.screenOrientation = "sensor_landscape";

//-----libs-begin-----
loadLib("libs/laya.core.js");
loadLib("libs/laya.ui.js");
loadLib("libs/laya.d3.js")//-----libs-end-------
//loadLib("js/bundle.js");
console.log("分包1初始化完成")
```
3.配置game.json,增加subpackages，配置如下：
```
{
  "deviceOrientation": "portrait",
  "showStatusBar": false,
  "networkTimeout": {
    "request": 10000,
    "connectSocket": 10000,
    "uploadFile": 10000,
    "downloadFile": 10000
  },
  "subpackages": [
    {
      "name": "subpackage",
      "root": "subpackage/"
    },
    {
      "name": "subpackage2",
      "root": "subpackage2/"
    },
    {
      "name": "subpackage3",
      "root": "subpackage3/"
    }
  ]
}
```
4.完成了上面3个步骤，所有工作都昨晚了，现在就是去微信ide工具调试了

#### 六、结果
![image.png](https://upload-images.jianshu.io/upload_images/4743656-9329c8cf5ea09992.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

#### 七、注意，应该需要对微信小游戏的基础库进行判定，基础库使用2.1.0 及以上版本。(这里我没去测试，各位看官自行去解决~）
检测代码：
```
//检查版本 
var info = wx.getSystemInfoSync()
console.log("info.SDKVersion",info.SDKVersion)
if (compareVersion(info.SDKVersion,"2.1.0") >= 0) {
    console.log("大于2.1.0版本")
    window.GameIsSubPackage = true; 
}else{
    console.log("小于2.1.0版本 手动触发") 
    //require("./subpackage/game.js"); 
    window.GameIsSubPackage = false; 

```
#### 八、还不清楚？参考https://www.cnblogs.com/yuan33/p/11730966.html文章

#### 九、 测试demo github地址：待传~
#### 十、优化加载流程
![image.png](https://upload-images.jianshu.io/upload_images/4743656-d3682ca67d4ad990.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####增加一个子包加载器，加载了子包列表才去执行bundle.js文件

