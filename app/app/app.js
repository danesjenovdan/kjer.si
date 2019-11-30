import Vue from "nativescript-vue";
import {Mapbox} from 'nativescript-mapbox'
import Splash from "./components/Splash/Splash";
import Discover from "./components/Discover/Discover";
import {MapView} from "nativescript-google-maps-sdk";
import FontIcon from 'nativescript-vue-fonticon'

Vue.config.silent = false;

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('MapBox', () => Mapbox);

Vue.use(FontIcon, {
    debug: false, // <-- Optional. Will output the css mapping to console.
    paths: {
        ion: './fonts/ionicons.css'
    }
});

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
