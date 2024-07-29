import http from '@ohos.net.http'
import ArrayList from '@ohos.util.ArrayList'
import { Chain } from './Chain'
import { NetConfig } from './NetConfig'

export abstract class RequestBody {
  protected header = new Map<string, string>()
  protected param = new Map<string, number | string>()
  protected method: http.RequestMethod = http.RequestMethod.GET
  protected url: string
  interectorsIndex: number = -1
  protected cancelFlag = false
  private tag: string = ''
  private expressed = false // true：接口调试时直接执行，不会因为执行队列满了而进入等待队列，也不会因为与正在执行的相同接口而被抛弃；false：相反

  constructor(url: string, method: http.RequestMethod) {
    this.url = url
    this.method = method
  }

  setHeader(key: string, value: string): RequestBody {
    this.header.set(key,value)
    this.header[key] = value
    return this
  }

  setHeaderMap(headerParams: Map<string, string>): RequestBody {
    headerParams.forEach((value, key) => {
      this.header.set(key,value)
      this.header[key] = value
    })
    return this
  }

  getHeader(): Map<String, Object> {
    return this.header
  }

  setMethod(method: http.RequestMethod) {
    this.method = method
  }

  getMethod(): http.RequestMethod {
    return this.method
  }

  setParam(key: string, value: number | string): RequestBody {
    this.param[key] = `${value}`
    return this
  }

  setParamMap(params: Map<string, number | string>): RequestBody {
    params.forEach((value, key) => {
      this.param.set(key, value)
      this.param[key] = value
    })
    return this
  }

  cancel() {
    console.info('isCanceled')
    this.cancelFlag = true
  }

  isCancel(): boolean {
    return this.cancelFlag
  }

  setExpressed(isExpressed: boolean) {
    this.expressed = isExpressed
  }

  isExpressed(): boolean {
    return this.expressed
  }

  getParam(): Map<String, number | string> {
    return this.param
  }

  setUrl(url: string) {
    this.url = url
  }

  setTag(tag: string) {
    return this.tag = tag
  }

  getTag(): string {
    return this.tag
  }

  getUrl(): string {
    let url = ''
    if (this.url.startsWith("http")) {
      url = this.url
    } else {
      url = NetConfig.getInstance().getHost() + this.url
    }
    return url
  }

  execute(chain: Chain): Promise<http.HttpResponse> {
    this.interectorsIndex++
    const interceptor = NetConfig.getInstance().getInterceptor(this.interectorsIndex)
    if (!interceptor) {
      return this.call()
    } else {
      return interceptor.intercept(chain)
    }
  }

  getUrlWithParam(): string {
    let key = this.getUrl()
    let p = ''
    let arr: ArrayList<string> = new ArrayList()
    Object.keys(this.getParam()).forEach((key) => {
      arr.add(key)
    })
    this.sort(arr).forEach((key) => {
      if (p.length > 0) {
        p += "&"
      }
      p += `${key}=${this.getParam()[key]}`
    })
    if (p.length > 0) {
      key += `?${p}`
    }
    return key
  }

  private sort(arr: ArrayList<string>): ArrayList<string> {
    if (arr.length <= 1) {
      return arr
    }
    const result = new ArrayList<string>()
    arr.forEach((it) => {
      if (result.length === 0) {
        result.add(it)
      } else {
        for (let i = 0; i < result.length; i++) {
          if (it.localeCompare(result[i]) < 0) {
            result.insert(it, i)
            break
          } else if (i === result.length - 1) {
            result.add(it)
            break
          }
        }
      }
    })
    return result
  }

  protected abstract call(): Promise<http.HttpResponse>
}