import { VideoCallback } from '../callback/VideoCallback';
import { VideoRequestCode } from '../consts/VideoRequestCode';
import { AccessInfo } from '../data/AccessInfo';
import { DevInfo, VideoProductInfo, VideoProductResponse } from '../data/VideoDescribeProduct';
import { VideoViewModel } from '../viewmodel/VideoViewModel';

const videoViewModel = new VideoViewModel()

export class AccessDevInfo {
  accessInfo: AccessInfo
  devInfo: DevInfo

  constructor(accessInfo: AccessInfo, devInfo: DevInfo) {
    this.accessInfo = accessInfo
    this.devInfo = devInfo
  }
}

@Builder
export function VideoMainPageBuilder(name: string, param: Object) {
  VideoMainPage({ accessInfo: param as AccessInfo })
}

@Entry
@Component
struct VideoMainPage {
  @State accessInfo: AccessInfo = new AccessInfo()
  @State title: string = 'IoT Video Demo';
  pathStack: NavPathStack = new NavPathStack()
  @State isRefreshing: boolean = false
  @State tipText: string = ""
  @State actionText: string = "编辑"
  @State videoProductInfo: VideoProductInfo = new VideoProductInfo()
  @State devs: DevInfo[] = []
  @State showIndexOption: number = -1
  optionsList: Resource[] = [$r('app.string.preview')]
  callback: VideoCallback<VideoProductResponse<VideoProductInfo>> = {
    fail: (reqCode: number, msg?: string): void => {
      this.isRefreshing = false
      console.log(`getProductInfo error reqCode:${reqCode}  msg:${msg}`)
    },
    success: (reqCode: number, response?: VideoProductResponse<VideoProductInfo>): void => {
      this.isRefreshing = false
      if (response) {
        switch (reqCode) {
          case VideoRequestCode.VIDEO_DESCRIBE_DEVICES: {
            if (response.Response?.Devices && response.Response?.Devices.length > 0) {
              this.devs = response.Response?.Devices
            }
          }
          case VideoRequestCode.VIDEO_DESCRIBE_PRODUCT: {
            if (response.Response?.Data) {
              this.videoProductInfo = response.Response?.Data
              this.requestDevs()
            }
          }
        }
      } else {
        console.log(`response is null`)
      }
    }
  };

  aboutToAppear(): void {
    console.log(`accessInfo  accessId:${this.accessInfo.accessId}  accessToken:${this.accessInfo.accessToken}  productId:${this.accessInfo.productId}`)
    videoViewModel.setSecretInfo(this.accessInfo.accessId, this.accessInfo.accessToken)
    videoViewModel.getProductInfo(this.accessInfo.productId, this.callback)
  }

  @Builder
  DevsItem(item: DevInfo, index: number) {
    RelativeContainer() {
      Image(this.videoProductInfo.DeviceType == VideoProductInfo.DEV_TYPE_IPC ? $r('app.media.ipc') :
      $r('app.media.nvr'))
        .id('iv_dev')
        .width(48)
        .alignRules({
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })

      Image($r('app.media.iv_more'))
        .id('iv_more')
        .width(30)
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })

      Image($r('app.media.unchecked'))
        .id('iv_select')
        .visibility(Visibility.Hidden)
        .width(24)
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End },
          top: { anchor: "iv_more", align: VerticalAlign.Bottom },
        })
        .margin({
          top: 30
        })

      Text(item.DeviceName)
        .id('tv_dev_name')
        .fontSize(14)
        .fontColor(item.Online == 1 ? $r('app.color.black_15161A') : $r('app.color.gray_C2C5CC'))
        .alignRules({
          top: { anchor: "iv_dev", align: VerticalAlign.Bottom }
        })
        .margin({
          top: 16
        })

      Text(item.Online == 1 ? $r('app.string.online') : $r('app.string.offline'))
        .id('tv_dev_status')
        .fontSize(12)
        .fontColor(item.Online == 1 ? $r('app.color.green_29CC85') : $r('app.color.gray_C2C5CC'))
        .alignRules({
          top: { anchor: "tv_dev_name", align: VerticalAlign.Bottom }
        })
    }
    .height('auto')
    .padding(16)
    .backgroundColor(item.Online == 1 ? Color.White : $r('app.color.white_translucent_FFF6F6F6'))
    .border({
      width: 1,
      radius: 8,
      color: $r('app.color.white_translucent_AAFFFFFF')
    })
    .onClick(() => {
      this.showIndexOption = index
    })
    .bindSheet(this.showIndexOption == index, this.ListOptions(), {
      height: SheetSize.MEDIUM,
      maskColor: Color.Transparent,
      onAppear: () => {
        console.log("BindSheet onAppear.")
      },
      onDisappear: () => {
        this.showIndexOption = -1
        console.log("BindSheet onDisappear.")
      }
    })
  }

  @Builder
  ListOptions() {
    List() {
      ForEach(this.optionsList, (option: Resource, index) => {
        ListItem() {
          Text(option)
            .width('100%')
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              if (index == 0) {
                this.pathStack.pushPathByName("VideoPreviewPage",
                  new AccessDevInfo(this.accessInfo, this.devs[this.showIndexOption]))
              }
              this.showIndexOption = -1
            })
        }.height(48).width('100%')
      })
      ListItem() {
        Divider().height(2).backgroundColor(Color.Grey)
      }

      ListItem() {
        Text("取消")
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }.height(48).width('100%').onClick(() => {
        this.showIndexOption = -1
      })
    }.padding(32)
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        Text($r('app.string.my_devs'))
          .id('tv_my_devs')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .margin({
            left: 16,
            top: 16,
          })

        Row() {
          Image($r('app.media.edit_devs')).width(24)
          Text(this.actionText).fontSize(17).padding({
            left: 8,
            right: 16
          })
        }
        .visibility(this.videoProductInfo.DeviceType == VideoProductInfo.DEV_TYPE_IPC ? Visibility.Visible :
        Visibility.Hidden)
        .id('edit_dev')
        .alignRules({
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .margin({
          left: 16,
          top: 16
        })
        .onClick(() => {

        })

        Text(this.tipText)
          .id('tv_tip_txt')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            right: { anchor: 'edit_dev', align: HorizontalAlign.Start }
          })
          .margin({
            left: 16,
            top: 20
          })

        Refresh({ refreshing: $$this.isRefreshing }) {
          Grid() {
            ForEach(this.devs, (item: DevInfo, index) => {
              GridItem() {
                this.DevsItem(item, index)
              }
            })
          }
          .columnsGap(10)
          .rowsGap(10)
          .padding({
            left: 10,
            right: 10,
            top: 10,
            bottom: 4
          })
          .margin({
            top: 10
          })
          .height('90%')
          .columnsTemplate('1fr 1fr')
          .layoutDirection(GridDirection.Column)
        }
        .width('100%')
        .height('100%')
        .alignRules({
          top: { anchor: 'tv_my_devs', align: VerticalAlign.Bottom }
        })
        .onStateChange((refreshStatus: RefreshStatus) => {
          console.info('Refresh onStatueChange state is ' + refreshStatus)
        })
        .onOffsetChange((value: number) => {
          console.info('Refresh onOffsetChange offset:' + value)
        })
        .onRefreshing(() => {
          setTimeout(() => {
            videoViewModel.getProductInfo(this.accessInfo.productId, this.callback)
          }, 1000)
          console.log('onRefreshing')
        })
        .refreshOffset(64)
        .pullToRefresh(true)
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .title(this.title, {
      backgroundColor: $r('app.color.blue_0052D9'),
    })
  }

  requestDevs() {
    if (this.videoProductInfo) {
      this.devs.reverse()
      videoViewModel.describeDevices(this.accessInfo.productId, 99, 0, this.callback)
    }
  }
}