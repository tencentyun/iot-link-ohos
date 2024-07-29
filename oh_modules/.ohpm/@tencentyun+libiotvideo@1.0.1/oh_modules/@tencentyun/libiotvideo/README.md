### IoTVideo SDK 简介
IoTVideo SDK 主要提供了 Harmony APP 端 P2P 接入、实时监控、语音对讲、本地回放等基本能力。

### IoTVideo SDK 需要的权限, [申请应用权限](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/4_2_u7533_u8bf7_u5e94_u7528_u6743_u9650-V5)

```
ohos.permission.INTERNET
ohos.permission.MICROPHONE
```

### IoTVideo SDK 接入流程

1、在 DevEco Studio 的 Terminal 页面中添加如下依赖项

```
ohpm install @tencentyun/libiotvideo
```

2、手动集成，在模块的 oh-package.json5 文件中添加对应 dependencies，如下所示。 

```
"dependencies": {
   "@tencentyun/libiotvideo": "1.0.1"
}
```

3、初始化SDK,等待初始化 ready 后，在执行直播拉流或对讲或信令等操作，请将参数 pro_id、dev_name、xp2pinfo 替换为设备对应信息

```
import { IoTVideoBridge, OnStateListener } from "@tencentyun/libiotvideo"

let that = this;
let mOnStateListener: OnStateListener = {
   onReady() {
      hilog.info(0x0000, 'testTag', 'mOnStateListener-->onReady');
      that.onReadyed();
   },
   onDisconnect: (): void => {
      hilog.info(0x0000, 'testTag', 'mOnStateListener-->onDisconnect');
   }
}

IoTVideoBridge.getInstance().setMessageListener(mOnStateListener);
IoTVideoBridge.getInstance().startAppWith("pro_id", "dev_name", 0)
IoTVideoBridge.getInstance().setXp2pInfo("dev_name","xp2pinfo");
```

4、拉流操作,请将参数 pro_id、dev_name、xp2pinfo 替换为设备对应信息，ijkplayer接入[具体参考](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fijkplayer) 

```
private onReadyed() {
   let videourl = IoTVideoBridge.getInstance().getUrlForHttpFlv("dev_name") + "ipc.flv?action=live&quality=standard&channel=0";
   hilog.info(0x0000, 'testTag', 'pages/Index-->onReady-->%{public}s', videourl);

   this.play(videourl);
}

xcomponentController: XComponentController = new XComponentController()
private play(url: string) {
    let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
    // 设置XComponent回调的context
    mIjkMediaPlayer.setContext(this.mContext, "xcomponentId");
    // 设置debug模式
    // mIjkMediaPlayer.setDebug(true);
    // 初始化配置
    mIjkMediaPlayer.native_setup();
    // 设置视频源
    mIjkMediaPlayer.setDataSource(url.toString());
    // 设置视频源http请求头
    let headers =  new Map([
      ["user_agent", "Mozilla/5.0 BiliDroid/7.30.0 (bbcallen@gmail.com)"],
      ["referer", "https://www.bilibili.com"]
    ]);
    mIjkMediaPlayer.setDataSourceHeader(headers);
    mIjkMediaPlayer.prepareAsync();
    mIjkMediaPlayer.start();
}
```

5、发送信令,请将参数 pro_id、dev_name、xp2pinfo 替换为设备对应信息

```
IoTVideoBridge.getInstance().getCommandRequestWithAsync("dev_name", "action=inner_define&channel=0&cmd=get_device_st&type=live", ((result: string) => {
   hilog.info(0x0000, 'testTag', 'getCommandRequestWithAsync = %{public}s', result);
}));
```


6、对讲开启关闭,请将参数 pro_id、dev_name、xp2pinfo 替换为设备对应信息
```
IoTVideoBridge.getInstance().startTalk("dev_name");
setTimeout(() => {
   hilog.info(0x0000, 'XComponent', 'stopTalk======');
   IoTVideoBridge.getInstance().stopTalk("dev_name");
}, 5000)
```

### 参考事例
    集成后可参考 SDK example 目录下的事例.
    具体路径在 工程/oh_modules/@tencentyun/libiotvideo/example/Index.ets