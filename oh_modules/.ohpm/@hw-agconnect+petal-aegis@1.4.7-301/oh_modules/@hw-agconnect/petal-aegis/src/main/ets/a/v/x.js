import cryptoFramework from '@ohos.security.cryptoFramework'; export class SecureRandom { static generateRandom(len) { return cryptoFramework.createRandom().generateRandomSync(len).data; } } 