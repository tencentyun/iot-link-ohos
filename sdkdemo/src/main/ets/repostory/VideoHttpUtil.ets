import { VideoCallback } from '../callback/VideoCallback'
import { NetConfig } from '../net/NetConfig'
import { Get, Post } from '../net/NetworkUtil'

export class VideoHttpUtil {
  public static readonly PROTOCOL_HEADER = "https://"
  public static readonly EXPLORER_SERVICE = "iotexplorer" // explorer
  public static readonly VIDEO_SERVICE = "iotvideo" // video
  public static readonly REST_HOST_URL = ".tencentcloudapi.com"
  private static instance: VideoHttpUtil;

  private constructor() {
  }

  public static getInstance(): VideoHttpUtil {
    if (VideoHttpUtil.instance) {
      return VideoHttpUtil.instance
    }
    VideoHttpUtil.instance = new VideoHttpUtil()
    return VideoHttpUtil.instance
  }

  public baseGet<T>(url: string, param: Map<string, number | string>, headerParams: Map<string, string>, reqCode: number,
    callback?: VideoCallback<T>) {
    NetConfig.getInstance().config(url, (net) => {
      net.setConnectTimeout(8000)
      net.setReadTimeout(8000)
    })

    Get<T>(url, (requestBody) => {
      requestBody.setHeaderMap(headerParams)
      requestBody.setParamMap(param)
    }).then((result) => {
      console.log(`请求结果------------->${JSON.stringify(result)}`)
      callback?.success(reqCode, result)
    })
  }

  public basePost<T>(url: string, param: Map<string, number | string>, headerParams: Map<string, string>,
    reqCode: number,
    callback?: VideoCallback<T>) {
    NetConfig.getInstance().config(url, (net) => {
      net.setConnectTimeout(8000)
      net.setReadTimeout(8000)
    })

    Post<T>(url, (requestBody) => {
      requestBody.setHeaderMap(headerParams)
      requestBody.setParamMap(param)
    }).then((result) => {
      console.log(`请求结果------------->${JSON.stringify(result)}`)
      callback?.success(reqCode, result)
    })
  }
}