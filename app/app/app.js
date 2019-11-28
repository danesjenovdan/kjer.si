import Vue from "nativescript-vue";

import Home from "./components/Home/Home";

new Vue({

    template: `
        <Frame>
            <Home />
        </Frame>`,

    components: {
        Home
    }
}).$start();
