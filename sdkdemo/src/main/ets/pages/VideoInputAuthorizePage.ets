import { AccessInfo } from '../data/AccessInfo';
import CacheUtil from '../util/CacheUtil';
import Util from '../util/Util';
import { InputItem } from './InputItem';

@Builder
export function VideoInputAuthorizePageBuilder(name: string, param: Object) {
  VideoInputAuthorizePage({ title: param as string })
}

@Entry
@Component
struct VideoInputAuthorizePage {
  @State title: string = "IoT Video Demo"
  pathStack: NavPathStack = new NavPathStack();
  PTopBottom: Record<string, number> = { 'top': 40, 'bottom': 10 }
  @State accessIdValue: string = ""
  @State accessTokenValue: string = ""
  @State productIdValue: string = ""

  aboutToAppear(): void {
    let accessIdValue = CacheUtil.getString("accessIdValue")
    if (accessIdValue) {
      this.accessIdValue = accessIdValue
    }
    let accessTokenValue = CacheUtil.getString("accessTokenValue")
    if (accessTokenValue) {
      this.accessTokenValue = accessTokenValue
    }
    let productIdValue = CacheUtil.getString("productIdValue")
    if (productIdValue) {
      this.productIdValue = productIdValue
    }
  }

  build() {
    NavDestination() {
      Column() {
        Divider().width('100%').backgroundColor($r('app.color.black_1A000000'))
        Flex() {
          InputItem({
            tv_tip: $r('app.string.access_id'),
            ev_content_hint: $r('app.string.hint_access_id'),
            ev_content:this.accessIdValue,
            isShowMore: true,
            callback: this.accessIdCallback
          })
            .backgroundColor(Color.Transparent)
            .height(56)
        }

        Flex() {
          InputItem({
            tv_tip: $r('app.string.access_token'),
            ev_content_hint: $r('app.string.hint_access_token'),
            ev_content:this.accessTokenValue,
            isShowMore: false,
            isPassword: true,
            callback: this.accessTokenCallback
          }).backgroundColor(Color.Transparent)
            .height(56)
        }

        Flex() {
          InputItem({
            tv_tip: $r('app.string.product_id'),
            ev_content_hint: $r('app.string.hint_product_id'),
            ev_content:this.productIdValue,
            isShowMore: false,
            isPassword: true,
            callback: this.productIdCallback
          }).backgroundColor(Color.Transparent)
            .height(56)
        }

        Flex({ justifyContent: FlexAlign.Center }) {
          Button($r('app.string.login'), { type: ButtonType.Normal, stateEffect: true })
            .id('btn_video_pro')
            .width('85%')
            .height(45)
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Normal)
            .backgroundColor($r('app.color.blue_0052D9'))
            .border({
              color: $r('app.color.blue_0052D9'),
              width: 1,
              radius: 2
            })
            .alignRules({
              top: { anchor: 'btn_video', align: VerticalAlign.Bottom },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .onClick(() => {
              if (this.accessIdValue.length == 0) {
                Util.showToast($r('app.string.hint_access_id'))
                return
              }
              CacheUtil.putString("accessIdValue", this.accessIdValue)
              if (this.accessTokenValue.length == 0) {
                Util.showToast($r('app.string.hint_access_token'))
                return
              }
              CacheUtil.putString("accessTokenValue", this.accessTokenValue)
              if (this.productIdValue.length == 0) {
                Util.showToast($r('app.string.hint_product_id'))
                return
              }
              CacheUtil.putString("productIdValue", this.productIdValue)
              let accessInfo = new AccessInfo()
              accessInfo.accessId = this.accessIdValue
              accessInfo.accessToken = this.accessTokenValue
              accessInfo.productId = this.productIdValue
              this.pathStack.pushPathByName('VideoMainPage', accessInfo)
            })
        }.padding(this.PTopBottom)
      }
    }
    .title(this.title)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

  private accessIdCallback = (value: string) => {
    this.accessIdValue = value
  }
  private accessTokenCallback = (value: string) => {
    this.accessTokenValue = value
  }
  private productIdCallback = (value: string) => {
    this.productIdValue = value
  }
}

