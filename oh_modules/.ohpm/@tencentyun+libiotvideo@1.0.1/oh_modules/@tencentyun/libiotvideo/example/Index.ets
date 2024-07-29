/*
import { IoTVideoBridge, OnStateListener } from "@tencentyun/libiotvideo"
import hilog from '@ohos.hilog';
import { IjkMediaPlayer } from "@ohos/ijkplayer";
import type { OnPreparedListener } from "@ohos/ijkplayer";
import type { OnVideoSizeChangedListener } from "@ohos/ijkplayer";
import type { OnCompletionListener } from "@ohos/ijkplayer";
import type { OnBufferingUpdateListener } from "@ohos/ijkplayer";
import type { OnErrorListener } from "@ohos/ijkplayer";
import type { OnInfoListener } from "@ohos/ijkplayer";
import type { OnSeekCompleteListener } from "@ohos/ijkplayer";
import { LogUtils } from "@ohos/ijkplayer";

const productID: string = "XXXXXX"
const deviceName: string = "XXXXXX"
const xp2pInfo: string = "XXXXXX"

@Entry
@Component
struct Index {
  @State mContext: object | undefined = undefined;

  xcomponentController: XComponentController = new XComponentController()
  build() {
    RelativeContainer() {
      XComponent({
        id: 'xcomponentId',
        type: 'surface',
        libraryname: 'ijkplayer_napi'
      }).onLoad((context?: object) => {
          if (!!context){
            this.mContext = context;
          }
        }).onDestroy(() => {
        }).width('100%').aspectRatio(16/9).backgroundColor(Color.Black)

      Text("开播")
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          hilog.info(0x0000, 'testTag', 'Test NAPI 8 + 8 = %{public}d', 3);

          //启动iotvideo sdk
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
          IoTVideoBridge.getInstance().startAppWith(productID, deviceName, 0)
          IoTVideoBridge.getInstance().setXp2pInfo(deviceName, xp2pInfo);

        })

      Text("发信令")
        .id('newtext')
        .fontSize(45)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .offset({
          x:0,
          y:-100
        })
        .onClick(() => {
          hilog.info(0x0000, 'testTag', 'commanddd = %{public}d', 3);

          //发个信令
          IoTVideoBridge.getInstance().getCommandRequestWithAsync(deviceName, "action=inner_define&channel=0&cmd=get_device_st&type=live", ((result: string) => {
                hilog.info(0x0000, 'testTag', 'getCommandRequestWithAsync = %{public}s', result);
          }));

          //开启对讲
          // IoTVideoBridge.getInstance().startTalk(deviceName);
          // setTimeout(() => {
          //   hilog.info(0x0000, 'XComponent', 'stopTalk======');
          //
          //   IoTVideoBridge.getInstance().stopTalk(deviceName);
          // }, 15000) //5s
        })
    }
    .height('100%')
    .width('100%')
  }

  private onReadyed() {
    let videourl = IoTVideoBridge.getInstance().getUrlForHttpFlv(deviceName) + "ipc.flv?action=live&quality=standard&channel=0";
    hilog.info(0x0000, 'testTag', 'pages/Index-->onReady-->%{public}s', videourl);

    this.play(videourl);
  }

  private play(url: string) {

    let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
    // 设置XComponent回调的context
    mIjkMediaPlayer.setContext(this.mContext, "xcomponentId");
    // 设置debug模式
    mIjkMediaPlayer.setDebug(true);
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

    // 使用精确寻帧 例如，拖动播放后，会寻找最近的关键帧进行播放，很有可能关键帧的位置不是拖动后的位置，而是较前的位置.可以设置这个参数来解决问题
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", "1");
    // 预读数据的缓冲区大小
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", "102400");
    // 停止预读的最小帧数
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "min-frames", "100");
    // 启动预加载
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", "1");
    // 设置无缓冲，这是播放器的缓冲区，有数据就播放
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", "0");
    // 跳帧处理,放CPU处理较慢时，进行跳帧处理，保证播放流程，画面和声音同步
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", "5");
    // 最大缓冲cache是3s， 有时候网络波动，会突然在短时间内收到好几秒的数据 因此需要播放器丢包，才不会累积延时
    // 这个和第三个参数packet-buffering无关。
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max_cached_duration", "3000");
    // 无限制收流
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1");
    // 屏幕常亮
    mIjkMediaPlayer.setScreenOnWhilePlaying(true);
    // 设置超时
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "connect_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "listen_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "addrinfo_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "dns_cache_timeout", "10000000");

    let mOnVideoSizeChangedListener: OnVideoSizeChangedListener = {
      onVideoSizeChanged(width: number, height: number, sar_num: number, sar_den: number) {
        LogUtils.getInstance().LOGI("setOnVideoSizeChangedListener-->go:" + width + "," + height + "," + sar_num + "," + sar_den)
      }
    }
    mIjkMediaPlayer.setOnVideoSizeChangedListener(mOnVideoSizeChangedListener);
    let mOnPreparedListener: OnPreparedListener = {
      onPrepared() {
        LogUtils.getInstance().LOGI("setOnPreparedListener-->go");
      }
    }
    mIjkMediaPlayer.setOnPreparedListener(mOnPreparedListener);

    let mOnCompletionListener: OnCompletionListener = {
      onCompletion() {
        LogUtils.getInstance().LOGI("OnCompletionListener-->go")
      }
    }
    mIjkMediaPlayer.setOnCompletionListener(mOnCompletionListener);

    let mOnBufferingUpdateListener: OnBufferingUpdateListener = {
      onBufferingUpdate(percent: number) {
        LogUtils.getInstance().LOGI("OnBufferingUpdateListener-->go:" + percent)
      }
    }
    mIjkMediaPlayer.setOnBufferingUpdateListener(mOnBufferingUpdateListener);

    let mOnSeekCompleteListener: OnSeekCompleteListener = {
      onSeekComplete() {
        LogUtils.getInstance().LOGI("OnSeekCompleteListener-->go")
      }
    }
    mIjkMediaPlayer.setOnSeekCompleteListener(mOnSeekCompleteListener);

    let mOnInfoListener: OnInfoListener = {
      onInfo(what: number, extra: number) {
        LogUtils.getInstance().LOGI("OnInfoListener-->go:" + what + "===" + extra)
      }
    }
    mIjkMediaPlayer.setOnInfoListener(mOnInfoListener);

    let mOnErrorListener: OnErrorListener = {
      onError(what: number, extra: number) {
        LogUtils.getInstance().LOGI("OnErrorListener-->go:" + what + "===" + extra)
      }
    }
    mIjkMediaPlayer.setOnErrorListener(mOnErrorListener);
    mIjkMediaPlayer.setMessageListener();
    mIjkMediaPlayer.prepareAsync();
    mIjkMediaPlayer.start();
  }
}
*/