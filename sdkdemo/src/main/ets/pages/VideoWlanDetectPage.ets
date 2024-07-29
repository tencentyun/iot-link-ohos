@Builder
export function VideoWlanDetectPageBuilder(name: string, param: Object) {
  VideoWlanDetectPage()
}

@Entry
@Component
struct VideoWlanDetectPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('VideoWlanDetectPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}