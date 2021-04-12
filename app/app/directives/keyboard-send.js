import * as platform from '@nativescript/core/platform';

const KeyboardSend = {
  inserted(el) {

    if (platform.isAndroid) {
      setTimeout(() => {
        const view = el.nativeView.nativeViewProtected;
        view.setSingleLine();
        view.setImeOptions(android.view.inputmethod.EditorInfo.IME_ACTION_SEND);
      }, 200);
    }

  },
};

export default KeyboardSend;
