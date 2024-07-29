
import http from '@ohos.net.http';
export interface NetConverter{
	onConvert<R>(response: http.HttpResponse): R
}