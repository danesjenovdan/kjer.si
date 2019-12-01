<template src='./Discover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Discover.scss" lang="scss">
</style>

<script>

  import Chat from '../Chat/Chat';
  import {Marker, Position} from "nativescript-google-maps-sdk";
  import MapFabs from './MapFabs/MapFabs.vue';
  import MapListPopover from './MapListPopover/MapListPopover.vue';
  import MapCard from './MapCard/MapCard.vue';
  import * as MapService from '../../services/map.service';
  import * as LocationService from '../../services/location.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as ApiService from '../../services/api.service';
  import * as websockets from 'nativescript-websockets';
  import * as Phx from '../../assets/js/phoenix';

  export default {
    components: {
      MapCard,
      MapFabs,
      MapListPopover
    },
    data() {
      return {
        location: {
          latitude: 46.049131,
          longitude: 14.507172,
        },
        zoom: 15,
        minZoom: 0,
        maxZoom: 22,
        bearing: 0,
        tilt: 0,
        mapView: undefined,
        screenHeight: 0,
        screenWidth: 0,
        currentPageState: null,
        PAGE_STATES: {
          MAP: 'MAP',
          LIST: 'LIST',
          CREATE: 'CREATE'
        }
      }
    },
    mounted() {

      this.currentPageState = this.PAGE_STATES.MAP;

      let mapContainer = this.$refs.mapContainer;
      this.$refs.pageRef.nativeView.actionBarHidden = true;
      setTimeout(() => {
        this.$data.screenHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        this.$data.screenWidth = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredWidth());
      }, 300);

      // to create a socket connection
      var socket = new Phx.Socket("http://192.168.3.193:4000/socket", {params: {userToken: "123"}});
      socket.connect();
      socket.onOpen((state) => {
        // console.log('Socket: ', socket.isConnected());
      });

      // to create a channel
      const channel = socket.channel("room:lobby", {});

      // listen for "shout" events
      channel.on("shout", payload => {
        // do your own thing
        // alert(payload.body);
      });

      // join the channel, with success and failure callbacks
      channel.join()
        .receive("ok", resp => console.log("Joined channel successfully", resp))
        .receive("error", resp => console.log("Failed to join channel", resp));

      // to send messages
      channel.push("shout", {body: "This is a shoutout!"});

      // to leave a channel
      // channel.leave();

    },
    methods: {
      onListTap() {
        this.currentPageState = this.PAGE_STATES.LIST;
      },

      onCreateTap() {
        // this.currentPageState = this.PAGE_STATES.CREATE;
      },

      onCardTap() {

        this.$navigateTo(Chat, {
          transition: {
            name: 'slideTop',
            duration: 300,
            curve: 'easeInOut'
            // curve: cubicBezier(0.175, 0.885, 0.32, 1.275)
          }
        });

      },

      onCloseListTap() {
        this.currentPageState = this.PAGE_STATES.MAP;
      },

      setupMyLocation() {
        const marker = new Marker();

        marker.position = Position.positionFromLatLng(this.location.latitude, this.location.longitude);
        marker.title = 'Moja lokacija';
        marker.icon = 'my_location_pin';
        this.mapView.addMarker(marker);
      },

      async requestLocation() {
        try {
          const location = await LocationService.default.requestLocation();
          this.location.latitude = location.latitude;
          this.location.longitude = location.longitude;
          this.mapView.latitude = location.latitude;
          this.mapView.longitude = location.longitude;
          this.setupMyLocation();
        } catch (e) {
          console.log('Location error: ', e);
        }
      },

      onMapReady(event) {
        console.log("Map ready!");
        this.mapView = event.object;
        this.mapView.setStyle(MapService.default.lightMapStyle);

        if (LocationService.default.location.latitude) {
          this.location.latitude = LocationService.default.location.latitude;
          this.location.longitude = LocationService.default.location.longitude;
          this.setupMyLocation();
        } else {
          this.requestLocation();
        }
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
