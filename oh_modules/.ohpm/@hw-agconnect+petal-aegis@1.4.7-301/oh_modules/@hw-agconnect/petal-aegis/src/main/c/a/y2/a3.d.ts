import { SM2Alg } from "./z2"; export declare class SM2 { private static TAG; static sm2EncText(m49: SM2Alg, n49: string, pubKey: string | Uint8Array): Promise<Uint8Array>; static sm2DecText(k49: SM2Alg, l49: Uint8Array, priKey: string | Uint8Array): Promise<string>; static sm2EncTextBase64(i49: SM2Alg, j49: string, pubKey: string | Uint8Array): Promise<string>; static sm2DecTextBase64(g49: SM2Alg, h49: string, priKey: string | Uint8Array): Promise<string>; static sm2Enc(e49: SM2Alg, f49: Uint8Array, pubKey: string | Uint8Array): Promise<Uint8Array>; static sm2Dec(c49: SM2Alg, d49: Uint8Array, priKey: string | Uint8Array): Promise<Uint8Array>; } export declare const sm2EncText: typeof SM2.sm2EncText; export declare const sm2DecText: typeof SM2.sm2DecText; export declare const sm2EncTextBase64: typeof SM2.sm2EncTextBase64; export declare const sm2DecTextBase64: typeof SM2.sm2DecTextBase64; export declare const sm2Enc: typeof SM2.sm2Enc; export declare const sm2Dec: typeof SM2.sm2Dec; 