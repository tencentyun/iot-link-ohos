
export class IoTVideoMessageType {
  static XP2P_READY: number= 1004;
  static XP2P_DISCONNECT: number= 1003;
}

export interface OnStateListener {
  onReady:()=>void;
  onDisconnect:()=>void;
}