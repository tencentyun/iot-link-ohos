import type { SignAlg } from "./p1"; import type { SignHandler } from "./m2"; import type { VerifyHandler } from "./n2"; export declare abstract class Signer { protected signAlg: SignAlg; protected signHandler: SignHandler; protected verifyHandler: VerifyHandler; constructor(m45: SignAlg); getSignHandler(): SignHandler; getVerifyHandler(): VerifyHandler; } 