import { Coder, KeyManager } from "../../../ets/a/b"; import { AegLogger } from "../../c2/d2"; import { AlgUtil } from "../v/h3"; export class AsyKey { static async genAsyKeyPairBase64(h20) { return new Promise(async (j20, k20) => { try { let l20 = AlgUtil.getAsyKeyAlgType(h20); KeyManager.generateKeyPair(l20.algType).then((o20) => { let p20 = Coder.BASE64.encode(o20.priKey.getEncoded().data); let q20 = Coder.BASE64.encode(o20.pubKey.getEncoded().data); j20(new AsyKeyPair(q20, p20)); }).catch((err) => { AegLogger.error(AsyKey.TAG, 'genAsyKeyPairBase64 generateKeyPair fail, err code: ' + err.code + ', err msg: ' + err.message); k20(err); }); } catch (err) { AegLogger.error(AsyKey.TAG, 'genAsyKeyPairBase64 parse fail, err code: ' + err.code + ', err msg: ' + err.message); k20(err); } }); } static async genAsyKeyPair(x19) { return new Promise(async (z19, a20) => { try { let b20 = AlgUtil.getAsyKeyAlgType(x19); KeyManager.generateKeyPair(b20.algType).then((e20) => { let f20 = e20.priKey.getEncoded().data; let g20 = e20.pubKey.getEncoded().data; z19(new AsyKeyPair(g20, f20)); }).catch((err) => { AegLogger.error(AsyKey.TAG, 'genAsyKeyPair generateKeyPair fail, err code: ' + err.code + ', err msg: ' + err.message); a20(err); }); } catch (err) { AegLogger.error(AsyKey.TAG, 'genAsyKeyPair parse fail, err code: ' + err.code + ', err msg: ' + err.message); a20(err); } }); } } AsyKey.TAG = 'aegis AsyKey'; export class AsyKeyPair { constructor(publicKey, w19) { this.publicKey = publicKey; this.privateKey = w19; } } export const genAsyKeyPair = AsyKey.genAsyKeyPair; export const genAsyKeyPairBase64 = AsyKey.genAsyKeyPairBase64; 