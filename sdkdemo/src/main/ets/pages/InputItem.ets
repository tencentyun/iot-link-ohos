@Entry
@Component
export struct InputItem {
  @State tv_tip: string | Resource = '';
  @State ev_content_hint: string | Resource = '';
  @State ev_content: string = '';
  @State isShowMore: boolean = false;
  @State isPassword: boolean = false;
  callback?: (value: string) => void

  build() {
    RelativeContainer() {
      Text(this.tv_tip)
        .id('tv_tip')
        .fontColor(Color.Black)
        .fontSize(17)
        .margin({
          top: 20,
          left: 16
        })

      Image($r('app.media.ic_arrow_left_gray'))
        .id('iv_more')
        .width(8)
        .visibility(this.isShowMore ? Visibility.Visible : Visibility.None)
        .rotate({
          angle: -90
        })
        .margin({
          top: 20
        })
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })

      TextInput({ placeholder: this.ev_content_hint, text: this.ev_content })
        .id('ev_content')
        .height('auto')
        .fontColor(Color.Black)
        .fontSize(17)
        .type(this.isPassword ? InputType.Password : InputType.Normal)// .backgroundColor(Color.Transparent)
        .maxLines(1)
        .backgroundColor(Color.Transparent)
        .margin({
          top: 10,
          left: 16
        })
        .alignRules({
          left: { anchor: "tv_tip", align: HorizontalAlign.End },
          right: { anchor: "iv_more", align: HorizontalAlign.Start }
        })
        .onChange(this.callback)

      Divider()
        .width('100%')
        .backgroundColor($r('app.color.black_1A000000'))
        .margin({
          top: 16,
          left: 16
        })
        .alignRules({
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        })

    }.height('auto').padding({
      left: 20,
      right: 20
    })
  }
}