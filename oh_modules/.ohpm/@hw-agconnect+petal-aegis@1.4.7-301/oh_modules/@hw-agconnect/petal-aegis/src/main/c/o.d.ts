export declare class AegEcc { private static TAG; private static IV_LEN; static ohAegGenEccKeyPairBase64(): Promise<EccKeyPair>; static ohAegGenEccKeyPair(): Promise<EccKeyPair>; static ohAegEccSignText(text: string | Uint8Array, priKey: string | Uint8Array): Promise<Uint8Array>; static ohAegEccSignTextBase64(text: string | Uint8Array, priKey: string | Uint8Array): Promise<string>; static ohAegEccSignHex(text: string | Uint8Array, priKey: string | Uint8Array): Promise<string>; static ohAegEccSign(text: string | Uint8Array, priKey: string | Uint8Array): Promise<Uint8Array>; static ohAegEccVerifySign(text: string | Uint8Array, pubKey: string | Uint8Array, sign: string | Uint8Array): Promise<boolean>; static ohAegEccVerifySignText(text: string | Uint8Array, pubKey: string | Uint8Array, sign: string | Uint8Array): Promise<boolean>; private static getUint8Array; private static Base64ToUint8Array; } export declare class EccKeyPair { publicKey: any; privateKey: any; constructor(publicKey: any, y43: any); } 