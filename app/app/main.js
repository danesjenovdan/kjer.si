import Vue from 'nativescript-vue';
import Splash from './components/Splash/Splash';
import Discover from './components/Discover/Discover';
import Chat from './components/Chat/Chat';
import {MapView} from 'nativescript-google-maps-sdk';
import FontIcon from 'nativescript-vue-fonticon'
import * as Shadow from './directives/shadow';
import * as AnimateIn from './directives/animate-in';
import NSVueShadow from 'nativescript-vue-shadow'
import * as AutoFocus from '~/directives/auto-focus';
import * as KeyboardSend from '~/directives/keyboard-send';
import * as localStorage from 'nativescript-localstorage';
import * as UserService from './services/user.service';
import * as ApiService from './services/api.service';
import * as application from 'tns-core-modules/application';
import {localize} from 'nativescript-localize';
import NewEvent from '~/components/NewEvent/NewEvent';

import store from './store'
import VueDevtools from 'nativescript-vue-devtools'

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('lottie-view', () => require('nativescript-lottie').LottieView);
Vue.registerElement('Rippler', () => require('nativescript-ripple').Ripple);

Vue.filter('L', localize);

Vue.use(FontIcon, {
  debug: false, // <-- Optional. Will output the css mapping to console.
  paths: {
    ion: './fonts/ionicons.css'
  }
});

application.on(application.launchEvent, async (args) => {
  UserService.default.initLocalUserData();
  if (UserService.default.user) {
    ApiService.default.initSocket();
  }

  const firebase = require('nativescript-plugin-firebase');

  firebase.init({
    // Optionally pass in properties for database, authentication and cloud messaging,
    // see their respective docs.
    onPushTokenReceivedCallback: function (token) {
      console.log("Firebase push token: " + token);
    }
  }).then(
    function () {
      console.log('firebase.init done');
    },
    function (error) {
      console.log('firebase.init error: ' + error);
    }
  );
});

Vue.use(NSVueShadow);
// Vue.directive('customShadow', Shadow.default);
Vue.directive('animateIn', AnimateIn.default);
Vue.directive('autoFocus', AutoFocus.default);
Vue.directive('keyboardSend', KeyboardSend.default);

if (TNS_ENV !== 'production') {
  Vue.use(VueDevtools)
}

// Prints Vue logs when --env.production is *NOT* set while building
// Vue.config.silent = (TNS_ENV === 'production')
// Prints Colored logs when --env.production is *NOT* set while building
// Vue.config.debug = (TNS_ENV !== 'production')

new Vue({
  store,
  render: h => h('frame', [h(Splash)])
}).$start();
