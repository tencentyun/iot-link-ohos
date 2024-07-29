import { AESCipher, CipherAlg, Coder } from "../ets/a/b"; import { AegLogger } from "./c2/d2"; import { SafeRandom } from "./e"; export class AegWorkKey { static async ohAegWorkKeyEncHex(text, i40, iv) { return new Promise(async (k40, l40) => { try { let m40 = new Uint8Array(); if (iv) { m40 = AegWorkKey.getUint8Array(iv); } else { m40 = SafeRandom.ohAegRandom(AegWorkKey.IV_LEN); } let n40 = AegWorkKey.getUint8Array(text); let o40 = AegWorkKey.getUint8Array(i40); if (!AegWorkKey.checkWorkKey(o40, n40)) { let msg = 'rootKey length less than text length or text length less than 16 bytes'; return l40(msg); } let p40 = await AESCipher .builder() .withCipherAlg(CipherAlg.AES_GCM_NO_PADDING) .withKeyBytes(o40) .withIv(m40) .build(); p40.getEncryptHandler().from(n40).toHex().then((data) => { let result = Coder.HEX.encode(m40) + ':' + data; k40(result); }).catch((err) => { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyEncHex getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); l40(err); }); } catch (err) { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyEncHex parse fail, err code: ' + err.code + ', err msg: ' + err.message); l40(err); } }); } static async ohAegWorkKeyEnc(text, x39, iv) { return new Promise(async (z39, a40) => { try { let b40 = new Uint8Array(); if (iv) { b40 = AegWorkKey.getUint8Array(iv); } else { b40 = SafeRandom.ohAegRandom(AegWorkKey.IV_LEN); } let c40 = AegWorkKey.getUint8Array(text); let d40 = AegWorkKey.getUint8Array(x39); if (!AegWorkKey.checkWorkKey(d40, c40)) { let msg = 'rootKey length less than text length or text length less than 16 bytes'; return a40(msg); } let e40 = await AESCipher .builder() .withCipherAlg(CipherAlg.AES_GCM_NO_PADDING) .withKeyBytes(d40) .withIv(b40) .build(); e40.getEncryptHandler().from(c40).to().then((data) => { let h40 = Coder.UTF8.decode(':'); let result = new Uint8Array(b40.length + data.length + h40.length); result.set(b40, 0); result.set(h40, b40.length); result.set(data, b40.length + h40.length); z39(result); }).catch((err) => { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyEnc getEncryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); a40(err); }); } catch (err) { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyEnc parse fail, err code: ' + err.code + ', err msg: ' + err.message); a40(err); } }); } static async ohAegWorkKeyDecHex(text, o39) { return new Promise(async (q39, r39) => { try { let s39 = AegWorkKey.getCiphertextUint8Array(text); let t39 = AegWorkKey.getUint8Array(o39); let u39 = await AESCipher .builder() .withCipherAlg(CipherAlg.AES_GCM_NO_PADDING) .withKeyBytes(t39) .withIv(s39.iv) .build(); u39.getDecryptHandler().from(s39.text).toHex().then((data) => { q39(data); }).catch((err) => { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyDecHex getDecryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); r39(err); }); } catch (err) { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyDecHex parse fail, err code: ' + err.code + ', err msg: ' + err.message); r39(err); } }); } static async ohAegWorkKeyDec(text, f39) { return new Promise(async (h39, i39) => { try { let j39 = AegWorkKey.getCiphertextUint8Array(text); let k39 = AegWorkKey.getUint8Array(f39); let l39 = await AESCipher .builder() .withCipherAlg(CipherAlg.AES_GCM_NO_PADDING) .withKeyBytes(k39) .withIv(j39.iv) .build(); l39.getDecryptHandler().from(j39.text).to().then((data) => { h39(data); }).catch((err) => { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyDec getDecryptHandler fail, err code: ' + err.code + ', err msg: ' + err.message); i39(err); }); } catch (err) { AegLogger.error(AegWorkKey.TAG, 'ohAegWorkKeyDec parse fail, err code: ' + err.code + ', err msg: ' + err.message); i39(err); } }); } static getUint8Array(input) { if (input instanceof Uint8Array) { return input; } else { return Coder.HEX.decode(input); } } static getCiphertextUint8Array(input) { if (input instanceof Uint8Array) { let iv = input.subarray(0, AegWorkKey.IV_LEN); let e39 = input.subarray(AegWorkKey.IV_LEN + 1, input.length); return new Ciphertext(iv, e39); } else { let iv = Coder.HEX.decode(input.substring(0, AegWorkKey.IV_LEN * 2)); let d39 = Coder.HEX.decode(input.substring((AegWorkKey.IV_LEN * 2) + 1, input.length)); return new Ciphertext(iv, d39); } } static checkWorkKey(b39, c39) { try { if (c39.length < AegWorkKey.WORKEY_LEN) { let msg = AegWorkKey.TAG + 'checkWorkKey workKey length less than 16 byte, workKey len: ' + JSON.stringify(c39.length); AegLogger.error(msg); return false; } if (b39.length < c39.length) { let msg = AegWorkKey.TAG + 'checkWorkKey workKey length less than rootKey length, workKey len: ' + JSON.stringify(c39.length) + ', rootKey len: ' + JSON.stringify(b39.length); AegLogger.error(msg); return false; } return true; } catch (err) { return false; } } } AegWorkKey.TAG = 'aegis AegWorkKey'; AegWorkKey.IV_LEN = 12; AegWorkKey.WORKEY_LEN = 16; export class Ciphertext { constructor(iv, text) { this.iv = iv; this.text = text; } } 