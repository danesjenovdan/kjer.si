<template src='./Splash.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Splash.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import * as AppService from '../../services/app.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as websockets from 'nativescript-websockets';

  const Phx = require("../../assets/js/phoenix"); // <- this depends on where you put your file

  export default {
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted() {

      let pageContainer = this.$refs.appContainer;

      setTimeout(() => {
        AppService.default.screen.height = utils.layout.toDeviceIndependentPixels(pageContainer.nativeView.getMeasuredHeight());
        AppService.default.screen.width = utils.layout.toDeviceIndependentPixels(pageContainer.nativeView.getMeasuredWidth());
        console.log('AppService.default.screen: ', AppService.default.screen);
      }, 200);

    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      }
    }
  };
</script>
