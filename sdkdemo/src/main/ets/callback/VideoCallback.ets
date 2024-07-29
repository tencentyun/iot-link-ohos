export interface VideoCallback<T> {

  fail: (reqCode: number, msg?: string) => void
  success: (reqCode: number, response?: T) => void
}