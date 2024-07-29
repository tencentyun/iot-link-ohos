
import http from '@ohos.net.http';
import { NetConverter } from './NetConverter';

export class JsonCoverter implements NetConverter{

	onConvert<R>(response: http.HttpResponse): R {
		if(response.responseCode >= 200 && response.responseCode <= 299) {
			if(response.resultType === http.HttpDataType.STRING) {
				return JSON.parse(response.result as string) as R
			} else if(response.resultType === http.HttpDataType.OBJECT) {
				return response.result as R
			} else {
				throw new Error('Invalid data')
			}
		} else if(response.responseCode >= 400 && response.responseCode <= 499) {
			throw new Error('Invalid data params')
		} else if(response.responseCode >= 500) {
			throw new Error('Server error')
		} else {
			throw new Error('Other error')
		}
	}
}