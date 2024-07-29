import { DataProcessor } from "../h2"; declare enum MdAlg { SHA256 = "SHA256", SHA384 = "SHA384", SHA512 = "SHA512", SM3 = "SM3" } export declare class Md extends DataProcessor { private mdAlg; constructor(l45: MdAlg); static SHA256(): Md; static SHA384(): Md; static SHA512(): Md; static SM3(): Md; to(): Promise<Uint8Array>; } export {}; 