import { NativeScriptConfig } from '@nativescript/core'

export default {
  id: 'si.djnd.kjersi',
  appPath: 'app',
  appResourcesPath: 'app/App_Resources',
  android: {
    v8Flags: '--expose_gc',
    markingMode: 'none',
  },
  useLegacyWorkflow: false,
} as NativeScriptConfig
