import * as Toast from 'nativescript-toast';
import {
  LoadingIndicator,
  Mode,
  OptionsCommon
} from '@nstudio/nativescript-loading-indicator';

export default new class {

  layoutHeight = 0;
  layoutWidth = 0;

  showToast(text) {
    Toast.makeText(text, 'long').show();
  }

  showLoadingIndicator(message, details = '') {

    const indicator = new LoadingIndicator();

    const options = {
      message: message,
      details: details,
      dimBackground: true,
      color: '#22AC9B', // color of indicator and labels
      mode: Mode.Indeterminate, // see options below
      android: {
        cancelable: false,
        cancelListener: function (dialog) {
          console.log('Loading cancelled');
        }
      },
      ios: {
        square: false
      }
    };

    indicator.show(options);

    return indicator;

  }

}
