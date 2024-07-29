@Entry
@Component
export struct CheckActionBox {
  @State isChecked: boolean = false;
  @State checkedRes?: Resource = undefined;
  @State unCheckedRes?: Resource = undefined;
  @State boxText: string = "";

  build() {
    Column({ space: 2 }) {
      Image(this.unCheckedRes)
        .id('iv_more')
        .width(24)

      Text(this.boxText)
        .id('tv_tip')
        .fontColor(Color.Black)
        .fontSize(17)
    }.height('auto')
  }
}