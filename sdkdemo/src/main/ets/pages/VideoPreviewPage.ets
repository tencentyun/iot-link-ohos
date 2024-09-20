import {
  IjkMediaPlayer,
  LogUtils,
  OnBufferingUpdateListener,
  OnCompletionListener,
  OnErrorListener,
  OnInfoListener,
  OnPreparedListener,
  OnSeekCompleteListener,
  OnVideoSizeChangedListener
} from '@ohos/ijkplayer'
import { DevInfo, VideoProductP2PResponse } from '../data/VideoDescribeProduct'
import { CheckActionBox } from './CheckActionBox'
import { AccessInfo } from '../data/AccessInfo'
import { AccessDevInfo } from './VideoMainPage'
import { IoTVideoBridge, OnStateListener } from '@tencentyun/libiotvideo'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { VideoViewModel } from '../viewmodel/VideoViewModel'
import { VideoCallback } from '../callback/VideoCallback'
import CommonUtils from '../util/CommonUtils'
import Command from '../viewmodel/Command'

let mIjkMediaPlayer: IjkMediaPlayer = IjkMediaPlayer.getInstance();

let mIoTVideoBridge = IoTVideoBridge.getInstance();
const videoViewModel = new VideoViewModel()

@Builder
export function VideoPreviewPageBuilder(name: string, param: Object) {
  VideoPreviewPage({ accessInfo: (param as AccessDevInfo).accessInfo, devInfo: (param as AccessDevInfo).devInfo })
}

@Entry
@Component
struct VideoPreviewPage {
  @State accessInfo: AccessInfo = new AccessInfo()
  @State devInfo: DevInfo = new DevInfo()
  @State productID: string = ""
  @State deviceName: string = ""
  @State xp2pInfo: string = ""
  pathStack: NavPathStack = new NavPathStack();
  @State mContext: object | undefined = undefined;
  xcomponentController: XComponentController = new XComponentController()
  @State isRefreshing: boolean = false
  @State isPageShow: boolean = false
  @State vInfo: string[] = ["", "", "", ""]
  @State videoQuality: string = "高清"
  @State showSwitchVideoQuality: boolean = false
  callback: VideoCallback<VideoProductP2PResponse> = {
    fail: (reqCode: number, msg?: string): void => {
      this.isRefreshing = false
      console.log(`getXp2pInfo error reqCode:${reqCode}  msg:${msg}`)
    },
    success: (reqCode: number, response?: VideoProductP2PResponse): void => {
      this.isRefreshing = false
      if (response?.Response?.P2PInfo) {
        this.xp2pInfo = response?.Response?.P2PInfo
        this.p2pInit(response?.Response?.P2PInfo)
      } else {
        console.log(`Data is null`)
      }
    }
  };

  aboutToAppear(): void {
    this.devInfo.Channel = 0
    videoViewModel.setSecretInfo(this.accessInfo.accessId, this.accessInfo.accessToken)
    videoViewModel.getXp2pInfo(this.accessInfo.productId, this.devInfo.DeviceName, this.callback)
  }

  onPageShow(): void {
  }

  onPageHide(): void {

  }

  aboutToDisappear(): void {
    mIjkMediaPlayer.stop()
    mIjkMediaPlayer.release()
    mIoTVideoBridge.stopService(this.devInfo.DeviceName)
  }

  p2pInit(p2pInfo: string) {
    let that = this;
    let mOnStateListener: OnStateListener = {
      onReady() {
        hilog.info(0x0000, 'testTag', 'mOnStateListener-->onReady');
        that.chgTextState(1080);
      },
      onDisconnect: (): void => {
        hilog.info(0x0000, 'testTag', 'mOnStateListener-->onDisconnect');
      }
    }

    mIoTVideoBridge.setMessageListener(mOnStateListener);
    mIoTVideoBridge.startAppWith(this.accessInfo.productId, this.devInfo.DeviceName, 0)
    mIoTVideoBridge.setXp2pInfo(this.devInfo.DeviceName, p2pInfo);
  }

  @Builder
  VideoQualityOptions() {
    List() {
      ListItem() {
        Text("超清")
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.chgTextState(1080)
            this.showSwitchVideoQuality = false
          })
      }.height(48).width('100%')

      ListItem() {
        Divider().height(1).backgroundColor(Color.Grey)
      }

      ListItem() {
        Text("高清")
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.chgTextState(720)
            this.showSwitchVideoQuality = false
          })
      }.height(48).width('100%')

      ListItem() {
        Divider().height(1).backgroundColor(Color.Grey)
      }

      ListItem() {
        Text("标清")
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.chgTextState(360)
            this.showSwitchVideoQuality = false
          })
      }.height(48).width('100%')

      ListItem() {
        Divider().height(1).backgroundColor(Color.Grey)
      }

      ListItem() {
        Text("取消")
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }.height(48).width('100%').onClick(() => {
        this.showSwitchVideoQuality = false
      })
    }.padding(32)
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        Stack({ alignContent: Alignment.Center }) {
          XComponent({
            id: 'xcomponentId',
            type: 'surface',
            libraryname: 'ijkplayer_napi'
          })
            .onLoad((context?: object) => {
              this.mContext = context
            })
            .onDestroy(() => {
            })
            .width('100%')
            .backgroundColor(Color.Black)
            .aspectRatio(16 / 9)
        }.id('ijkplayer')

        Row({ space: 10 }) {
          Text(this.videoQuality)
            .fontColor(Color.White)
            .padding(3)
            .backgroundColor(Color.Red)
            .border({
              color: Color.Red,
              width: 1,
              radius: 20
            })
            .onClick(() => {
              this.showSwitchVideoQuality = true
            })
            .bindSheet(this.showSwitchVideoQuality, this.VideoQualityOptions(), {
              height: SheetSize.MEDIUM,
              maskColor: Color.Transparent,
              onAppear: () => {
                console.log("BindSheet onAppear.")
              },
              onDisappear: () => {
                console.log("BindSheet onDisappear.")
              }
            })
          Image($r('app.media.audio'))
            .width(30)
            .padding(3)
            .backgroundColor(Color.Red)
            .border({
              color: Color.Red,
              width: 1,
              radius: 12
            })
          Image($r('app.media.orientation'))
            .width(30)
            .padding(3)
            .backgroundColor(Color.Red)
            .border({
              color: Color.Red,
              width: 1,
              radius: 12
            })
        }
        .id("ijkplayer_setting")
        .padding(10)
        .alignRules({
          right: { anchor: "ijkplayer", align: HorizontalAlign.End },
          bottom: { anchor: "ijkplayer", align: VerticalAlign.Bottom }
        })

        Column() {
          Text(`v_cache: ${this.vInfo[0]}`).fontColor(Color.Red).textAlign(TextAlign.Start)
          Text(`a_cache: ${this.vInfo[1]}`).fontColor(Color.Red).textAlign(TextAlign.Start)
          Text(`w/h: ${this.vInfo[2]}`).fontColor(Color.Red).textAlign(TextAlign.Start)
          Text(`speed: ${this.vInfo[3]}`).fontColor(Color.Red).textAlign(TextAlign.Start)
        }
        .width('auto')
        .backgroundColor($r('app.color.white_translucent_80FFFFFF'))
        .padding(4)
        .border({
          color: $r('app.color.white_translucent_80FFFFFF'),
          width: 1,
          radius: 2
        })
        .margin({
          right: 5
        })
        .alignRules({
          right: { anchor: "ijkplayer", align: HorizontalAlign.End },
          bottom: { anchor: "ijkplayer_setting", align: VerticalAlign.Top }
        })


        RelativeContainer() {
          Image($r('app.media.video_control_btn_background'))
            .width('auto')
            .height('auto')
            .objectFit(ImageFit.Fill)
            .alignRules({
              center: { anchor: "__container__", align: VerticalAlign.Center },
              middle: { anchor: "__container__", align: HorizontalAlign.Center },
            })
          CheckActionBox({
            isChecked: false,
            checkedRes: $r('app.media.talking'),
            unCheckedRes: $r('app.media.talk'),
            boxText: "对讲"
          }).id("radio_talk")
            .margin({
              top: 12,
              bottom: 12,
              left: 22,
              right: 12
            })
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              left: { anchor: "__container__", align: HorizontalAlign.Start },
            }).onClick(() => {
          })
          CheckActionBox({
            isChecked: false,
            checkedRes: $r('app.media.playback'),
            unCheckedRes: $r('app.media.playback'),
            boxText: "回放"
          }).id("radio_playback")
            .margin({
              top: 12,
              bottom: 12,
              left: 22,
              right: 12
            })
            .alignRules({
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              left: { anchor: "__container__", align: HorizontalAlign.Start },
            })
          CheckActionBox({
            isChecked: false,
            checkedRes: $r('app.media.recording'),
            unCheckedRes: $r('app.media.record'),
            boxText: "录像"
          }).id("radio_record")
            .margin({
              top: 12,
              bottom: 12,
              left: 12,
              right: 22
            })
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })

          CheckActionBox({
            isChecked: false,
            checkedRes: $r('app.media.photo'),
            unCheckedRes: $r('app.media.photo'),
            boxText: "拍照"
          }).id("radio_photo")
            .margin({
              top: 12,
              bottom: 12,
              left: 12,
              right: 22
            })
            .alignRules({
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })

          Image($r('app.media.ic_arrow_left_gray'))
            .width(40)
            .padding(15)
            .margin({
              right: 100
            })
            .alignRules({
              middle: { anchor: "__container__", align: HorizontalAlign.Center },
              center: { anchor: "__container__", align: VerticalAlign.Center }
            })

          Image($r('app.media.ic_arrow_left_gray'))
            .width(40)
            .padding(15)
            .rotate({ angle: -90 })
            .margin({
              bottom: 4
            })
            .alignRules({
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              middle: { anchor: "__container__", align: HorizontalAlign.Center }
            })

          Image($r('app.media.ic_arrow_rigth_gray'))
            .width(40)
            .padding(15)
            .margin({
              left: 100
            })
            .alignRules({
              middle: { anchor: "__container__", align: HorizontalAlign.Center },
              center: { anchor: "__container__", align: VerticalAlign.Center }
            })

          Image($r('app.media.ic_arrow_rigth_gray'))
            .width(40)
            .padding(15)
            .rotate({ angle: -90 })
            .margin({
              top: 4
            })
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              middle: { anchor: "__container__", align: HorizontalAlign.Center }
            })
        }
        .id("video_control_relative_container")
        .width('100%')
        .height(158)
        .margin({
          top: 16
        })
        .padding({
          left: 16,
          right: 16
        })
        .alignRules({
          top: { anchor: "ijkplayer", align: VerticalAlign.Bottom },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })

        Flex({ alignItems: ItemAlign.Start }) {
          Text("adfasda").fontSize(17)
        }
        .id("today_tip")
        .margin({
          top: 20,
          left: 16
        })
        .alignRules({
          top: { anchor: "video_control_relative_container", align: VerticalAlign.Bottom },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })

        List() {
          ListItem() {
            RelativeContainer() {
              Text("sdfs")
            }
          }.padding({
            top: 8,
            bottom: 8,
            left: 16,
            right: 16
          })
          .border({
            color: $r('app.color.white_translucent_80FFFFFF'),
            width: 1,
            radius: 8
          })
        }.margin({
          top: 4
        })
        .alignRules({
          top: { anchor: "today_tip", align: VerticalAlign.Bottom },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })
      }
      .backgroundColor($r('app.color.white_translucent_FFF6F6F6'))
      .height('100%')
      .width('100%')
    }.onReady((context) => {
      this.pathStack = context.pathStack
    })
    .title(this.devInfo.DeviceName)
  }

  private play(url: string) {
    let that = this;
    // 设置XComponent回调的context
    mIjkMediaPlayer.setContext(this.mContext, "xcomponentId");
    // 设置debug模式
    mIjkMediaPlayer.setDebug(true);
    // 初始化配置
    mIjkMediaPlayer.native_setup();
    // 设置视频源
    mIjkMediaPlayer.setDataSource(url.toString());
    // 设置视频源http请求头
    let headers = new Map([
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
        LogUtils.getInstance()
          .LOGI("setOnVideoSizeChangedListener-->go:" + width + "," + height + "," + sar_num + "," + sar_den)
      }
    }
    mIjkMediaPlayer.setOnVideoSizeChangedListener(mOnVideoSizeChangedListener);
    let mOnPreparedListener: OnPreparedListener = {
      onPrepared() {
        LogUtils.getInstance().LOGI("setOnPreparedListener-->go");
        that.startUpdateDashboard()
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

  private async startUpdateDashboard() {
    setTimeout(() => {
      this.updateDashboard()
    }, 500)
  }

  private async updateDashboard() {
    const videoCachedDuration = mIjkMediaPlayer.getVideoCachedDuration()
    const audioCachedDuration = mIjkMediaPlayer.getAudioCachedDuration()
    const videoCachedBytes = mIjkMediaPlayer.getVideoCachedBytes()
    const audioCachedBytes = mIjkMediaPlayer.getAudioCachedBytes()
    const tcpSpeed = mIjkMediaPlayer.getTcpSpeed()

    this.vInfo[0] =
      `${CommonUtils.formatedDurationMilli(videoCachedDuration)},${CommonUtils.formatedSize(videoCachedBytes)}`
    this.vInfo[1] =
      `${CommonUtils.formatedDurationMilli(audioCachedDuration)},${CommonUtils.formatedSize(audioCachedBytes)}`
    this.vInfo[2] =
      `${mIjkMediaPlayer.getVideoWidth()} x ${mIjkMediaPlayer.getVideoHeight()}`
    this.vInfo[3] = `${CommonUtils.formatedSpeed(tcpSpeed, 1000)}`
    this.startUpdateDashboard()
  }

  private onReadyed(suffix: string) {
    const videoUrl = mIoTVideoBridge.getUrlForHttpFlv(this.devInfo.DeviceName) + suffix;
    hilog.info(0x0000, 'testTag', 'pages/Index-->onReady-->%{public}s', videoUrl);
    this.play(videoUrl);
  }

  chgTextState(value: number) {
    switch (value) {
      case 1080: {
        this.videoQuality = "超清"
        this.onReadyed(Command.getVideoSuperQualityUrlSuffix(this.devInfo.Channel))
        return
      }
      case 720: {
        this.videoQuality = "高清"
        this.onReadyed(Command.getVideoSuperQualityUrlSuffix(this.devInfo.Channel))
        return
      }
      case 360: {
        this.videoQuality = "标清"
        this.onReadyed(Command.getVideoSuperQualityUrlSuffix(this.devInfo.Channel))
        return
      }
    }
    // chgAudioStatus(audioAble)
  }
}
