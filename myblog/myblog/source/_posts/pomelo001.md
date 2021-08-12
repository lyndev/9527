--- 
title: Pomelo-扩展例子，增加一个 rpc服务器
date: 2020-05-04 19:10:55
tags: pomelo
---

#### 一、增加一个逻辑服务器（game）
##### 1.拷贝一份chat 文件夹，修改为game, 里面的脚本和代码做相应的修改

##### 2.server.json增加game服务器地址配置
```
{
    "development":{
        "connector":[
             {"id":"connector-server-1", "host":"127.0.0.1", "port":4050, "clientPort": 3050, "frontend": true},
             {"id":"connector-server-2", "host":"127.0.0.1", "port":4051, "clientPort": 3051, "frontend": true},
             {"id":"connector-server-3", "host":"127.0.0.1", "port":4052, "clientPort": 3052, "frontend": true}
         ],
        "chat":[
             {"id":"chat-server-1", "host":"127.0.0.1", "port":6050}
        ],
        "game":[
               {"id":"game-server-1", "host":"127.0.0.1", "port":6051,  "args":"--inspect=5858"}
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
        "game":[
          {"id":"game-server-1", "host":"127.0.0.1", "port":6051}
     ],
        "gate":[
           {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
        ]
  }
}

```

 ##### 3.注册服务器,在adminServer.json配置game服务器配置（这里之前没配置，导致启动服务器出错）
```
[
    {
        "type": "connector",
        "token": "agarxhqb98rpajloaxn34ga8xrunpagkjwlaw3ruxnpaagl29w4rxn"
    },
    {
        "type": "chat",
        "token": "agarxhqb98rpajloaxn34ga8xrunpagkjwlaw3ruxnpaagl29w4rxn"
    },
    {
        "type": "game",
        "token": "agarxhqb98rpajloaxn34ga8xrunpagkjwlaw3ruxnpaagl29w4rxn"
    },
    {
        "type": "gate",
        "token": "agarxhqb98rpajloaxn34ga8xrunpagkjwlaw3ruxnpaagl29w4rxn"
    }
]
```
 ##### 4.在连接服务器，新增代码, 其实为了方便我只是对chat服务器的相应代码做了拷贝简单修改为game服务器
```
handler.enterGame = function(msg, session, next) {
	var self = this;
	var rid = msg.rid;
	var uid = msg.username + '*' + rid
	var sessionService = self.app.get('sessionService');

	//duplicate log in
	if( !! sessionService.getByUid(uid)) {
		next(null, {
			code: 500,
			error: true
		});
		return;
	}

	session.bind(uid);
	session.set('rid', rid);
	session.push('rid', function(err) {
		if(err) {
			console.error('set rid for session service failed! error is : %j', err.stack);
		}
	});
	session.on('closed', onUserLeaveGame.bind(null, self.app));

	//put user into channel
	self.app.rpc.game.gameRemote.add(session, uid, self.app.get('serverId'), rid, true, function(users){
		next(null, {
			users:users
		});
	});
};


/**
 * User log out handler
 *
 * @param {Object} app current application
 * @param {Object} session current session object
 *
 */
var onUserLeaveGame = function(app, session) {
	if(!session || !session.uid) {
		return;
	}
	app.rpc.game.gameRemote.kick(session, session.uid, app.get('serverId'), session.get('rid'), null);
};
```
  ##### 5.启动服务器，通过之前的客户端的聊天例子，重新修改发送消息接口

![image.png](https://upload-images.jianshu.io/upload_images/4743656-0f3f6d378c5c82e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 二、大功告成，下步继续研究pomelo的mmorpg游戏的服务器，目前搞懂这个聊天服务器，已经可以用到小游戏的服务器上了，把数据库加入，基本可以了（正在把之前写的微信小游戏服务器转移到这个架构上来）