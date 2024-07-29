import http from '@ohos.net.http';
import { NetConfig } from './NetConfig';
import { RequestBody } from './RequestBody';
import { BusinessError } from '@kit.BasicServicesKit';

export class DefaultRequestBody extends RequestBody {
  protected call(): Promise<http.HttpResponse> {
    return new Promise<http.HttpResponse>((resolve, reject) => {
      if (this.getMethod() === http.RequestMethod.GET) {
        let url = this.getUrl()
        let p = ''
        Object.keys(this.getParam()).forEach((key) => {
          if (p.length > 0) {
            p += "&"
          }
          p += `${key}=${this.getParam()[key]}`
        })
        if (p.length > 0) {
          url += `?${p}`
        }
        http.createHttp().request(url, {
          method: this.getMethod(),
          header: this.getHeader(),
          connectTimeout: NetConfig.getInstance().getConnectTimeout(),
          readTimeout: NetConfig.getInstance().getReadTimeout(),
        }).then((httpResponse) => {
          if (this.isCancel()) {
            console.info('canceled', this.getUrlWithParam())
            NetConfig.getInstance().getTaskDispatch().done(this)
            return
          }
          let response: http.HttpResponse = httpResponse
          if (this.getMethod() === http.RequestMethod.GET || this.getMethod() === http.RequestMethod.POST) {
            response = httpResponse
          } else if (httpResponse.responseCode >= 200 && httpResponse.responseCode <= 299) {
            httpResponse.resultType = http.HttpDataType.OBJECT
            response = httpResponse
          } else {
            response = httpResponse
          }
          resolve(response)
        }).catch((err: BusinessError) => {
          reject(err)
        })
      } else {
        let url = this.getUrl()
        if (!this.getHeader().has('Content-Type')) {
          this.setHeader('Content-Type', 'application/json; charset=utf-8')
        }
        http.createHttp().request(url, {
          method: this.getMethod(),
          header: this.getHeader(),
          extraData: this.getParam(),
          connectTimeout: NetConfig.getInstance().getConnectTimeout(),
          readTimeout: NetConfig.getInstance().getReadTimeout(),
        }).then((httpResponse) => {
          if (this.isCancel()) {
            console.info('canceled', this.getUrlWithParam())
            NetConfig.getInstance().getTaskDispatch().done(this)
            return
          }
          let response: http.HttpResponse = httpResponse
          if (this.getMethod() === http.RequestMethod.GET || this.getMethod() === http.RequestMethod.POST) {
            response = httpResponse
          } else if (httpResponse.responseCode >= 200 && httpResponse.responseCode <= 299) {
            httpResponse.resultType = http.HttpDataType.OBJECT
            response = httpResponse
          } else {
            response = httpResponse
          }
          resolve(response)
        }).catch((err: BusinessError) => {
          reject(err)
        })
      }
    })
  }
}