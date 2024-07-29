import { Md } from "../ets/a/b"; import { AegLogger } from "./c2/d2"; import Hash from '@ohos.file.hash'; import { getStrOrUint8ToUint8, getUint8Array, hexStringToUint8Array } from "./q/s2"; export class AegSha256 { static async ohAegSha256TextHex(text) { return new Promise((l36, m36) => { try { let n36 = getStrOrUint8ToUint8(text); Md.SHA256().from(n36).toHex().then((data) => { l36(data); }).catch((err) => { AegLogger.error(AegSha256.TAG, 'ohAegSha256 Md.SHA256 fail, err code: ' + err.code + ', err msg: ' + err.message); m36(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegSha256 parse fail, err code: ' + err.code + ', err msg: ' + err.message); m36(err); } }); } static async ohAegSha256Text(text) { return new Promise((f36, g36) => { try { let h36 = getStrOrUint8ToUint8(text); Md.SHA256().from(h36).to().then((data) => { f36(data); }).catch((err) => { AegLogger.error(AegSha256.TAG, 'ohAegSha256 Md.SHA256 fail, err code: ' + err.code + ', err msg: ' + err.message); g36(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegSha256 parse fail, err code: ' + err.code + ', err msg: ' + err.message); g36(err); } }); } static async ohAegSha256Hex(text) { return new Promise((z35, a36) => { try { let b36 = getUint8Array(text); Md.SHA256().from(b36).toHex().then((data) => { z35(data); }).catch((err) => { AegLogger.error(AegSha256.TAG, 'ohAegSha256 Md.SHA256 fail, err code: ' + err.code + ', err msg: ' + err.message); a36(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegSha256 parse fail, err code: ' + err.code + ', err msg: ' + err.message); a36(err); } }); } static async ohAegSha256Uint8Array(text) { return new Promise((t35, u35) => { try { let v35 = getUint8Array(text); Md.SHA256().from(v35).to().then((data) => { t35(data); }).catch((err) => { AegLogger.error(AegSha256.TAG, 'ohAegSha256Uint8Array Md.SHA256 fail, err code: ' + err.code + ', err msg: ' + err.message); u35(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegSha256Uint8Array parse fail, err code: ' + err.code + ', err msg: ' + err.message); u35(err); } }); } static async ohAegFileSha256Hex(filePath) { return new Promise((o35, p35) => { try { if (!filePath || filePath.length === 0) { let msg = 'ohAegFileSha256Hex filePath is empty'; AegLogger.error(AegSha256.TAG, msg); return p35(msg); } Hash.hash(filePath, AegSha256.SHA256).then((str) => { return o35(str); }).catch((err) => { AegLogger.error(AegSha256.TAG, "Hash.hash file hash failed with error message: " + err.message + ", error code: " + err.code); return p35(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegFileSha256Hex hash parse fail, err code: ' + err.code + ', err msg: ' + err.message); return p35(err); } }); } static async ohAegFileSha256(filePath) { return new Promise((i35, j35) => { try { if (!filePath || filePath.length === 0) { let msg = 'ohAegFileSha256Hex filePath is empty'; AegLogger.error(AegSha256.TAG, msg); return j35(msg); } Hash.hash(filePath, AegSha256.SHA256).then((str) => { let m35 = hexStringToUint8Array(str); return i35(m35); }).catch((err) => { AegLogger.error(AegSha256.TAG, "Hash.hash file hash failed with error message: " + err.message + ", error code: " + err.code); return j35(err); }); } catch (err) { AegLogger.error(AegSha256.TAG, 'ohAegFileSha256Hex hash parse fail, err code: ' + err.code + ', err msg: ' + err.message); return j35(err); } }); } } AegSha256.TAG = 'aegis AegSha256'; AegSha256.SHA256 = 'sha256'; 