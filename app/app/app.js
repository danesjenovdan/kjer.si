import Vue from "nativescript-vue";
import {Mapbox} from 'nativescript-mapbox'
import Home from "./components/Home/Home";
import { MapView } from "nativescript-google-maps-sdk";
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
            <Home />
        </Frame>`,

    components: {
        Home
    }
}).$start();
