import { JsonCoverter } from './converter/JsonCoverter'
import { NetConverter } from './converter/NetConverter'
import { Interector } from './Interector'
import { DefaultTaskDispatch } from './task/DefaultTaskDispatch'
import { TaskDispatch } from './task/TaskDispatch'

export class NetConfig {
  host?: string = ''
  private connectTimeout: number = 30_000
  private readTimeout: number = 30_000
  private interectorList: Array<Interector> = []
  private static INSTANCE: NetConfig
  private converter: NetConverter = new JsonCoverter()
  private taskDispatch: TaskDispatch = new DefaultTaskDispatch()

  private constructor() {
  }

  static getInstance(): NetConfig {
    if (NetConfig.INSTANCE == null) {
      NetConfig.INSTANCE = new NetConfig()
    }
    return NetConfig.INSTANCE
  }

  getHost(): string | void {
    return this.host
  }

  config(host?: string, config?: (net: NetConfig) => void) {
    this.host = host
    if (config) {
      config(this)
    }
  }

  addInterceptor(interector: Interector) {
    this.interectorList.push(interector)
  }

  getInterceptor(index: number): Interector | void {
    if (index >= 0 && index < this.interectorList.length) {
      return this.interectorList[index]
    } else {
      null
    }
  }

  setConnectTimeout(connectTimeout: number) {
    this.connectTimeout = connectTimeout
  }

  getConnectTimeout(): number {
    return this.connectTimeout
  }

  setReadTimeout(readTimeout: number) {
    this.readTimeout = readTimeout
  }

  getReadTimeout(): number {
    return this.readTimeout
  }

  setConverter(converter: NetConverter) {
    if (converter) {
      this.converter = converter
    }
  }

  getConverter(): NetConverter {
    return this.converter
  }

  setTaskDispatch(taskDispatch: TaskDispatch) {
    if(taskDispatch){
      this.taskDispatch = taskDispatch
    }
  }

  getTaskDispatch(): TaskDispatch {
    return this.taskDispatch
  }
}