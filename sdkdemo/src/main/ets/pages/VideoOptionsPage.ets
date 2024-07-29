@Builder
export function VideoOptionsPageBuilder(name: string, param: Object) {
  VideoOptionsPage()
}

@Entry
@Component
struct VideoOptionsPage {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      RelativeContainer() {
        Image($r('app.media.iot_video_logo'))
          .id('iv_logo')
          .width(128)
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({
            top: 128
          })

        Text($r('app.string.demo_name'))
          .id('tv_logo')
          .width('auto')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            top: { anchor: 'iv_logo', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin(12)

        Text($r('app.string.welcome'))
          .id('tv_desc')
          .width('auto')
          .fontSize(20)
          .fontWeight(FontWeight.Normal)
          .alignRules({
            top: { anchor: 'tv_logo', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin(12)

        Button($r('app.string.video'), { type: ButtonType.Normal, stateEffect: true })
          .id('btn_video')
          .width('85%')
          .height(45)
          .fontSize(20)
          .fontColor($r('app.color.blue_0052D9'))
          .fontWeight(FontWeight.Normal)
          .backgroundColor(Color.Transparent)
          .margin(30)
          .border({
            color: $r('app.color.blue_0052D9'),
            width: 1,
            radius: 2
          })
          .alignRules({
            top: { anchor: 'tv_desc', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.pathStack.pushDestinationByName('VideoInputAuthorizePage', "IoT Video Demo")
          })

        Button($r('app.string.video_pro'), { type: ButtonType.Normal, stateEffect: true })
          .id('btn_video_pro')
          .width('85%')
          .height(45)
          .fontSize(20)
          .fontColor($r('app.color.blue_0052D9'))
          .fontWeight(FontWeight.Normal)
          .backgroundColor(Color.Transparent)
          .margin(12)
          .border({
            color: $r('app.color.blue_0052D9'),
            width: 1,
            radius: 2
          })
          .alignRules({
            top: { anchor: 'btn_video', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })

        Button($r('app.string.video_wlan'), { type: ButtonType.Normal, stateEffect: true })
          .id('btn_video_wlan')
          .width('85%')
          .height(45)
          .fontSize(20)
          .fontColor($r('app.color.blue_0052D9'))
          .fontWeight(FontWeight.Normal)
          .backgroundColor(Color.Transparent)
          .margin(12)
          .border({
            color: $r('app.color.blue_0052D9'),
            width: 1,
            radius: 2
          })
          .alignRules({
            top: { anchor: 'btn_video_pro', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }
}