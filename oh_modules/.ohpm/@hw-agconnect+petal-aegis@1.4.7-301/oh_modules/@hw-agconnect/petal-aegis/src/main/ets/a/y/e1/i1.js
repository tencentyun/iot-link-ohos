import { AegisError } from "../../s/t"; import { AegisErrorCode } from "../../s/u"; import { SymKeyLen } from "../z/a1"; export var CipherAlg; (function (o3) { o3[o3["AES_GCM_NO_PADDING"] = 0] = "AES_GCM_NO_PADDING"; o3[o3["AES_CBC_PKCS7_PADDING"] = 1] = "AES_CBC_PKCS7_PADDING"; o3[o3["AES_CBC_PKCS5_PADDING"] = 2] = "AES_CBC_PKCS5_PADDING"; o3[o3["AES_CTR_NO_PADDING"] = 3] = "AES_CTR_NO_PADDING"; o3[o3["AES_OFB_NO_PADDING"] = 4] = "AES_OFB_NO_PADDING"; o3[o3["AES_CCM_NO_PADDING"] = 5] = "AES_CCM_NO_PADDING"; o3[o3["AES_CFB_NO_PADDING"] = 6] = "AES_CFB_NO_PADDING"; o3[o3["RSA_OAEP_SHA256_MGF1_SHA256"] = 10] = "RSA_OAEP_SHA256_MGF1_SHA256"; o3[o3["SM4_CBC_PKCS7_PADDING"] = 20] = "SM4_CBC_PKCS7_PADDING"; o3[o3["SM4_CBC_PKCS5_PADDING"] = 21] = "SM4_CBC_PKCS5_PADDING"; o3[o3["SM4_CTR_NO_PADDING"] = 22] = "SM4_CTR_NO_PADDING"; o3[o3["SM4_OFB_NO_PADDING"] = 23] = "SM4_OFB_NO_PADDING"; o3[o3["SM4_CFB_NO_PADDING"] = 24] = "SM4_CFB_NO_PADDING"; o3[o3["SM4_CFB128_NO_PADDING"] = 25] = "SM4_CFB128_NO_PADDING"; o3[o3["SM2_256_SHA256"] = 31] = "SM2_256_SHA256"; o3[o3["SM2_256_SHA384"] = 32] = "SM2_256_SHA384"; o3[o3["SM2_256_SHA512"] = 33] = "SM2_256_SHA512"; o3[o3["SM2_256_SM3"] = 34] = "SM2_256_SM3"; o3[o3["HUKS_AES_GCM_256_NO_PADDING"] = 41] = "HUKS_AES_GCM_256_NO_PADDING"; })(CipherAlg || (CipherAlg = {})); const TRANSFORMATION_INDEX_MAP = new Map([ [SymKeyLen.AES_128, 0], [SymKeyLen.AES_192, 1], [SymKeyLen.AES_256, 2] ]); export function getTransformationIndexFromKey(key) { var n3; let len = (n3 = key === null || key === void 0 ? void 0 : key.getEncoded().data.length) !== null && n3 !== void 0 ? n3 : 0; if (!TRANSFORMATION_INDEX_MAP.has(len)) { throw new AegisError(AegisErrorCode.PARAM_INVALID, 'invalid key len'); } return TRANSFORMATION_INDEX_MAP.get(len); } 