import { VideoCallback } from '../callback/VideoCallback';
import { VideoViewModel } from '../viewmodel/VideoViewModel';
import { VideoRequestCode } from '../consts/VideoRequestCode';

@Builder
export function ModulePageBuilder(name: string, param: Object) {
  ModulePage()
}

const viewModel = new VideoViewModel()

@Entry
@Component
struct ModulePage {
  @State productId: string = "***REMOVED***"
  @State secretId: string = "***REMOVED***"
  @State secretKey: string = "***REMOVED***"
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()
  @State core: string = 'CORE';
  @State video: string = 'VIDEO';
  @State rtc: string = 'RTC';

  aboutToAppear(): void {
    viewModel.setSecretInfo(this.secretId, this.secretKey)
  }

  build() {
    Navigation(this.pathStack) {
      RelativeContainer() {

        Button(this.core, { type: ButtonType.Normal, stateEffect: true })
          .id('core')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .borderRadius(8)
          .padding({
            top: 8,
            bottom: 8,
            left: 30,
            right: 30
          })
          .margin({
            top: 150
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.pathStack.pushPathByName('LoginPage', null)
          })

        Button(this.video, { type: ButtonType.Normal, stateEffect: true })
          .id('video')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .borderRadius(8)
          .padding({
            top: 8,
            bottom: 8,
            left: 30,
            right: 30
          })
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.pathStack.pushPathByName('VideoOptionsPage', null)
          })

        Button(this.rtc, { type: ButtonType.Normal, stateEffect: true })
          .id('rtc')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .borderRadius(8)
          .padding({
            top: 8,
            bottom: 8,
            left: 30,
            right: 30
          })
          .margin({
            bottom: 150
          })
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // 创建回调对象
            // let callback: VideoCallback<VideoDescribeProduct> = {
            //   fail: (reqCode: number, msg?: string): void => {
            //     console.log(`getProductInfo error reqCode:${reqCode}  msg:${msg}`)
            //   },
            //   success: (reqCode: number, response?: VideoDescribeProduct): void => {
            //     if (response) {
            //       switch (reqCode) {
            //         case VideoRequestCode.VIDEO_DESCRIBE_DEVICES: {
            //
            //         }
            //         case VideoRequestCode.VIDEO_DESCRIBE_PRODUCT: {
            //           if (response.Response?.Data) {
            //             this.videoProductInfo = response.Response?.Data
            //             this.requestDevs()
            //           }
            //         }
            //       }
            //     } else {
            //       console.log(`response is null`)
            //     }
            //   }
            // };
            // viewModel.getProductInfo(this.productId, callback)
            let callback: VideoCallback<string> = {
              fail: (reqCode: number, msg?: string): void => {
                console.log(`getProductInfo error reqCode:${reqCode}  msg:${msg}`)
              },
              success: (reqCode: number, response?: string): void => {
                if (response) {
                  switch (reqCode) {
                    case VideoRequestCode.VIDEO_DESCRIBE_DEVICES: {

                    }
                    case VideoRequestCode.VIDEO_DESCRIBE_PRODUCT: {
                      // if (response.Response?.Data) {
                      //   this.videoProductInfo = response.Response?.Data
                      //   this.requestDevs()
                      // }
                    }
                  }
                } else {
                  console.log(`response is null`)
                }
              }
            };
            viewModel.getXp2pInfo(this.productId, "sp01_32820237_4", callback)
          })
      }
      .height('100%')
      .width('100%')
    }
  }
}