import * as platform from 'tns-core-modules/platform';

const KeyboardSend = {
  inserted(el) {

    if (platform.isAndroid) {
      setTimeout(() => {
        const view = el.nativeView.nativeViewProtected;
        // view.setSingleLine();
        view.setHyphenationFrequency(android.text.Layout.HYPHENATION_FREQUENCY_NONE);
        // view.setImeOptions(android.view.inputmethod.EditorInfo.IME_ACTION_SEND);
      }, 200);
    }

  },
};

export default KeyboardSend;
