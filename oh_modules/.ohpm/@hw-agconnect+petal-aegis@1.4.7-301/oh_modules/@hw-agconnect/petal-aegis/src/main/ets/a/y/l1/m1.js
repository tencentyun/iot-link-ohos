export class Signer { constructor(z7) { this.signAlg = z7; } getSignHandler() { return this.signHandler; } getVerifyHandler() { return this.verifyHandler; } } 