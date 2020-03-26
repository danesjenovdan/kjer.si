import * as app from 'tns-core-modules/application';
import * as utils from 'tns-core-modules/utils/utils';

const AutoFocus = {
  inserted(el) {
    setTimeout(() => {

      el._nativeView.focus();

      // const dialogFragment = app.android
      //   .foregroundActivity
      //   .getFragmentManager()
      //   .findFragmentByTag('dialog');
      // if (dialogFragment) {
      //   utils.ad.dismissSoftInput(dialogFragment.getDialog().getCurrentFocus());
      // } else {
      //   utils.ad.dismissSoftInput();
      // }

    }, 300);
  },
};

export default AutoFocus;
