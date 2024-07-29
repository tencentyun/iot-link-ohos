import { RequestBody } from '../RequestBody'

export default interface Task{
    requestBody: RequestBody
    resolve: Function
    reject: Function
}