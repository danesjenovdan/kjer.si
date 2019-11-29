import Vue from "nativescript-vue";
import {Mapbox} from 'nativescript-mapbox'
import Home from "./components/Home/Home";
import { MapView } from "nativescript-google-maps-sdk";

Vue.config.silent = false;

Vue.registerElement('MapView', () => MapView);
Vue.registerElement('MapBox', () => Mapbox);

new Vue({

    template: `
        <Frame>
            <Home />
        </Frame>`,

    components: {
        Home
    }
}).$start();
