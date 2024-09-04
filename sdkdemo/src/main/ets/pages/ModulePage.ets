
@Builder
export function ModulePageBuilder(name: string, param: Object) {
  ModulePage()
}

@Entry
@Component
struct ModulePage {
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()
  @State core: string = 'CORE';
  @State video: string = 'VIDEO';
  @State rtc: string = 'RTC';

  aboutToAppear(): void {
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
          })
      }
      .height('100%')
      .width('100%')
    }
  }
}