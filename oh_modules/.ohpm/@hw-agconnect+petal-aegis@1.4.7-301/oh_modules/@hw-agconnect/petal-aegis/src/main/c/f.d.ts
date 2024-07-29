export declare class AegSha256 { private static TAG; private static SHA256; static ohAegSha256TextHex(text: string | Uint8Array): Promise<string>; static ohAegSha256Text(text: string | Uint8Array): Promise<Uint8Array>; static ohAegSha256Hex(text: string | Uint8Array): Promise<string>; static ohAegSha256Uint8Array(text: string | Uint8Array): Promise<Uint8Array>; static ohAegFileSha256Hex(filePath: string): Promise<string>; static ohAegFileSha256(filePath: string): Promise<Uint8Array>; } 