import { http } from '@kit.NetworkKit'
import { DefaultRequestBody } from './DefaultRequestBody'
import { NetConfig } from './NetConfig'
import { RequestBody } from './RequestBody'
import { BusinessError } from '@kit.BasicServicesKit'

export function Post<T>(url: string, handler?: (requestBody: RequestBody) => void): Promise<T> {
  return defaultRequest<T>(url, http.RequestMethod.POST, handler)
}

export function Get<T>(url: string, handler?: (requestBody: RequestBody) => void): Promise<T> {
  return defaultRequest<T>(url, http.RequestMethod.GET, handler)
}

export function Cancel(tag: string) {
  NetConfig.getInstance().getTaskDispatch().cancel(tag)
}

function defaultRequest<T>(url: string, method: http.RequestMethod,
  handler?: ((requestBody: RequestBody) => void)): Promise<T> {
  let requestBody = new DefaultRequestBody(url, method)
  handler && handler(requestBody)
  return request(requestBody)
}

function request<T>(requestBody: RequestBody): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    requestBody.interectorsIndex = -1
    NetConfig.getInstance()
      .getTaskDispatch()
      .dispatch(requestBody)
      .then((response) => {
        try {
          let bean: T = NetConfig.getInstance().getConverter().onConvert(response)
          resolve(bean)
        } catch (error) {
          reject(error)
        }
      })
      .catch((error: BusinessError) => {
        reject(error)
      })
  })
}