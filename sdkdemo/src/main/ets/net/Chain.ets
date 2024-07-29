import http from '@ohos.net.http';
import { RequestBody } from './RequestBody';

export class Chain{
    requestBody : RequestBody
    constructor(requestBody : RequestBody) {
        this.requestBody = requestBody
    }

    process(chain : Chain) : Promise<http.HttpResponse> {
        return chain.requestBody.execute(chain)
    }
}