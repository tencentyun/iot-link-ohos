import http from '@ohos.net.http';
import { RequestBody } from '../RequestBody';

export interface TaskDispatch {
  cancel(tag: string): void

  dispatch(requestBody: RequestBody): Promise<http.HttpResponse>

  done(requestBody: RequestBody): void
}