import cryptoFramework from '@ohos.security.cryptoFramework'; import { AegisError } from "../../../s/t"; import { AegisErrorCode } from "../../../s/u"; import { Coder } from "../../s1/t1"; import { KeyConverter } from "../../z/c1"; import { Signer } from "../m1"; import { SignerInfoCenter } from "../l2"; import { SignHandler } from "../m2"; import { VerifyHandler } from "../n2"; import { HuksHmacSigner } from "./r2"; const HMAC_MIN_KEY_LEN = 28; export class HmacSignHandler extends SignHandler { constructor(o7, key) { super(o7); this.key = key; } async doSign() { let m7 = SignerInfoCenter.load(this.signAlg); let n7 = cryptoFramework.createMac(m7.algName); await n7.init(this.key); for (let input of this.inputs) { await n7.update({ data: input }); } return (await n7.doFinal()).data; } } export class HmacVerifyHandler extends VerifyHandler { constructor(l7, key) { super(l7); this.key = key; } async doVerify(target) { let j7 = SignerInfoCenter.load(this.signAlg); let k7 = cryptoFramework.createMac(j7.algName); await k7.init(this.key); for (let input of this.inputs) { await k7.update({ data: input }); } let signature = await k7.doFinal(); if (target.length !== signature.data.length) { return false; } for (let index = 0; index < signature.data.length; index++) { if (signature.data[index] !== target[index]) { return false; } } return true; } } export class HmacSigner extends Signer { constructor(i7, key) { super(i7); this.signHandler = new HmacSignHandler(i7, key); this.verifyHandler = new HmacVerifyHandler(i7, key); } static builder() { return new HmacSignerBuilder(); } } class HmacSignerBuilder { withSignAlg(h7) { this.signAlg = h7; return this; } withKey(key) { this.key = key; return this; } withKeyBytes(g7) { this.i = g7; return this; } withKeyHex(f7) { this.i = Coder.HEX.decode(f7); return this; } withKeyBase64(e7) { this.i = Coder.BASE64.decode(e7); return this; } withKeyAlias(keyAlias) { this.keyAlias = keyAlias; return this; } async build() { if (this.keyAlias) { return new HuksHmacSigner(this.signAlg, this.keyAlias); } if (this.key) { return new HmacSigner(this.signAlg, this.key); } if (this.i.length < HMAC_MIN_KEY_LEN) { throw new AegisError(AegisErrorCode.BAD_KEY_LEN, `hmac min key len is ${HMAC_MIN_KEY_LEN}`); } let key = await KeyConverter.fromSymKey(this.i); return new HmacSigner(this.signAlg, key); } } 