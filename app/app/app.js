import Vue from 'nativescript-vue';
import {Mapbox} from '@nativescript-community/ui-mapbox'
import Splash from './components/Splash/Splash';
import Discover from './components/Discover/Discover';
import Chat from './components/Chat/Chat';
import {MapView} from 'nativescript-google-maps-sdk';
import FontIcon from 'nativescript-vue-fonticon'
import * as Shadow from './directives/shadow';
import * as AnimateIn from './directives/animate-in';
import NSVueShadow from 'nativescript-vue-shadow-ns-7'
import * as AutoFocus from '~/directives/auto-focus';
import * as KeyboardSend from '~/directives/keyboard-send';
import * as localStorage from 'nativescript-localstorage';
import * as UserService from './services/user.service';
import * as ApiService from './services/api.service';
import * as application from '@nativescript/core/application';
// Vue.config.silent = false;

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('MapBox', () => Mapbox);
Vue.registerElement(
  'LottieView',
  () => require('@nativescript-community/ui-lottie').LottieView
);
// Vue.registerElement('lottie-view', () => require('nativescript-lottie').LottieView);
Vue.registerElement('Rippler', () => require('nativescript-ripple').Ripple);

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
});

Vue.use(NSVueShadow);
// Vue.directive('customShadow', Shadow.default);
Vue.directive('animateIn', AnimateIn.default);
Vue.directive('autoFocus', AutoFocus.default);
Vue.directive('keyboardSend', KeyboardSend.default);

new Vue({

  template: `
        <Frame>
<!--            <Discover />-->
            <Splash />
<!--            <Chat/>-->
        </Frame>`,

  components: {
    Splash,
    Discover,
    Chat
  }
}).$start();
