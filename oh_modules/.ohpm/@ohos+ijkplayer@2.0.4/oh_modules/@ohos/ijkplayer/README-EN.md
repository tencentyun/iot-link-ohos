# ijkplayer

## Introduction
>  ijkplayer is an FFmpeg-based video player that works in OpenHarmony.

## Demo
<img src="screenshot/ijkplayer-en.gif" width="100%"/>

## Building and Running

1. In DevEco Studio, download the dependent SDK. Choose **Tools** > **SDK Manager** > **OpenHarmony SDK**, and download an SDK whose API version is later than 9, with **Native** selected.

2. Select RK3568 for the development board. [Download the ROM](http://ci.openharmony.cn/workbench/cicd/dailybuild/dailylist). Select **rk3568** as the development board type. Use the latest version.

3. Download the source code through the Git client, rather than or through the web page.

## Downloading and Installing
```shell
ohpm install @ohos/ijkplayer
```
## How to Use
```
   import { IjkMediaPlayer } from "@ohos/ijkplayer";
   import type { OnPreparedListener } from "@ohos/ijkplayer";
   import type { OnVideoSizeChangedListener } from "@ohos/ijkplayer";
   import type { OnCompletionListener } from "@ohos/ijkplayer";
   import type { OnBufferingUpdateListener } from "@ohos/ijkplayer";
   import type { OnErrorListener } from "@ohos/ijkplayer";
   import type { OnInfoListener } from "@ohos/ijkplayer";
   import type { OnSeekCompleteListener } from "@ohos/ijkplayer";
   import { LogUtils } from "@ohos/ijkplayer";
```
### Configuring the \<XComponent> on the UI
```
    XComponent({
      id: 'xcomponentId',
      type: 'surface',
      libraryname: 'ijkplayer_napi'
    })
    .onLoad((context) => {
      this.initDelayPlay(context);
     })
     .onDestroy(() => {
     })
     .width('100%')
     .aspectRatio(this.aspRatio)
```

### Play
```
    let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
    // Set the context of the <XComponent> callback.
    mIjkMediaPlayer.setContext(this.mContext);
    // Set the debug mode.
    mIjkMediaPlayer.setDebug(true);
    // Initialize configuration.
    mIjkMediaPlayer.native_setup();
    // Set the video source.
    mIjkMediaPlayer.setDataSource(url); 
    // Set the HTTP request header of the video source.
    let headers =  new Map([
      ["user_agent", "Mozilla/5.0 BiliDroid/7.30.0 (bbcallen@gmail.com)"],
      ["referer", "https://www.bilibili.com"]
    ]);
    mIjkMediaPlayer.setDataSourceHeader(headers);
    // Enable accurate seeking. This allows you to move to the keyframe precisely from the seeking point, instead of a keyframe before the seeking point.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", "1");
    // Size of the buffer for prefetching.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", "102400");
    // Minimum number of frames for stopping prefetching.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "min-frames", "100");
    // Start preloading.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", "1");
    // Set the buffer size to 0. This is the buffer of the player. The player starts playback when there is data.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", "0");
    // Frame skipping. When the CPU processing is slow, frame skipping is performed to ensure audio-to-video synchronization.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", "5");
    // The maximum cache is 3s. Sometimes, due to unstable network performance, data of several seconds is received in a short period of time.
    // To reduce the accumulated latency, packet loss is required on the player.
    // This is irrelevant to the third parameter packet-buffering.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max_cached_duration", "3000");
    // Unlimited stream receiving
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1");
    // Keep screen always on.
    mIjkMediaPlayer.setScreenOnWhilePlaying(true);
    // Set the timeout.
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "connect_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "listen_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "addrinfo_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "dns_cache_timeout", "10000000");
    
    let mOnVideoSizeChangedListener: OnVideoSizeChangedListener = {
      onVideoSizeChanged(width: number, height: number, sar_num: number, sar_den: number) {
        that.aspRatio = width / height;
        LogUtils.getInstance()
          .LOGI("setOnVideoSizeChangedListener-->go:" + width + "," + height + "," + sar_num + "," + sar_den)
        that.hideLoadIng();
      }
    }
    mIjkMediaPlayer.setOnVideoSizeChangedListener(mOnVideoSizeChangedListener);
    let mOnPreparedListener: OnPreparedListener = {
      onPrepared() {
        LogUtils.getInstance().LOGI("setOnPreparedListener-->go");
      }
    }
    mIjkMediaPlayer.setOnPreparedListener(mOnPreparedListener);

    let mOnCompletionListener: OnCompletionListener = {
      onCompletion() {
        LogUtils.getInstance().LOGI("OnCompletionListener-->go")
        that.currentTime = that.stringForTime(mIjkMediaPlayer.getDuration());
        that.progressValue = PROGRESS_MAX_VALUE;
        that.stop();
      }
    }
    mIjkMediaPlayer.setOnCompletionListener(mOnCompletionListener);

    let mOnBufferingUpdateListener: OnBufferingUpdateListener = {
      onBufferingUpdate(percent: number) {
        LogUtils.getInstance().LOGI("OnBufferingUpdateListener-->go:" + percent)
      }
    }
    mIjkMediaPlayer.setOnBufferingUpdateListener(mOnBufferingUpdateListener);

    let mOnSeekCompleteListener: OnSeekCompleteListener = {
      onSeekComplete() {
        LogUtils.getInstance().LOGI("OnSeekCompleteListener-->go")
        that.startPlayOrResumePlay();
      }
    }
    mIjkMediaPlayer.setOnSeekCompleteListener(mOnSeekCompleteListener);

    let mOnInfoListener: OnInfoListener = {
      onInfo(what: number, extra: number) {
        LogUtils.getInstance().LOGI("OnInfoListener-->go:" + what + "===" + extra)
      }
    }
    mIjkMediaPlayer.setOnInfoListener(mOnInfoListener);

    let mOnErrorListener: OnErrorListener = {
      onError(what: number, extra: number) {
        LogUtils.getInstance().LOGI("OnErrorListener-->go:" + what + "===" + extra)
        that.hideLoadIng();
        prompt.showToast({
          message:"Video playback error."
        });
      }
    }
    mIjkMediaPlayer.setOnErrorListener(mOnErrorListener);

    mIjkMediaPlayer.setMessageListener();

    mIjkMediaPlayer.prepareAsync();

    mIjkMediaPlayer.start();
```
### Pause
```
   mIjkMediaPlayer.pause();
```
### Stop
```
   mIjkMediaPlayer.stop();
```
### Reset
```
   mIjkMediaPlayer.reset();
```
### Release
```
   mIjkMediaPlayer.release();
```
### Seek
```
   mIjkMediaPlayer.seekTo(msec);
```
### Playback at Different Speeds
```
   mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "soundtouch", "1");
   mIjkMediaPlayer.setSpeed("2f");
```
### Screen Always On
```
   mIjkMediaPlayer.setScreenOnWhilePlaying(true);
```
### Repeat Mode
```
   mIjkMediaPlayer.setLoopCount(true);
```
### Volume Configuration
```
   mIjkMediaPlayer.setVolume(leftVolume, rightVolume);
```

## Available APIs

### IjkMediaPlayer.getInstance()
| API                     | Parameter                        | Return Value            | Description                                      |
| ---------------------------| --------------------------- | ----------------- | ----------------------------------------- |
| setContext                 | context: object            | void              | Sets the context of the **\<XComponent>** callback.                |
| setDebug                   | open: boolean              | void              | Specifies whether to enable debugging.                               |
| native_setup               | -                        | void              | Initializes the configuration.                                 |
| setDataSource              | url: string                | void               | Sets the URL of the video source.                            |
| setDataSourceHeader        | headers: Map<string, string> | void            | Sets the HTTP request header of the video source.                     |
| setOption                  | category:string, key: string, value: string | void | Sets preset playback parameters.                     |
| setOptionLong              | category:string, key: string, value: string | void | Sets preset playback parameters.                     |
| prepareAsync               | -                          | void              | Loads the video.                                  |
| start                      | -                          | void              | Starts video playback.                                  |
| stop                       | -                          | void              | Stops video playback.                                  |
| pause                      | -                          | void              | Pauses video playback.                                  |
| reset                      | -                          | void              | Resets video playback.                                  |
| release                    | -                          | void              | Releases resources.                                  |
| seekTo                     | msec: string               | void              | Seeks to a specified position.                                |
| setScreenOnWhilePlaying    | on: boolean                  | void              | Specifies whether to keep the screen always on.                              |
| setSpeed                   | speed: string                | void              | Sets the playback speed.                              |
| getSpeed                   | -                          | number             | Obtains the playback speed.                             |
| isPlaying                   | -                          | boolean            | Checks whether the video is playing.                       |
| setOnVideoSizeChangedListener | listener: OnVideoSizeChangedListener | void     | Sets the callback listener for obtaining the video width and height.                    |
| setOnPreparedListener       | listener: OnPreparedListener           | void     | Sets the callback listener for when the video is ready.                    |
| setOnInfoListener           | listener: OnInfoListener               | void     | Sets the callback listener for the player status.                 |
| setOnErrorListener          | listener: OnErrorListener              | void     | Sets the callback listener for playback errors.                       |
| setOnBufferingUpdateListener | listener: OnBufferingUpdateListener   | void     | Sets the buffer callback listener.                    |
| setOnSeekCompleteListener    | listener: OnSeekCompleteListener      | void     | Sets the callback listener for seeking.                       |
| setMessageListener           | -                         | void              | Sets the video callback listener for receiving messages from NAPI.             |
| getVideoWidth                | -                         | number            | Obtains the video width.                              |
| getVideoHeight                | -                         | number            | Obtains the video height.                             |
| getVideoSarNum                | -                         | number            | Obtains the video height.                             |
| getVideoSarDen                | -                         | number            | Obtains the video height.                             |
| getDuration                   | -                         | number            | Obtains the total duration of the video.                          |
| getCurrentPosition            | -                         | number            | Obtains the current playback position of the video.                       |
| getAudioSessionId             | -                         | number             | Obtains the audio session ID.                       |
| setVolume                     | leftVolume: string,rightVolume:string | void   | Sets the volume.                                |
| setLoopCount                  | looping: boolean             | void               | Specifies whether to repeat the playback.                             |
| isLooping                     | -                          | boolean            | Checks whether the playback is repeated.                       |
| selectTrack                   | track: string                | void               | Selects a track.                                |
| deselectTrack                 | track: string                | void               | Deselects a track.                             |
| getMediaInfo                  | -                          | object              | Obtains media information.                             |


## Building Dependent Third-Party Libraries

1. FFmpeg: built on FFmpeg ff4.0--ijk0.8.8--20210426--001 ([source code](https://github.com/bilibili/FFmpeg/tags)). Build this library with GN. For details, see [Compilation and Building Guide](https://gitee.com/openharmony/docs/blob/master/en/device-dev/subsystems/subsys-build-all.md). For details about the compilation scripts, see **doc/FFmpeg/**.

2. soudtouch: built on soudtouch ijk-r0.1.2-dev ([source code](https://github.com/bilibili/soundtouch/branches)). You can build this library with CMake in DevEco Studio. For details about the compilation scripts, see **doc/soundtouch**.

3. YUV: built on YUV ijk-r0.2.1-dev ([source code](https://github.com/bilibili/libyuv/branches)). You can build this library with CMake in DevEco Studio. For details about the compilation scripts, see **doc/yuv**.


## Constraints

ijkplayer has been verified in the following versions:
- DevEco Studio: 4.1Canary2 (4.1.3.322) SDK: API11 (4.1.0.36)
- DevEco Studio: 4.1Canary (4.1.3.213) SDK: API11 (4.1.2.3)
- DevEco Studio: 4.0 (4.0.3.512) SDK: API10 (4.0.10.9)
- DevEco Studio: 4.0Canary1 (4.0.3.212) SDK: API10 (4.0.8.3)

## Directory Structure

```javascript
|---- ijkplayer  
|     |---- entry  # Sample code
|     |---- ijkplayer  # ijkplayer library folder
|			|---- cpp  # Native module
|                  |----- ijkplayer # ijkplayer's internal service
|                  |----- ijksdl    # ijkplayer's internal service
|                  |----- napi      # Encapsulated NAPI
|                  |----- proxy     # Proxy provided for NAPI to call and process ijkplayer's internal services
|                  |----- third_party # Third-party library dependencies
|                  |----- utils     # Utilities
|            |---- ets  # ArkTS module
|                  |----- callback  # Video callback
|                  |----- common    # Constants
|                  |----- utils     # Utilities 
|                  |----- IjkMediaPlayer.ets # Exposed interfaces
|     |---- README.MD  # Instructions for installation and usage                  
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-sig/ijkplayer/issues). You can also submit a [pull request](https://gitee.com/openharmony-sig/ijkplayer/pulls).

## License

ijkplayer is based on [LGPLv2.1 or later](LICENSE).
