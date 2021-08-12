---
title: Pomelo-vscode断点调试
date: 2020-05-04 19:15:45
tags: pomelo
---

## 注意：根据系统的不同，参数也不太一样，如果以下方式不行，请查看node版本
### win系统：使用--inspect，即："args":"--inspect=32312"
### mac系统：使用 --debug，即："args":"--debug=32312" 


1、在launch.json添加如下配置，没有就add一个配置
port端口需要和server.json一致，server.json配置见第二点
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "attach",
            "name": "Attach to Remote",
            "address": "127.0.0.1",
            "port": 32312,
            "localRoot": "${workspaceFolder}/game-server",
            "remoteRoot": "/Users/undakunteera/Documents/WeChatGame/Code/server/pomelo/chatofpomelo-websocket/game-server"
        },
        {
            "type": "node",
            "request": "launch",
            "name": "启动程序 (development)",
            "program": "${workspaceRoot}/game-server/app.js",
            "args": [
                "env=development",
                "type=all"
            ]
        },
    ]
}
```
2. sever.json添加“"args":"--debug=32312"”,以官方聊天demo为例,在此行添加调试端口：
  "chat":["id":"chat-server-1", "host":"127.0.0.1", "port":6050,"args":"--debug=32312"}
        ],
```
{
    "development":{
        "connector":[
             {"id":"connector-server-1", "host":"127.0.0.1", "port":4050, "clientPort": 3050, "frontend": true},
             {"id":"connector-server-2", "host":"127.0.0.1", "port":4051, "clientPort": 3051, "frontend": true},
             {"id":"connector-server-3", "host":"127.0.0.1", "port":4052, "clientPort": 3052, "frontend": true}
         ],
        "chat":[
             {"id":"chat-server-1", "host":"127.0.0.1", "port":6050, "args":"--debug=32312"}
        ],
        "gate":[
	       {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
	    ]
    },
    "production":{
           "connector":[
             {"id":"connector-server-1", "host":"127.0.0.1", "port":4050, "clientPort": 3050, "frontend": true},
             {"id":"connector-server-2", "host":"127.0.0.1", "port":4051, "clientPort": 3051, "frontend": true},
             {"id":"connector-server-3", "host":"127.0.0.1", "port":4052, "clientPort": 3052, "frontend": true}
         ],
        "chat":[
             {"id":"chat-server-1", "host":"127.0.0.1", "port":6050},
             {"id":"chat-server-2", "host":"127.0.0.1", "port":6051},
             {"id":"chat-server-3", "host":"127.0.0.1", "port":6052}
        ],
        "gate":[
           {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
        ]
  }
}

```

3.调试方式
![屏幕快照 2019-05-21 上午12.50.42.png](https://upload-images.jianshu.io/upload_images/4743656-0884b61b5f8535b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

a.先启动"启动程序"即app.js入口
b.在切换到"attack to remote"再次启动远程调试

这样就可以打断点调试了

