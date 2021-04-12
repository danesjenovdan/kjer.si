import * as app from '@nativescript/core/application';
import * as utils from '@nativescript/core/utils/utils';

const AutoFocus = {
  inserted(el) {
    setTimeout(() => {

      el._nativeView.focus();

      const dialogFragment = app.android
        .foregroundActivity
        .getFragmentManager()
        .findFragmentByTag('dialog');
      if (dialogFragment) {
        utils.ad.dismissSoftInput(dialogFragment.getDialog().getCurrentFocus());
      } else {
        utils.ad.dismissSoftInput();
      }

    }, 300);
  },
};

export default AutoFocus;
