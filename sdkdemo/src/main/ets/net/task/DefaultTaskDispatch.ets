import { TaskDispatch } from './TaskDispatch';
import http from '@ohos.net.http';
import Task from './Task';
import { RequestBody } from '../RequestBody';
import { Chain } from '../Chain';
import { BusinessError } from '@kit.BasicServicesKit';

export class DefaultTaskDispatch implements TaskDispatch {
  private MAX = 5
  private workingList: Task[] = []
  private waitingList: Task[] = []

  cancel(tag: string) {
    if (!tag || tag.length == 0) {
      return
    }
    this.workingList.forEach((it) => {
      if (it.requestBody.getTag() === tag) {
        it.requestBody.cancel()
      }
    })
    this.waitingList = this.waitingList.filter((it) => {
      return it.requestBody.getTag() !== tag
    })
  }

  dispatch(requestBody: RequestBody): Promise<http.HttpResponse> {
    return new Promise<http.HttpResponse>((resolve, reject) => {
      const task: Task = {
        requestBody: requestBody,
        resolve: resolve,
        reject: reject
      }
      if (task.requestBody.isExpressed()) {
        getContext()
        this.workingList.push(task)
        task.requestBody.execute(new Chain(task.requestBody)).then((response) => {
          this.done(task.requestBody)
          task.resolve(response)
        }).catch((err: BusinessError) => {
          this.done(task.requestBody)
          task.reject(err)
        })
      } else {
        const wordingIndex = this.workingList.findIndex((it) => {
          return it.requestBody.getUrlWithParam() === task.requestBody.getUrlWithParam()
        })
        const waitingIndex = this.waitingList.findIndex((it) => {
          return it.requestBody.getUrlWithParam() === task.requestBody.getUrlWithParam()
        })
        if (wordingIndex >= 0 || waitingIndex >= 0) {
          return
        }
        if (wordingIndex === -1) {
          if (this.workingList.length < this.MAX) {
            this.workingList.push(task)
            task.requestBody.execute(new Chain(task.requestBody)).then((response) => {
              this.done(task.requestBody)
              task.resolve(response)
            }).catch((err: BusinessError) => {
              this.done(task.requestBody)
              task.reject(err)
            })
          } else {
            const waitingIndex = this.waitingList.findIndex((it) => {
              return it.requestBody.getUrlWithParam() === task.requestBody.getUrlWithParam()
            })
            if (waitingIndex === -1) {
              this.waitingList.push(task)
            } else {
              this.waitingList.slice(waitingIndex, 1)
              this.waitingList.push(task)
            }
          }
        }
      }
    })
  }


  done(requestBody: RequestBody) {
    this.workingList = this.workingList.filter((it) => {
      return it.requestBody !== requestBody
    })
    if (this.waitingList.length > 0 && this.workingList.length < this.MAX) {
      let task = this.waitingList.shift()
      if (task) {
        this.workingList.push(task)
        task.requestBody.execute(new Chain(task.requestBody)).then((response) => {
          if (task?.requestBody) {
            this.done(task?.requestBody)
          }
          task?.resolve(response)
        }).catch((err: BusinessError) => {
          task?.reject(err)
        })
      }
    }
  }
}