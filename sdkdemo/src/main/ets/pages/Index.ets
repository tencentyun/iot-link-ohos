// import { IoTVideoBridge, OnStateListener } from "@tencentyun/libiotvideo"
// import hilog from '@ohos.hilog';
// import { IjkMediaPlayer } from "@ohos/ijkplayer";
// import type { OnPreparedListener } from "@ohos/ijkplayer";
// import type { OnVideoSizeChangedListener } from "@ohos/ijkplayer";
// import type { OnCompletionListener } from "@ohos/ijkplayer";
// import type { OnBufferingUpdateListener } from "@ohos/ijkplayer";
// import type { OnErrorListener } from "@ohos/ijkplayer";
// import type { OnInfoListener } from "@ohos/ijkplayer";
// import type { OnSeekCompleteListener } from "@ohos/ijkplayer";
// import { LogUtils } from "@ohos/ijkplayer";
// import { promptAction } from '@kit.ArkUI';
//
// const productID: string = "XXXXXX"
// const deviceName: string = "XXXXXX"
// const xp2pInfo: string = "XXXXXX"
//
// @Entry
// @Component
// struct Index {
//   @State mContext: object | undefined = undefined;
//   @State loadingVisible: Visibility = Visibility.Visible;
//   @State playVisible: Visibility = Visibility.None;
//   @State errorVisible: Visibility = Visibility.None;
//   @State playEnable: boolean = false;
//   @State sendCommandEnable: boolean = false;
//   @State stopTalkEnable: boolean = false;
//   @State startTalkEnable: boolean = false;
//   @State rotateAngle: number = 0
//   @State videoUrl: string = ""
//   xcomponentController: XComponentController = new XComponentController()
//
//   onPageShow(): void {
//     this.showLoading()
//     this.initSdk()
//   }
//
//   build() {
//     Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Auto, justifyContent: FlexAlign.Start }) {
//       Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
//         Text("p2p video demo")
//           .fontSize('40px')
//           .fontColor(Color.White)
//           .margin('30px')
//           .fontWeight(FontWeight.Bold)
//       }.height('100px').width('100%').backgroundColor(Color.Black)
//
//       Divider()
//         .vertical(false)
//         .strokeWidth('40px')
//         .color(Color.White)
//         .lineCap(LineCapStyle.Round)
//         .margin(10)
//       Stack({ alignContent: Alignment.Center }) {
//         XComponent({
//           id: 'xcomponentId',
//           type: 'surface',
//           libraryname: 'ijkplayer_napi'
//         })
//           .onLoad((context?: object) => {
//             this.mContext = context
//           })
//           .onDestroy(() => {
//           })
//           .width('100%')
//           .backgroundColor(Color.Black)
//           .aspectRatio(16 / 9)
//         Image($r('app.media.icon_play'))
//           .objectFit(ImageFit.Auto)
//           .width('120px')
//           .height('120px')
//           .visibility(this.playVisible)
//           .border({ width: 0 })
//           .borderStyle(BorderStyle.Dashed)
//         Image($r('app.media.icon_error'))
//           .objectFit(ImageFit.Auto)
//           .width('120px')
//           .height('120px')
//           .visibility(this.errorVisible)
//           .border({ width: 0 })
//           .borderStyle(BorderStyle.Dashed)
//         Image($r('app.media.icon_loading'))
//           .objectFit(ImageFit.Auto)
//           .width('120px')
//           .height('120px')
//           .visibility(this.loadingVisible)
//           .border({ width: 0 })
//           .borderStyle(BorderStyle.Dashed)
//           .rotate({ angle: this.rotateAngle })
//           .animation({
//             duration: 1200,
//             curve: Curve.Linear,
//             iterations: -1, // 设置-1表示动画无限循环
//             playMode: PlayMode.Normal,
//           })
//
//       }.width('100%').clip(true)
//
//       Divider()
//         .vertical(false)
//         .strokeWidth('60px')
//         .color(Color.White)
//         .lineCap(LineCapStyle.Round)
//         .margin(10)
//       Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
//         Text("播放")
//           .fontSize('40px')
//           .fontColor(Color.White)
//           .margin('10px')
//           .fontWeight(FontWeight.Bold)
//       }
//       .height('130px')
//       .width('100%')
//       .enabled(this.playEnable)
//       .backgroundColor(Color.Black)
//       .onClick(() => {
//         hilog.info(0x0000, 'testTag', 'Test NAPI 8 + 8 = %{public}d', 3);
//         this.hidePlay()
//         this.showLoading()
//         this.play(this.videoUrl);
//       })
//
//       Divider().vertical(false).strokeWidth('20px').color(Color.White).lineCap(LineCapStyle.Round)
//       Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
//         Text("发送信令")
//           .fontSize('40px')
//           .fontColor(Color.White)
//           .margin('10px')
//           .fontWeight(FontWeight.Bold)
//       }
//       .height('130px')
//       .width('100%')
//       .enabled(this.sendCommandEnable)
//       .backgroundColor(Color.Black)
//       .onClick(() => {
//         hilog.info(0x0000, 'testTag', 'commanddd = %{public}d', 3);
//
//         //发个信令
//         IoTVideoBridge.getInstance()
//           .getCommandRequestWithAsync(deviceName, "action=inner_define&channel=0&cmd=get_device_st&type=live",
//             ((result: string) => {
//               hilog.info(0x0000, 'testTag', 'getCommandRequestWithAsync = %{public}s', result);
//             }));
//
//         //开启对讲
//         // IoTVideoBridge.getInstance().startTalk(deviceName);
//         // setTimeout(() => {
//         //   hilog.info(0x0000, 'XComponent', 'stopTalk======');
//         //
//         //   IoTVideoBridge.getInstance().stopTalk(deviceName);
//         // }, 15000) //5s
//       })
//
//       Divider().vertical(false).strokeWidth('20px').color(Color.White).lineCap(LineCapStyle.Round)
//       Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
//         Text("开启对讲")
//           .fontSize('40px')
//           .fontColor(Color.White)
//           .margin('10px')
//
//           .fontWeight(FontWeight.Bold)
//       }
//       .height('130px')
//       .width('100%')
//       .enabled(this.startTalkEnable)
//       .backgroundColor(Color.Black)
//       .onClick(() => {
//         IoTVideoBridge.getInstance().startTalk(deviceName)
//         setTimeout(() => {
//           hilog.info(0x0000, 'XComponent', 'stopTalk======');
//           IoTVideoBridge.getInstance().stopTalk(deviceName);
//         }, 15000) //15s
//       })
//
//       Divider().vertical(false).strokeWidth('20px').color(Color.White).lineCap(LineCapStyle.Round)
//       Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
//         Text("停止对讲")
//           .fontSize('40px')
//           .fontColor(Color.White)
//           .margin('10px')
//           .fontWeight(FontWeight.Bold)
//       }
//       .height('130px')
//       .width('100%')
//       .enabled(this.stopTalkEnable)
//       .backgroundColor(Color.Black)
//       .onClick(() => {
//         IoTVideoBridge.getInstance().stopTalk(deviceName)
//       })
//     }
//   }
//
//   private setBtnEnable(enable: boolean) {
//     this.playEnable = enable
//     this.sendCommandEnable = enable
//     this.startTalkEnable = enable
//     this.stopTalkEnable = enable
//   }
//
//   private showLoading() {
//     this.rotateAngle = 360
//     this.loadingVisible = Visibility.Visible;
//     this.setBtnEnable(false)
//   }
//
//   private hideLoading() {
//     this.rotateAngle = 0
//     this.loadingVisible = Visibility.None;
//   }
//
//   private showPlay() {
//     this.playVisible = Visibility.Visible;
//     this.setBtnEnable(true)
//   }
//
//   private hidePlay() {
//     this.playVisible = Visibility.None;
//   }
//
//   private showError() {
//     this.errorVisible = Visibility.Visible;
//   }
//
//   private initSdk() {
//     //启动iotvideo sdk
//     let that = this;
//     let mOnStateListener: OnStateListener = {
//       onReady() {
//         hilog.info(0x0000, 'testTag', 'mOnStateListener-->onReady');
//         that.onReadyed();
//       },
//       onDisconnect: (): void => {
//         hilog.info(0x0000, 'testTag', 'mOnStateListener-->onDisconnect');
//       }
//     }
//     IoTVideoBridge.getInstance().setMessageListener(mOnStateListener);
//     IoTVideoBridge.getInstance().startAppWith(productID, deviceName, 0)
//     IoTVideoBridge.getInstance().setXp2pInfo(deviceName, xp2pInfo);
//   }
//
//   private onReadyed() {
//     this.videoUrl =
//       IoTVideoBridge.getInstance().getUrlForHttpFlv(deviceName) + "ipc.flv?action=live&quality=standard&channel=0";
//     hilog.info(0x0000, 'testTag', 'pages/Index-->onReady-->%{public}s', this.videoUrl);
//     this.hideLoading()
//     this.showPlay()
//     promptAction.showToast({ message: "p2p sdk初始化完成", duration: 200 });
//   }
//
//   private play(url: string) {
//     let that = this
//
//     let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
//     // 设置XComponent回调的context
//     mIjkMediaPlayer.setContext(this.mContext, "xcomponentId");
//     // 设置debug模式
//     mIjkMediaPlayer.setDebug(true);
//     // 初始化配置
//     mIjkMediaPlayer.native_setup();
//     // 设置视频源
//     mIjkMediaPlayer.setDataSource(url.toString());
//     // 设置视频源http请求头
//     let headers = new Map([
//       ["user_agent", "Mozilla/5.0 BiliDroid/7.30.0 (bbcallen@gmail.com)"],
//       ["referer", "https://www.bilibili.com"]
//     ]);
//     mIjkMediaPlayer.setDataSourceHeader(headers);
//
//     // 使用精确寻帧 例如，拖动播放后，会寻找最近的关键帧进行播放，很有可能关键帧的位置不是拖动后的位置，而是较前的位置.可以设置这个参数来解决问题
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", "1");
//     // 预读数据的缓冲区大小
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", "102400");
//     // 停止预读的最小帧数
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "min-frames", "100");
//     // 启动预加载
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", "1");
//     // 设置无缓冲，这是播放器的缓冲区，有数据就播放
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", "0");
//     // 跳帧处理,放CPU处理较慢时，进行跳帧处理，保证播放流程，画面和声音同步
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", "5");
//     // 最大缓冲cache是3s， 有时候网络波动，会突然在短时间内收到好几秒的数据 因此需要播放器丢包，才不会累积延时
//     // 这个和第三个参数packet-buffering无关。
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max_cached_duration", "3000");
//     // 无限制收流
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1");
//     // 屏幕常亮
//     mIjkMediaPlayer.setScreenOnWhilePlaying(true);
//     // 设置超时
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "timeout", "10000000");
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "connect_timeout", "10000000");
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "listen_timeout", "10000000");
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "addrinfo_timeout", "10000000");
//     mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "dns_cache_timeout", "10000000");
//
//     let mOnVideoSizeChangedListener: OnVideoSizeChangedListener = {
//       onVideoSizeChanged(width: number, height: number, sar_num: number, sar_den: number) {
//         LogUtils.getInstance()
//           .LOGI("setOnVideoSizeChangedListener-->go:" + width + "," + height + "," + sar_num + "," + sar_den)
//       }
//     }
//     mIjkMediaPlayer.setOnVideoSizeChangedListener(mOnVideoSizeChangedListener);
//     let mOnPreparedListener: OnPreparedListener = {
//       onPrepared() {
//         LogUtils.getInstance().LOGI("setOnPreparedListener-->go");
//         that.hideLoading()
//       }
//     }
//     mIjkMediaPlayer.setOnPreparedListener(mOnPreparedListener);
//
//     let mOnCompletionListener: OnCompletionListener = {
//       onCompletion() {
//         LogUtils.getInstance().LOGI("OnCompletionListener-->go")
//         that.showPlay()
//       }
//     }
//     mIjkMediaPlayer.setOnCompletionListener(mOnCompletionListener);
//
//     let mOnBufferingUpdateListener: OnBufferingUpdateListener = {
//       onBufferingUpdate(percent: number) {
//         LogUtils.getInstance().LOGI("OnBufferingUpdateListener-->go:" + percent)
//       }
//     }
//     mIjkMediaPlayer.setOnBufferingUpdateListener(mOnBufferingUpdateListener);
//
//     let mOnSeekCompleteListener: OnSeekCompleteListener = {
//       onSeekComplete() {
//         LogUtils.getInstance().LOGI("OnSeekCompleteListener-->go")
//       }
//     }
//     mIjkMediaPlayer.setOnSeekCompleteListener(mOnSeekCompleteListener);
//
//     let mOnInfoListener: OnInfoListener = {
//       onInfo(what: number, extra: number) {
//         LogUtils.getInstance().LOGI("OnInfoListener-->go:" + what + "===" + extra)
//       }
//     }
//     mIjkMediaPlayer.setOnInfoListener(mOnInfoListener);
//
//     let mOnErrorListener: OnErrorListener = {
//       onError(what: number, extra: number) {
//         LogUtils.getInstance().LOGI("OnErrorListener-->go:" + what + "===" + extra)
//         that.hideLoading();
//         that.showError()
//       }
//     }
//     mIjkMediaPlayer.setOnErrorListener(mOnErrorListener);
//     mIjkMediaPlayer.setMessageListener();
//     mIjkMediaPlayer.prepareAsync();
//     mIjkMediaPlayer.start();
//   }
// }
