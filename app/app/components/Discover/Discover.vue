<template src='./Discover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Discover.scss" lang="scss">
</style>

<script>

  import {Marker, Position} from "nativescript-google-maps-sdk";
  import MapCard from './MapCard/MapCard.vue'
  import * as utils from 'tns-core-modules/utils/utils';

  export default {
    components: {
      MapCard
    },
    data() {
      return {
        latitude: -33.86,
        longitude: 151.20,
        zoom: 8,
        minZoom: 0,
        maxZoom: 22,
        bearing: 0,
        tilt: 0,
        mapView: undefined,
        screenHeight: 0
      }
    },
    mounted() {
      let mapContainer = this.$refs.mapContainer;
      this.$refs.pageContainer.nativeView.actionBarHidden = true;
      setTimeout(() => {
        this.$data.screenHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        console.log('pageContainer: ', utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight()));
      }, 200);
    },
    methods: {
      onMapReady(event) {
        console.log("Map ready!");
        this.mapView = event.object;
      },
      onCoordinateTapped() {
        const marker = new Marker();
        marker.position = Position.positionFromLatLng(-33.86, 151.20);
        marker.title = "Sydney";
        marker.snippet = "Australia";
        marker.userData = {index: 1};
        this.mapView.addMarker(marker);
      }
    }
  };
</script>
