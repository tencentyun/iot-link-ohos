import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'liblibiotvideo.so';

@Component
export struct MainPage {
  @State message: string = 'LibIoTVideo';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {

            testNapi.getCommandRequestWithAsync("dev_name", "cmd", ((result: string) => {
              hilog.info(0x0000, 'testTag', 'getCommandRequestWithAsync = %{public}s', result);
            })
            );

          })
      }
      .width('100%')
    }
    .height('30%')
  }
}