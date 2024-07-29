export default class Command {
  public static readonly QUERY_NVR_DEVS = `action=inner_define&cmd=get_nvr_list`

  // 查询 NVR 设备列表

  public static getPtzUpCommand(channel: number): string {
    return `action=user_define&channel=${channel}&cmd=ptz_up`
  }

  public static getPtzDownCommand(channel: number): string {
    return `action=user_define&channel=${channel}&cmd=ptz_down`
  }

  public static getPtzRightCommand(channel: number): string {
    return `action=user_define&channel=${channel}&cmd=ptz_right`
  }

  public static getPtzLeftCommand(channel: number): string {
    return `action=user_define&channel=${channel}&cmd=ptz_left`
  }

  public static getVideoStandardQualityUrlSuffix(channel: number): string {
    return `ipc.flv?action=live&channel=${channel}&quality=standard`
  }

  public static getVideoHightQualityUrlSuffix(channel: number): string {
    return `ipc.flv?action=live&channel=${channel}&quality=high`
  }

  public static getVideoSuperQualityUrlSuffix(channel: number): string {
    return `ipc.flv?action=live&channel=${channel}&quality=super`
  }

  public static getVideoMJPEGUrlSuffix(channel: number): string {
    return `ipc.flv?action=live-mjpg&channel=${channel}&quality=standard`
  }

  public static getVideoMJPEGAACUrlSuffix(): string {
    return `ipc.flv?action=live-audio`
  }

  public static getNvrIpcStatus(channel: number, type: number): string {
    const typeStr = `live`
    switch (type) {
      case 0: {
        return `live`
      }
      case 1: {
        `voice`
      }
    }

    return `action=inner_define&channel=${channel}&cmd=get_device_st&type=${typeStr}&quality=standard`
  }

  public static getTwoWayRadio(channel: number): string {
    return `channel=${channel}`
  }

  public static getMonthDates(channel: number, time: string): string {
    // yyyymm 年月
    return `action=inner_define&channel=${channel}&cmd=get_month_record&time=${time}`
  }

  public static getDayTimeBlocks(channel: number, date: Date): string {
    const dateStart = new Date()
    dateStart.setTime(date.getTime())
    dateStart.setHours(0)
    dateStart.setMinutes(0)
    dateStart.setSeconds(0)
    const dateEnd = new Date()
    dateStart.setTime(date.getTime())
    dateEnd.setHours(23)
    dateEnd.setMinutes(59)
    dateEnd.setSeconds(59)
    return `action=inner_define&channel=${channel}&cmd=get_file_list` +
      `&start_time=${dateStart.getTime() / 1000}&end_time=${dateEnd.getTime() / 1000}&file_type=0`
  }

  public static getLocalVideoUrl(channel: number, startTime: number, endTime: number): string {
    return `ipc.flv?action=playback&channel=${channel}&start_time=${startTime}&end_time=${endTime}`
  }

  public static pauseLocalVideoUrl(channel: number): string {
    return `action=inner_define&channel=${channel}&cmd=playback_pause`
  }

  public static resumeLocalVideoUrl(channel: number): string {
    return `action=inner_define&channel=${channel}&cmd=playback_resume`
  }

  public static seekLocalVideo(channel: number, offset: number): string {
    return `action=inner_define&channel=${channel}&cmd=playback_seek&time=${offset}}`
  }
}