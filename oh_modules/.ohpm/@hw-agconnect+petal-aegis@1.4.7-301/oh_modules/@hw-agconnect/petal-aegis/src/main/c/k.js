import { AsySigner, Coder, SignAlg } from "../ets/a/b"; import { AegLogger } from "./c2/d2"; import { getStrOrUint8ToUint8 } from "./q/s2"; export class AegRsaSign { static async ohAegSignRSAWithPSSText(text, priKey) { return new Promise(async (c35, d35) => { try { let e35 = getStrOrUint8ToUint8(text); AegRsaSign.ohAegSignRSAWithPSS(e35, priKey).then((data) => { return c35(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSSText ohAegSignRSAWithPSS fail, err code: ' + err.code + ', err msg: ' + err.message); return d35(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSSText fail, err code: ' + err.code + ', err msg: ' + err.message); return d35(err); } }); } static async ohAegSignRSAWithPSSTextBase64(text, priKey) { return new Promise(async (w34, x34) => { try { let y34 = getStrOrUint8ToUint8(text); AegRsaSign.ohAegSignRSAWithPSSHex(y34, priKey).then((data) => { return w34(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegAesGcmEncText ohAegAesGcmEncHex fail, err code: ' + err.code + ', err msg: ' + err.message); return x34(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegAesGcmEncText fail, err code: ' + err.code + ', err msg: ' + err.message); return x34(err); } }); } static async ohAegSignRSAWithPSSHex(text, priKey) { return new Promise(async (o34, p34) => { try { let q34 = AegRsaSign.getUint8Array(text); let r34 = AegRsaSign.Base64ToUint8Array(priKey); let s34 = await AsySigner .builder() .withSignAlg(SignAlg.RSA_PSS_SHA256_MGF1_SHA256) .withPriKey(r34) .build(); s34.getSignHandler().from(q34).toBase64().then((data) => { o34(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSSHex getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); p34(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSSHex parse fail, err code: ' + err.code + ', err msg: ' + err.message); p34(err); } }); } static async ohAegSignRSAWithPSS(text, priKey) { return new Promise(async (g34, h34) => { try { let i34 = AegRsaSign.getUint8Array(text); let j34 = AegRsaSign.Base64ToUint8Array(priKey); let k34 = await AsySigner .builder() .withSignAlg(SignAlg.RSA_PSS_SHA256_MGF1_SHA256) .withPriKey(j34) .build(); k34.getSignHandler().from(i34).to().then((data) => { g34(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSS getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); h34(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegSignRSAWithPSS parse fail, err code: ' + err.code + ', err msg: ' + err.message); h34(err); } }); } static async ohAegCheckSignRSAWithPSS(text, pubKey, sign) { return new Promise(async (x33, y33) => { try { let z33 = AegRsaSign.getUint8Array(text); let a34 = AegRsaSign.Base64ToUint8Array(pubKey); let b34 = AegRsaSign.Base64ToUint8Array(sign); let c34 = await AsySigner .builder() .withSignAlg(SignAlg.RSA_PSS_SHA256_MGF1_SHA256) .withPubKey(a34) .build(); c34.getVerifyHandler().from(z33).verify(b34).then((data) => { x33(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegCheckSignRSAWithPSS getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); y33(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegCheckSignRSAWithPSS parse fail, err code: ' + err.code + ', err msg: ' + err.message); y33(err); } }); } static async ohAegCheckSignRSAWithPSSText(text, pubKey, sign) { return new Promise(async (r33, s33) => { try { let t33 = getStrOrUint8ToUint8(text); AegRsaSign.ohAegCheckSignRSAWithPSS(t33, pubKey, sign).then((data) => { r33(data); }).catch((err) => { AegLogger.error(AegRsaSign.TAG, 'ohAegCheckSignRSAWithPSS getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); s33(err); }); } catch (err) { AegLogger.error(AegRsaSign.TAG, 'ohAegCheckSignRSAWithPSS parse fail, err code: ' + err.code + ', err msg: ' + err.message); s33(err); } }); } static getUint8Array(input) { if (input instanceof Uint8Array) { return input; } else { return Coder.HEX.decode(input); } } static Base64ToUint8Array(input) { if (input instanceof Uint8Array) { return input; } else { return Coder.BASE64.decode(input); } } } AegRsaSign.TAG = 'aegis AegRsaSign'; 