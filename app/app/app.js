import Vue from "nativescript-vue";
import {Mapbox} from 'nativescript-mapbox'
import Splash from "./components/Splash/Splash";
import {MapView} from "nativescript-google-maps-sdk";
import FontIcon from 'nativescript-vue-fonticon'

Vue.config.silent = false;

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('MapBox', () => Mapbox);

Vue.use(FontIcon, {
    debug: true, // <-- Optional. Will output the css mapping to console.
    paths: {
        ion: './fonts/ionicons.css'
    }
});

new Vue({

    template: `
        <Frame>
            <Splash />
        </Frame>`,

    components: {
        Splash
    }
}).$start();
