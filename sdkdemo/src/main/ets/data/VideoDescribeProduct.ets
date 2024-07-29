const DEV_TYPE_IPC = 1
const DEV_TYPE_NVR = 2

export class VideoProductResponse<T> {
  Response?: VideoProductContent<T>
}

export class VideoProductContent<T> {
  Data?: T
  RequestId: string = ""
  TotalCount?: number
  Devices?: DevInfo[]
}

export class VideoProductInfo {
  public static readonly DEV_TYPE_IPC = 1
  public static readonly DEV_TYPE_NVR = 2
  ProductId: string = ""
  ProductName: string = ""
  DeviceType: number = 1 //产品设备类型（普通设备) 1.普通设备
  EncryptionType: number = 0 //认证方式：2：PSK
  Features: string[] = [] //设备功能码
  ChipOs: string = "" //操作系统
  ChipManufactureId: string = "" //芯片厂商id
  ChipId: string = "" //芯片id
  ProductDescription: string = "" //产品描述信息
  CreateTime: number = 0 //创建时间unix时间戳
  UpdateTime: number = 0 //修改时间unix时间戳
}

export class DevInfo {
  DeviceName: string = ""
  Status: number = 0
  DevicePsk: string = ""
  LoginTime: number = 0
  ExpireTime: number = 0
  LogLevel: number = 0
  Online: number = 0
  EnableState: number = 0
  Channel: number = 0
  mjpeg: number = 0

  set(status: number) {
    this.Status = status
  }
}

export class VideoProductP2PResponse {
  Response?: P2PInfoContent
}

export class P2PInfoContent {
  P2PInfo: string = ""
  RequestId: string = ""
  ReportTime?: number
}