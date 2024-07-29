import hilog from '@ohos.hilog';
import testNapi from 'liblibiotvideo.so'
import { OnStateListener, IoTVideoMessageType } from "./OnStateListener";
import audio from '@ohos.multimedia.audio';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';

export class IoTVideoBridge {

  private static instance: IoTVideoBridge;
  private audioCapturer: audio.AudioCapturer | undefined = undefined;

  private constructor() {
  };

  public static getInstance(): IoTVideoBridge {
    if (!IoTVideoBridge.instance) {
      IoTVideoBridge.instance = new IoTVideoBridge();
    }
    return IoTVideoBridge.instance;
  }

  private mOnStateListener: OnStateListener | null = null;

  setMessageListener(listener: OnStateListener): void {
    this.mOnStateListener = listener;
    let that = this;
    let messageCallBack = (what: number, arg1: number, arg2: number, obj: string) => {
      hilog.info(0x0000, 'testTag', 'messageCallBack what=%{public}d, arg1=%{public}d, arg2=%{public}d, obj= %{public}s', what,arg1,arg2,obj);
      if (what == IoTVideoMessageType.XP2P_READY) {
        if (that.mOnStateListener !== null)
          that.mOnStateListener.onReady();
      }else if (what == IoTVideoMessageType.XP2P_DISCONNECT) {
        if (that.mOnStateListener !== null)
          that.mOnStateListener.onDisconnect();
      }
    };
    testNapi.setMessageListener(messageCallBack);
  }

  startAppWith(pro_id: string, dev_name: string, type: number) {
    hilog.info(0x0000, 'testTag', 'startAppWith = %{public}s', testNapi.startService(pro_id, dev_name));
  }

  stopService(dev_name: string) {
    testNapi.stopService(dev_name);
  }

  setXp2pInfo(dev_name: string, xp2pinfo: string) {
    testNapi.setXp2pInfo(dev_name,xp2pinfo);
  }

  getUrlForHttpFlv(dev_name: string): string {
    return testNapi.getUrlForHttpFlv(dev_name);
  }

  getCommandRequestWithAsync(dev_name: string, cmd: string, result: (result: string) => void) {
    testNapi.getCommandRequestWithAsync(dev_name, cmd, result);
  }

  startAvRecvService(dev_name: string, cmd: string) {
    testNapi.startAvRecvService(dev_name, cmd);
  }

  stopAvRecvService(dev_name: string) {
    testNapi.stopAvRecvService(dev_name);
  }

  startTalk(dev_name: string) {
    testNapi.startTalk(dev_name); //开启服务，启动采集，数据编码，发送数据

    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率
      channels: audio.AudioChannel.CHANNEL_1, // 通道
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
    };

    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,// 音源类型
      capturerFlags: 0 // 音频采集器标志
    };

    let audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    };
    /*
    let bufferSize: number = 0;
    class Options {
      offset?: number;
      length?: number;
    }
    let path = getContext().cacheDir;
    let filePath = path + '/recodepcm-16000-1.pcm';
    let file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    */
    audio.createAudioCapturer(audioCapturerOptions, (err, data) => {
      if (err) {
        console.error(`Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('Invoke createAudioCapturer succeeded.');
        this.audioCapturer = data;
        this.audioCapturer.on('readData', (buffer: ArrayBuffer) => {
          testNapi.encodeTalkData(dev_name, buffer);
          /*
          hilog.info(0x0000, 'testTag', 'readDataCallback = %{public}d', buffer.byteLength);
          let options: Options = {
            offset: bufferSize,
            length: buffer.byteLength
          }
          fs.writeSync(file.fd, buffer, options);
          bufferSize += buffer.byteLength;
          */
        });
        this.audioCapturer.start((err: BusinessError) => {
          if (err) {
            console.error(`Capturer start failed, code is ${err.code}, message is ${err.message}`);
          } else {
            console.info('Capturer start success.');
          }
        });

      }
    });

  }

  stopTalk(dev_name: string) {
    this.audioCapturer?.stop((err: BusinessError) => {
      if (err) {
        console.error(`Capturer stop failed, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('Capturer stopped.');
        this.audioCapturer?.release(); // 释放资源
      }
    });
    testNapi.stopTalk(dev_name);
  }
}