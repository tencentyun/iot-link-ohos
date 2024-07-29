import http from '@ohos.net.http';
import { Chain } from './Chain';

export interface Interector {
    intercept(chain: Chain): Promise<http.HttpResponse>
}