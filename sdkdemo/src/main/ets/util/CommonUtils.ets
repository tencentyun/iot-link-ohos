export default class CommonUtils {
  //
  public static formatedDurationMilli(duration: number): string {
    if (duration >= 1000) {
      return `${(duration / 1000).toFixed(2)} sec`
    } else {
      return `${duration} msec`
    }
  }

  public static formatedSize(bytes: number): string {
    if (bytes >= 100 * 1000) {
      return `${(bytes / 1000 / 1000).toFixed(2)} MB`
    } else if (bytes >= 100) {
      return `${(bytes / 1000).toFixed(2)} KB`
    } else {
      return `${bytes} B`
    }
  }

  public static formatedSpeed(bytes: number, elapsed_milli: number): string {
    if (elapsed_milli <= 0) {
      return "0 B/s"
    }
    if (bytes <= 0) {
      return "0 B/s"
    }
    const bytes_per_sec = bytes * 1000 / elapsed_milli
    if (bytes_per_sec >= 1000 * 1000) {
      return `${(bytes_per_sec / 1000 / 1000).toFixed(2)} MB/s`
    } else if (bytes_per_sec >= 1000) {
      return `${(bytes_per_sec / 1000).toFixed(2)} KB/s`
    } else {
      return `${bytes_per_sec} B/s`
    }
  }
}