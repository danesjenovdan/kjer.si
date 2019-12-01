<template src='./Splash.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Splash.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import * as AppService from '../../services/app.service';
  import * as MapService from '../../services/map.service';
  import * as LocationService from '../../services/location.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as platform from 'tns-core-modules/platform';
  import * as geolocation from "nativescript-geolocation";
  import {Accuracy} from "tns-core-modules/ui/enums"; // used to describe at what accuracy the location should be get

  // Websockets import is required for Phx to work
  // there's a modification in the phoenix.js file that requires nativescript-websockets to set the global WebSocket variable
  import * as websockets from 'nativescript-websockets';

  const Phx = require("../../assets/js/phoenix"); // <- this depends on where you put your file

  export default {
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    data() {
      return {
        backgroundLocation: {
          latitude: 46.049131,
          longitude: 14.507172
        },
        location: null,
        locationError: null,
        get mapBackground() {
          if (platform.isAndroid) {
            const url = `${MapService.default.getLightMap(this.backgroundLocation.latitude,
              this.backgroundLocation.longitude,
              platform.screen.mainScreen.widthPixels,
              platform.screen.mainScreen.heightPixels)}&key=AIzaSyCNqY7adTokDIeHbgGH-lx8Xw7Gz_v6dRA`;

            return url;
          } else {
            const url = encodeURI(`${MapService.default.getLightMap(this.backgroundLocation.latitude,
              this.backgroundLocation.longitude,
              platform.screen.mainScreen.widthPixels,
              platform.screen.mainScreen.heightPixels)}&key=AIzaSyCNqY7adTokDIeHbgGH-lx8Xw7Gz_v6dRA`);
            return url;
          }
        }
      }
    },
    mounted() {

      let pageContainer = this.$refs.appContainer;
      this.$refs.pageRef.nativeView.actionBarHidden = true;

      setTimeout(geolocation.enableLocationRequest, 1000);

      setTimeout(() => {
        AppService.default.screen.height = utils.layout.toDeviceIndependentPixels(pageContainer.nativeView.getMeasuredHeight());
        AppService.default.screen.width = utils.layout.toDeviceIndependentPixels(pageContainer.nativeView.getMeasuredWidth());
        console.log('AppService.default.screen: ', AppService.default.screen);
      }, 200);

      this.requestLocation();

    },
    methods: {
      async requestLocation() {

        try {
          this.locationError = null;
          const location = await LocationService.default.requestLocation();
          await new Promise(resolve => setTimeout(resolve, 1000));
          this.location = location;
          this.backgroundLocation.latitude = location.latitude;
          this.backgroundLocation.longitude = location.longitude;
        } catch (e) {
          this.location = null;
          this.locationError = e;
        }

      },
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover, {
          transition: {
            name: 'slideLeft',
            duration: 300,
            curve: 'easeInOut'
            // curve: cubicBezier(0.175, 0.885, 0.32, 1.275)
          }
        });
      }
    }
  };
</script>
