<template src='./Discover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Discover.scss" lang="scss">
</style>

<script>


  import {Marker, Position, Circle} from "nativescript-google-maps-sdk";
  import * as utils from 'tns-core-modules/utils/utils';
  import {Color} from "tns-core-modules/color";
  import * as ApiService from '../../services/api.service';
  import * as websockets from 'nativescript-websockets';
  import * as Phx from '../../assets/js/phoenix';

  // Components
  import MapFabs from './MapFabs/MapFabs.vue';
  import MapListPopover from './MapListPopover/MapListPopover.vue';
  import MapCard from './MapCard/MapCard.vue';
  import Chat from '../Chat/Chat';
  import MapCategoryListPopover from './MapCategoryListPopover/MapCategoryListPopover';

  // Services
  import * as MapService from '../../services/map.service';
  import * as LocationService from '../../services/location.service';
  import * as UiService from '../../services/ui.service';


  export default {
    components: {
      MapCard,
      MapFabs,
      MapListPopover,
      MapCategoryListPopover,
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
        mapView: null,
        screenHeight: 0,
        screenWidth: 0,
        currentPageState: null,
        PAGE_STATES: {
          MAP: 'MAP',
          LIST: 'LIST',
          NEW_ROOM_LOCATION_SETUP: 'NEW_ROOM_LOCATION_SETUP',
          NEW_ROOM_CATEGORY_SELECT: 'NEW_ROOM_CATEGORY_SELECT'
        },
        newRoom: {
          location: null,
          radius: 200
        },
        rangeCircle: null,
        lastMapCamera: null
      }
    },
    mounted() {

      this.currentPageState = this.PAGE_STATES.MAP;
      this.$refs.pageRef.nativeView.actionBarHidden = true;

      setTimeout(() => {

        let mapContainer = this.$refs.mapContainer;

        UiService.default.layoutHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        UiService.default.layoutWidth = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredWidth());
        this.screenHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        this.screenWidth = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredWidth());

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

      onCameraChanged(evt) {

        // console.log('Camera changed: ', evt.camera);
        this.lastMapCamera = evt.camera;

        if (this.currentPageState === this.PAGE_STATES.NEW_ROOM_LOCATION_SETUP) {
          this.drawCircle(true);
        }

      },

      onListTap() {

        this.currentPageState = this.PAGE_STATES.LIST;

        this.mapView.padding = [
          utils.layout.toDevicePixels(this.screenHeight) - utils.layout.toDevicePixels(100),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0)
        ];

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.location.latitude;
        this.mapView.longitude = this.location.longitude;
        this.mapView.mapAnimationsEnabled = true;

        this.mapView.updateCamera();

      },

      onCreateTap() {
        this.mapView.clear();
        this.rangeCircle = null;
        this.currentPageState = this.PAGE_STATES.NEW_ROOM_LOCATION_SETUP;
        this.drawCircle();
      },

      catchGestureTap() {

      },

      confirmRangeTap() {

        this.newRoom.location = {
          latitude: this.lastMapCamera.latitude,
          longitude: this.lastMapCamera.longitude
        };

        this.mapView.clear();

        this.mapView.padding = [
          utils.layout.toDevicePixels(this.screenHeight) - utils.layout.toDevicePixels(100),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0)
        ];

        this.createMarker(this.newRoom.location.latitude, this.newRoom.location.longitude, 'room_pin', null, [0.5, 1]);

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.newRoom.location.latitude;
        this.mapView.longitude = this.newRoom.location.longitude;


        this.mapView.updateCamera();

        this.mapView.mapAnimationsEnabled = true;
        this.currentPageState = this.PAGE_STATES.NEW_ROOM_CATEGORY_SELECT;
        console.log('Confirm radius tap');

      },

      drawCircle(forceRedraw = false) {

        if (!this.lastMapCamera || !this.newRoom || !this.newRoom.radius) {
          console.log('Missing reference required for circle');
          return;
        }

        if (this.rangeCircle && !forceRedraw) {
          this.rangeCircle.radius = this.newRoom.radius;
          return;
        }

        if (forceRedraw && this.rangeCircle) {
          this.mapView.removeShape(this.rangeCircle);
        }

        const circle = new Circle();

        circle.center = Position.positionFromLatLng(this.lastMapCamera.latitude, this.lastMapCamera.longitude);
        circle.visible = true;
        circle.radius = this.newRoom.radius;
        circle.fillColor = new Color('#1122AC9B');
        circle.strokeColor = new Color('#22AC9B');
        circle.strokeWidth = 10;

        this.rangeCircle = circle;

        this.mapView.addCircle(circle);

      },

      onCardTap() {

        this.$navigateTo(Chat, {
          transition: {
            name: 'slideLeft',
            duration: 300,
            curve: 'easeInOut'
            // curve: cubicBezier(0.175, 0.885, 0.32, 1.275)
          }
        });

      },

      onCloseCreateRoom() {
        if (this.rangeCircle) {
          this.mapView.removeShape(this.rangeCircle);
          this.rangeCircle = null;
        }
        this.currentPageState = this.PAGE_STATES.MAP;
        this.setupMyLocation();

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.location.latitude;
        this.mapView.longitude = this.location.longitude;
        this.mapView.mapAnimationsEnabled = true;
      },

      onCloseCategoryListTap() {

        this.currentPageState = this.PAGE_STATES.MAP;
        this.mapView.clear();

        this.mapView.padding = [
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0)
        ];

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.location.latitude;
        this.mapView.longitude = this.location.longitude;
        this.mapView.mapAnimationsEnabled = true;

        this.setupMyLocation();

      },

      onCloseListTap() {

        this.currentPageState = this.PAGE_STATES.MAP;

        this.mapView.padding = [
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0),
          utils.layout.toDevicePixels(0)
        ];

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.location.latitude;
        this.mapView.longitude = this.location.longitude;
        this.mapView.mapAnimationsEnabled = true;

        this.setupMyLocation();

      },

      onSliderValueChange(evt) {

        this.newRoom.radius = evt.value;
        this.drawCircle();
        console.log('Range: ', this.newRoom.radius);

      },

      setupMyLocation() {

        if (!this.mapView) {
          return;
        }

        this.createMarker(this.location.latitude, this.location.longitude, 'my_location_pin');

      },

      createMarker(latitude, longitude, iconName, title, anchor) {

        const marker = new Marker();

        marker.position = Position.positionFromLatLng(latitude, longitude);
        if (anchor) {
          marker.anchor = anchor;
        }
        if (title) {
          marker.title = title;
        }
        if (iconName) {
          marker.icon = iconName;
        }
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
        // console.log("Map ready!");
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
