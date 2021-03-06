<template src='./Discover.html'>
</template>

<!-- Add 'scoped' attribute to limit CSS to this component only -->
<style scoped src='./Discover.scss' lang='scss'>
</style>

<script>


  import {Marker, Position, Circle} from 'nativescript-google-maps-sdk';
  import * as utils from '@nativescript/core/utils/utils';
  import {Color} from '@nativescript/core/color';
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
        locationReceived: false,
        limitMeters: 500,
        zoom: 15,
        minZoom: 0,
        maxZoom: 22,
        roomMarkers: [],
        bearing: 0,
        tilt: 0,
        mapView: null,
        screenHeight: 0,
        screenWidth: 0,
        currentPageState: null,
        rooms: [],
        selectedRoom: null,
        selectedMarker: null,
        PAGE_STATES: {
          MAP: 'MAP',
          LIST: 'LIST',
          NEW_ROOM_LOCATION_SETUP: 'NEW_ROOM_LOCATION_SETUP',
          NEW_ROOM_CATEGORY_SELECT: 'NEW_ROOM_CATEGORY_SELECT'
        },
        newRoom: {
          location: null,
          radius: 200,
          categoryId: null,
          name: null
        },
        rangeCircle: null,
        limitCircle: null,
        lastMapCamera: null,
        joiningRoom: false,
      }
    },
    async mounted() {

      this.currentPageState = this.PAGE_STATES.MAP;
      this.$refs.pageRef.nativeView.actionBarHidden = true;

      while (this.screenHeight === 0) {
        await new Promise((resolve) => setTimeout(resolve, 100));
        let mapContainer = this.$refs.mapContainer;

        UiService.default.layoutHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        UiService.default.layoutWidth = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredWidth());
        this.screenHeight = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredHeight());
        this.screenWidth = utils.layout.toDeviceIndependentPixels(mapContainer.nativeView.getMeasuredWidth());
      }

    },
    methods: {

      async updateRoomsInRadius(lat, lng) {

        this.selectedMarker = null;
        this.selectedRoom = null;

        try {
          const rooms = await ApiService.default.getRoomsInRadius(lat, lng);

          if (this.roomMarkers && this.roomMarkers.length) {
            this.mapView.removeMarker(...this.roomMarkers);
          }

          this.roomMarkers = rooms.map((room) => {
            room.type = 'ROOM';
            return this.createMarker(room.lat, room.lng, 'room_pin', null, [0.5, 1], room)
          });

        } catch (e) {
          console.log('Get rooms error123: ', e.response.data);
        }

      },

      onLoaded() {
        this.updateRoomsAroundMe();
      },

      async updateRoomsAroundMe() {
        this.updateRoomsInRadius(this.location.latitude, this.location.longitude);
      },

      onMarkerSelected(event) {

        const userData = event.marker.userData;

        if (userData.type === 'ROOM') {
          const room = userData;

          if (this.selectedRoom !== room) {
            this.deselectSelectedMarker();

            this.selectedRoom = room;
            this.selectedMarker = this.roomMarkers.filter((roomMarker) => roomMarker.userData.id === room.id)[0];
            this.selectedMarker.icon = 'room_pin_selected';
          }
        }
      },

      onCameraChanged(evt) {

        this.lastMapCamera = evt.camera;

        if (this.currentPageState === this.PAGE_STATES.NEW_ROOM_LOCATION_SETUP) {

          const distance = MapService.default.distance(
            this.location.latitude,
            this.location.longitude,
            this.lastMapCamera.latitude,
            this.lastMapCamera.longitude,
            'K'
          );

          if (distance && distance > this.limitMeters / 1000) {
            UiService.default.showToast('Ups, novo sobo moraš ustvariti znotraj z rdečo oznečenega kroga.');
            return;
          }

          console.log('DISTANCE: ', distance);

          this.drawRangeCircle(true);
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

        setTimeout(() => {
          this.deselectSelectedMarker();
        });

      },

      onCreateTap() {

        this.selectedRoom = null;
        this.selectedMarker = null;
        this.rangeCircle = null;
        this.roomMarkers = [];
        this.mapView.clear();

        setTimeout(() => {
          this.currentPageState = this.PAGE_STATES.NEW_ROOM_LOCATION_SETUP;
          this.mapView.mapAnimationsEnabled = false;
          this.mapView.latitude = this.location.latitude;
          this.mapView.longitude = this.location.longitude;
          this.drawLimitCircle();
          this.drawRangeCircle();
          this.mapView.mapAnimationsEnabled = true;
        });

        // this.deselectSelectedMarker();

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

      drawLimitCircle() {

        const limitCircle = new Circle();

        limitCircle.center = Position.positionFromLatLng(this.location.latitude, this.location.longitude);
        limitCircle.visible = true;
        limitCircle.radius = this.limitMeters;
        limitCircle.fillColor = new Color('#05AC1700');
        limitCircle.strokeColor = new Color('#ac4400');
        limitCircle.strokeWidth = 2;

        this.limitCircle = limitCircle;

        this.mapView.addCircle(limitCircle);

      },

      drawRangeCircle(forceRedraw = false) {

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

      async onCardTap(event) {

        if (!this.joiningRoom) {
          this.joiningRoom = true;
          try {
            const room = await ApiService.default.joinRoom(this.selectedRoom.id);
          } catch (e) {
            console.log('Join room error: ', e.response.data);
          }

          this.$navigateTo(Chat, {
            transition: {
              name: 'slideLeft',
              duration: 300,
              curve: 'easeInOut'
              // curve: cubicBezier(0.175, 0.885, 0.32, 1.275)
            },
            props: {
              roomId: this.selectedRoom.id,
              roomName: this.selectedRoom.name
            }
          });
          setTimeout(() => {
            this.joiningRoom = false;
          }, 400);
        }
      },

      onCloseCreateRoom() {
        if (this.rangeCircle) {
          this.mapView.removeShape(this.rangeCircle);
          this.rangeCircle = null;
        }
        if (this.limitCircle) {
          this.mapView.removeShape(this.limitCircle);
          this.limitCircle = null;
        }
        this.currentPageState = this.PAGE_STATES.MAP;
        this.setupMyLocation();

        this.mapView.mapAnimationsEnabled = false;
        this.mapView.latitude = this.location.latitude;
        this.mapView.longitude = this.location.longitude;
        this.mapView.mapAnimationsEnabled = true;
        this.updateRoomsAroundMe();

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
        this.updateRoomsAroundMe();

      },

      async onCategoryCreateSelect(category) {

        this.newRoom.categoryId = category.id;
        this.newRoom.name = category.name;

        console.log('New room: ', this.newRoom.name);

        let indicator;

        try {

          indicator = UiService.default.showLoadingIndicator('Ustvarjam sobo...');

          const room = await ApiService.default.createRoom(
            this.newRoom.name,
            this.newRoom.location.latitude,
            this.newRoom.location.longitude,
            this.newRoom.radius,
            this.newRoom.categoryId
          );
          indicator.hide();
          UiService.default.showToast('Soba ustvarjena!');
          this.onCloseCategoryListTap();
          this.updateRoomsAroundMe();

          room.type = 'ROOM';

          this.roomMarkers.push(this.createMarker(room.lat, room.lng, 'room_pin', null, [0.5, 1], room));

        } catch (e) {
          indicator.hide();
          console.log('Create room error: ', e.response.data);
        }

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

      onRoomTap(room) {

        this.onCloseListTap();

        this.deselectSelectedMarker();

        this.mapView.latitude = room.lat;
        this.mapView.longitude = room.lng;

        const marker = this.roomMarkers.filter((marker) => marker.userData.id === room.id)[0];

        this.selectedMarker = marker;
        this.selectedRoom = room;

        marker.icon = 'room_pin_selected';
      },

      onSliderValueChange(evt) {

        this.newRoom.radius = evt.value;
        this.drawRangeCircle();

      },

      setupMyLocation() {

        if (!this.mapView) {
          return;
        }

        this.locationReceived = true;

        // this.createMarker(this.location.latitude, this.location.longitude, 'my_location_pin');

      },

      createMarker(latitude, longitude, iconName, title, anchor, data) {

        const marker = new Marker();

        marker.userData = data;
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

        return marker;

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

      async onMapReady(event) {
        // console.log('Map ready!');
        this.mapView = event.object;
        this.mapView.settings.myLocationButtonEnabled = true;
        this.mapView.settings.mapToolbarEnabled = false;
        this.mapView.myLocationEnabled = true;
        this.mapView.setStyle(MapService.default.lightMapStyle);

        if (LocationService.default.location.latitude) {
          this.location.latitude = LocationService.default.location.latitude;
          this.location.longitude = LocationService.default.location.longitude;
          await this.setupMyLocation();
        } else {
          await this.requestLocation();
        }

        this.updateRoomsAroundMe();

      },

      deselectSelectedMarker() {
        if (this.selectedMarker) {
          this.selectedMarker.icon = 'room_pin';
          this.selectedMarker = null;
          this.selectedRoom = null;
        }
      },

      onCoordinateTapped() {

        this.deselectSelectedMarker();

      }
    }
  };

</script>
