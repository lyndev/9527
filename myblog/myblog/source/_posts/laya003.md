---
title: laya一些细节注意事项
date: 2020-05-04 19:09:32
tags: laya
---

一、问题：导出特效，在场景中创建并设置位置，预览看起来没有设置到指定位置，且被其他场景物体遮挡了

二、主要是场景中的其他物体材质的RenderQueue层级高于了当前特效到RenderQueue，解决办法是在unity3d中修改他们的RenderQueue值，越高渲染层级越高
![image.png](https://upload-images.jianshu.io/upload_images/4743656-a47d7dc8e5bd054f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


三、粒子特效请使用additive叠加模式

