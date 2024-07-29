import { CipherAlg, CipherInfo } from "./i1"; export declare class CipherInfoCenter { static readonly AES_GCM_NO_PADDING = CipherAlg.AES_GCM_NO_PADDING; static readonly AES_CBC_PKCS7_PADDING = CipherAlg.AES_CBC_PKCS7_PADDING; static readonly AES_CBC_PKCS5_PADDING = CipherAlg.AES_CBC_PKCS5_PADDING; static readonly AES_CTR_NO_PADDING = CipherAlg.AES_CTR_NO_PADDING; static readonly AES_OFB_NO_PADDING = CipherAlg.AES_OFB_NO_PADDING; static readonly AES_CCM_NO_PADDING = CipherAlg.AES_CCM_NO_PADDING; static readonly AES_CFB_NO_PADDING = CipherAlg.AES_CFB_NO_PADDING; static readonly SM4_CBC_PKCS7_PADDING = CipherAlg.SM4_CBC_PKCS7_PADDING; static readonly SM4_CBC_PKCS5_PADDING = CipherAlg.SM4_CBC_PKCS5_PADDING; static readonly SM4_CTR_NO_PADDING = CipherAlg.SM4_CTR_NO_PADDING; static readonly SM4_OFB_NO_PADDING = CipherAlg.SM4_OFB_NO_PADDING; static readonly SM4_CFB_NO_PADDING = CipherAlg.SM4_CFB_NO_PADDING; static readonly SM4_CFB128_NO_PADDING = CipherAlg.SM4_CFB128_NO_PADDING; static readonly RSA_OAEP_SHA256_MGF1_SHA256 = CipherAlg.RSA_OAEP_SHA256_MGF1_SHA256; static readonly SM2_256_SHA256 = CipherAlg.SM2_256_SHA256; static readonly SM2_256_SHA384 = CipherAlg.SM2_256_SHA384; static readonly SM2_256_SHA512 = CipherAlg.SM2_256_SHA512; static readonly SM2_256_SM3 = CipherAlg.SM2_256_SM3; static readonly HUKS_AES_GCM_256_NO_PADDING = CipherAlg.HUKS_AES_GCM_256_NO_PADDING; private static center; static register(l46: CipherAlg, m46: CipherInfo): void; static load(k46: CipherAlg): CipherInfo; } 