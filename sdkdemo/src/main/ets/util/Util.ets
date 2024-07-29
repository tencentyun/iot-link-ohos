import { promptAction } from '@kit.ArkUI';

export default class Util {
  static showToast(error: string | Resource) {
    // 如果发生错误，显示提示消息
    promptAction.showToast({
      message: error,
      duration: 200
    });
  }
}
