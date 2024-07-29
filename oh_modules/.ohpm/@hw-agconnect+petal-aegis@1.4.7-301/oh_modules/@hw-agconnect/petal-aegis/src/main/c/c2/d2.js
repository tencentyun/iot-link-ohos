import hilog from '@ohos.hilog'; const DOMAIN = 0xAEAE; const TAG = 'Aegis-crypto'; const FORMAT = '%{public}s'; export class AegLogger { static info(...args) { hilog.info(DOMAIN, TAG, FORMAT, AegLogger.appendArgs(args)); } static warn(...args) { hilog.warn(DOMAIN, TAG, FORMAT, AegLogger.appendArgs(args)); } static error(...args) { hilog.error(DOMAIN, TAG, FORMAT, AegLogger.appendArgs(args)); } static appendArgs(args) { let t40 = ''; if (args.length > 1) { for (let u40 = 0; u40 < args.length; u40++) { t40 = t40 + args[u40] + ' '; } } else { t40 = args[0]; } return t40; } } 