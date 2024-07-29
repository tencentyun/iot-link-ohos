import type huks from '@ohos.security.huks'; import type { KeyType } from "../z/a1"; export declare enum SignAlg { HMAC_SHA256 = 0, HMAC_SHA384 = 1, HMAC_SHA512 = 2, HMAC_SHA224 = 3, HMAC_SM3 = 4, RSA_PSS_SHA256_MGF1_SHA256 = 10, ECDSA_SHA256 = 20, SM2_256_SM3 = 30, HUKS_ECDSA_SHA256 = 40, HUKS_HMAC_SHA256 = 50 } declare type HuksOptionsFunc = (purpose: huks.HuksKeyPurpose) => huks.HuksOptions; export interface SignerInfo { algName?: string; keyType?: KeyType; nBits?: number; optionsFunc?: HuksOptionsFunc; pssSaltLen?: number; } export {}; 