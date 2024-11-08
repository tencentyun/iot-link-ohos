import { buffer, util } from '@kit.ArkTS'
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { VideoCallback } from '../callback/VideoCallback'
import { VideoRequestCode } from '../consts/VideoRequestCode'
import { VideoHttpUtil } from '../repostory/VideoHttpUtil'
import { AegHmac } from '@hw-agconnect/petal-aegis'
import { BusinessError } from '@kit.BasicServicesKit'
import systemDateTime from '@ohos.systemDateTime';

const encoder = util.TextEncoder.create()

export class VideoViewModel {
  secretId: string = ""
  secretKey: string = ""

  setSecretInfo(secretId: string, secretKey: string) {
    this.secretId = secretId
    this.secretKey = secretKey
  }

  async getProductInfo<T>(productId: string, callback?: VideoCallback<T>) {
    this.videoCommonHeaderParams("DescribeProduct", "2021-11-25", (headerParams: Map<string, string>) => {
      const param = new Map<string, number | string>()
      param.set("ProductId", productId)
      param["ProductId"] = productId
      const authorization = this.sign(VideoHttpUtil.VIDEO_SERVICE, headerParams, param)
      headerParams.set("Authorization", authorization)
      headerParams["Authorization"] = authorization
      const url = VideoHttpUtil.PROTOCOL_HEADER + VideoHttpUtil.VIDEO_SERVICE + VideoHttpUtil.REST_HOST_URL
      VideoHttpUtil.getInstance().basePost(url, param, headerParams, VideoRequestCode.VIDEO_DESCRIBE_DEVICES, callback)
    })
  }

  /**
   * video获取设备信息列表   DescribeDevices
   */
  describeDevices<T>(productId: string, limit: number, offset: number, callback: VideoCallback<T>) {
    this.videoCommonHeaderParams("DescribeDevices", "2021-11-25", (headerParams: Map<string, string>) => {
      const param = new Map<string, number | string>()
      param.set("Limit", limit)
      param["Limit"] = limit
      param.set("Offset", offset)
      param["Offset"] = offset
      param.set("ProductId", productId)
      param["ProductId"] = productId
      const authorization = this.sign(VideoHttpUtil.VIDEO_SERVICE, headerParams, param)
      headerParams.set("Authorization", authorization)
      headerParams["Authorization"] = authorization
      const url = VideoHttpUtil.PROTOCOL_HEADER + VideoHttpUtil.VIDEO_SERVICE + VideoHttpUtil.REST_HOST_URL
      VideoHttpUtil.getInstance().basePost(url, param, headerParams, VideoRequestCode.VIDEO_DESCRIBE_DEVICES, callback)
    })
  }

  getXp2pInfo<T>(productId: string, deviceName: string, callback: VideoCallback<T>) {
    console.log(`入参：productId:${productId}   deviceName:${deviceName}`)
    this.xp2pCommonHeaderParams((headerParams: Map<string, string>) => {
      const param = new Map<string, string>()
      param.set("ProductId", productId)
      param["ProductId"] = productId
      param.set("DeviceName", deviceName)
      param["DeviceName"] = deviceName
      const authorization = this.sign(VideoHttpUtil.VIDEO_SERVICE, headerParams, param)
      headerParams.set("Authorization", authorization)
      headerParams["Authorization"] = authorization
      const url = VideoHttpUtil.PROTOCOL_HEADER + VideoHttpUtil.VIDEO_SERVICE + VideoHttpUtil.REST_HOST_URL
      VideoHttpUtil.getInstance().basePost(url, param, headerParams, VideoRequestCode.VIDEO_DESCRIBE_DEVICES, callback)
    })
  }

  xp2pCommonHeaderParams(callback: Callback<Map<string, string>>) {
    const param = new Map<string, string>()
    param.set("X-TC-Action", "DescribeP2PInfo")
    param["X-TC-Action"] = "DescribeP2PInfo"
    param.set("X-TC-Version", "2021-11-25")
    param["X-TC-Version"] = "2021-11-25"
    param.set("X-TC-Region", "ap-guangzhou")
    param["X-TC-Region"] = "ap-guangzhou"
    try {
      systemDateTime.getCurrentTime().then((time: number) => {
        param.set("X-TC-Timestamp", (Math.floor(time / 1000)).toString())
        param["X-TC-Timestamp"] = (Math.floor(time / 1000)).toString()
        callback(param)
        console.info(`Succeeded in getting currentTime : ${time}`);
      }).catch((error: BusinessError) => {
        console.info(`Failed to get currentTime. message:${error.message}, code:${error.code}`);
      });
    } catch (e) {
      console.info(`Failed to get currentTime. message:${e.message}, code:${e.code}`);
    }
  }

  videoCommonHeaderParams(action: string, version: string, callback: Callback<Map<string, string>>) {
    const param = new Map<string, string>()
    param.set("X-TC-Action", action)
    param["X-TC-Action"] = action
    param.set("X-TC-Version", version)
    param["X-TC-Version"] = version
    param.set("X-TC-Region", "ap-guangzhou")
    param["X-TC-Region"] = "ap-guangzhou"
    try {
      systemDateTime.getCurrentTime().then((time: number) => {
        param.set("X-TC-Timestamp", (Math.floor(time / 1000)).toString())
        param["X-TC-Timestamp"] = (Math.floor(time / 1000)).toString()
        callback(param)
        console.info(`Succeeded in getting currentTime : ${time}`);
      }).catch((error: BusinessError) => {
        console.info(`Failed to get currentTime. message:${error.message}, code:${error.code}`);
      });
    } catch (e) {
      console.info(`Failed to get currentTime. message:${e.message}, code:${e.code}`);
    }
  }

  public sign(
    service: string,
    headers: Map<String, String>,
    param: Map<String, number | string>,
  ): string {
    const algorithm = "TC3-HMAC-SHA256"
    const timestamp: string = headers["X-TC-Timestamp"]
    const date: Date = new Date(); // 将时间戳转换为毫秒
    // date.setMilliseconds(Number.parseInt(timestamp))
    const year: number = date.getFullYear(); // 获取年份
    const month: number = date.getMonth() + 1; // 获取月份（注意月份是从 0 开始计数的，所以需要加 1）
    const day: number = date.getDate(); // 获取日期
    let dateStr: string = `${year}`
    if (month > 9) {
      dateStr = dateStr + `-${month}`;
    } else {
      dateStr = dateStr + `-0${month}`;
    }
    if (day > 9) {
      dateStr = dateStr + `-${day}`;
    } else {
      dateStr = dateStr + `-0${day}`;
    }


    // ************* 步骤 1：拼接规范请求串 *************
    const httpRequestMethod = "POST"
    const canonicalUri = "/"
    const canonicalQueryString = ""
    const canonicalHeadersBuilder =
      `content-type:application/json; charset=utf-8\nhost:${service}${VideoHttpUtil.REST_HOST_URL}\n`
    const signedHeadersBuilder = "content-type;host"
    const canonicalHeaders = canonicalHeadersBuilder
    const signedHeaders = signedHeadersBuilder.toLowerCase()

    // 将Extra参数加到待签名字符串中，否则会签名失败
    const payload: string = JSON.stringify(param)
    let hashedRequestPayload: string = ''
    if (payload) {
      hashedRequestPayload = this.sha256Hex(payload)
    }
    const canonicalRequest =
      `${httpRequestMethod}\n${canonicalUri}\n${canonicalQueryString}\n${canonicalHeaders}\n${signedHeaders}\n${hashedRequestPayload}`
    console.log(`canonicalRequest====>${canonicalRequest}`)


    // ************* 步骤 2：拼接待签名字符串 *************
    const credentialScope = `${dateStr}/${service}/tc3_request`
    const hashedCanonicalRequest: string = this.sha256Hex(canonicalRequest)
    const stringToSign: string =
      `${algorithm}\n${timestamp}\n${credentialScope}\n${hashedCanonicalRequest}`.trimStart()
    console.log(`stringToSign===>${stringToSign}`)

    // ************* 步骤 3：计算签名 *************  SecretKey

    const secretDate: Uint8Array = this.hmac256(encoder.encodeInto("TC3" + this.secretKey), dateStr)
    const secretService: Uint8Array = this.hmac256(secretDate, service)
    const secretSigning: Uint8Array = this.hmac256(secretService, "tc3_request")
    const byteArray: Uint8Array = this.hmac256(secretSigning, stringToSign)
    const signature: string = this.encodeHexString(byteArray)

    // ************* 步骤 4：拼接 Authorization ************* SecretId
    let authorization =
      algorithm + " " + "Credential=" + this.secretId + "/" + credentialScope + ", " + "SignedHeaders=" +
        signedHeaders + ", " + "Signature=" + signature
    console.log(`authorization==>${authorization}`)
    return authorization
  }

  public async hmac2561(key: string, msg: string): Promise<Uint8Array> {
    let keyUint8 = new Uint8Array(buffer.from(key, 'utf-8').buffer);
    return await AegHmac.ohAegHmacSha256Text(msg, keyUint8)
  }

  public sha256Hex(s: string): string {
    let md: cryptoFramework.Md = cryptoFramework.createMd('SHA256');
    let byteArray = encoder.encodeInto(s)
    md.updateSync({ data: byteArray })
    let data = md.digestSync().data
    if (data) {
      return this.encodeHexString(data).toLowerCase()
    }
    return ''
  }

  public encodeHexString(byteArray: Uint8Array): string {
    let hexStringBuffer: String = new String()
    byteArray.forEach((item) => {
      let hex = this.byteToHex(item)
      if (hex) {
        hexStringBuffer += hex
      }
    })
    return hexStringBuffer.toString()
  }

  public byteToHex(num: number): string | null {
    const hexDigits: string[] = [];
    hexDigits[0] = (num >> 4 & 0xF).toString(16);
    hexDigits[1] = (num & 0xF).toString(16);
    return hexDigits.join('');
  }

  hmac256(key: Uint8Array, msg: string): Uint8Array {
    console.info("hmac256 enter params: " + `key.length:${key.length}  msg:${msg}`);
    let macAlgName = "SHA256";
    let mac = cryptoFramework.createMac(macAlgName)
    let KeyBlob: cryptoFramework.DataBlob = { data: key }
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator("HMAC");
    const symKey = symKeyGenerator.convertKeySync(KeyBlob);
    mac.initSync(symKey)
    let byteArray = encoder.encodeInto(msg)
    mac.updateSync({ data: byteArray });
    let macOutput = mac.doFinalSync();
    const res = this.encodeHexString(macOutput.data)
    console.log("Hmac:" + res);
    return macOutput.data
  }
}