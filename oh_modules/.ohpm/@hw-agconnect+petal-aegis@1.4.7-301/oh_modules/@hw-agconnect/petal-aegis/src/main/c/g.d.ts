export declare class AegHmac { private static TAG; private static KEY_LEN; static ohAegHmacSha256Text(text: string | Uint8Array, key: string | Uint8Array): Promise<Uint8Array>; static ohAegHmacSha256TextHex(text: string | Uint8Array, key: string | Uint8Array): Promise<string>; static ohAegHmacSha256Hex(i43: string | Uint8Array, key: string | Uint8Array): Promise<string>; static ohAegHmacSha256Uint8Array(h43: string | Uint8Array, key: string | Uint8Array): Promise<Uint8Array>; } 