import type cryptoFramework from '@ohos.security.cryptoFramework'; import type cryptoCert from '@ohos.security.cert'; import type { KeyType } from "./a1"; export declare abstract class AsyKeyBuilder { protected keyPair: cryptoFramework.KeyPair; protected cert: cryptoCert.X509Cert; protected priKey: Uint8Array; protected pubKey: Uint8Array; protected certPEM: string; protected certDER: Uint8Array; protected keyAlias: string; withKeyPair(z47: cryptoFramework.KeyPair): this; withPriKey(priKey: Uint8Array): this; withPriKeyBase64(y47: string): this; withPriKeyHex(x47: string): this; withPubKey(pubKey: Uint8Array): this; withPubKeyBase64(w47: string): this; withPubKeyHex(v47: string): this; withCertPEM(u47: string): this; withCertDER(t47: Uint8Array): this; withCertDERBase64(s47: string): this; withKeyAlias(keyAlias: string): this; protected initKeys(): Promise<void>; protected abstract getKeyType(): KeyType; protected abstract getRSANBits(): number; } 