import { MMKV } from '@tencent/mmkv';

let mmkv = MMKV.defaultMMKV();

export default class CacheUtil {
  public static putBoolean(key: string, value: boolean) {
    mmkv.encodeBool(key, value)
    console.info(`${key}`, mmkv.decodeBool(key));
  }

  public static putInt32(key: string, value: number) {
    mmkv.encodeInt32(key, value)
    console.info(`${key}`, mmkv.decodeInt32(key));
  }

  public static putInt64(key: string, value: bigint) {
    mmkv.encodeInt64(key, value)
    console.info(`${key}`, mmkv.decodeInt64(key));
  }

  public static putString(key: string, value: string) {
    mmkv.encodeString(key, value)
    console.info(`${key}`, mmkv.decodeString(key));
  }

  public static putBytes(key: string, value: ArrayBuffer) {
    mmkv.encodeBytes(key, value)
    console.info(`${key}`, mmkv.decodeBytes(key));
  }

  public static putObject<T>(key: string, value: T) {
    let objJson = JSON.stringify(value)
    let arrayBuffer: ArrayBuffer = CacheUtil.stringToArrayBuffer(objJson);
    CacheUtil.putBytes(key, arrayBuffer)
  }

  private static stringToArrayBuffer(text: string): ArrayBuffer {
    const buffer = new ArrayBuffer(text.length * 2);
    const view = new Uint16Array(buffer);
    for (let i = 0; i < text.length; i++) {
      view[i] = text.charCodeAt(i);
    }
    return buffer;
  }

  public static getBoolean(key: string, defaultValue?: boolean): boolean | undefined {
    return mmkv.decodeBool(key, defaultValue)
  }

  public static getInt32(key: string, defaultValue?: number): number | undefined {
    return mmkv.decodeInt32(key, defaultValue)
  }

  public static getInt64(key: string, defaultValue?: bigint): bigint | undefined {
    return mmkv.decodeInt64(key, defaultValue);
  }

  public static getString(key: string, defaultValue?: string): string | undefined {
    return mmkv.decodeString(key, defaultValue);
  }

  public static getBytes(key: string, defaultValue?: ArrayBuffer): ArrayBuffer | undefined {
    return mmkv.decodeBytes(key, defaultValue);
  }

  public static getObject<T>(key: string, defaultValue?: T): T | undefined {
    let arrayBuffer = CacheUtil.getBytes(key)
    if (arrayBuffer) {
      let objJSON = CacheUtil.arrayBufferToString(arrayBuffer);
      let obj: T = JSON.parse(objJSON)
      return obj
    }
    return defaultValue
  }

  private static arrayBufferToString(arrayBuffer: ArrayBuffer): string {
    const uintArray = new Uint8Array(arrayBuffer);
    let str = "";
    for (let i = 0; i < uintArray.length; i++) {
      str += String.fromCharCode(uintArray[i]);
    }
    return str;
  }
}