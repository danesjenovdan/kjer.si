import Vue from "nativescript-vue";
import {Mapbox} from 'nativescript-mapbox'
import Splash from "./components/Splash/Splash";
import Discover from "./components/Discover/Discover";
import {MapView} from "nativescript-google-maps-sdk";
import FontIcon from 'nativescript-vue-fonticon'
import * as Shadow from './directives/shadow';
import * as AnimateIn from './directives/animate-in';
import NSVueShadow from 'nativescript-vue-shadow'

// Vue.config.silent = false;

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('MapBox', () => Mapbox);
Vue.registerElement('lottie-view', () => require('nativescript-lottie').LottieView);

Vue.use(FontIcon, {
  debug: false, // <-- Optional. Will output the css mapping to console.
  paths: {
    ion: './fonts/ionicons.css'
  }
});

Vue.use(NSVueShadow);
// Vue.directive('customShadow', Shadow.default);
Vue.directive('animateIn', AnimateIn.default);

new Vue({

  template: `
        <Frame>
            <Discover />
<!--            <Splash />-->
        </Frame>`,

  components: {
    Splash,
    Discover
  }
}).$start();
