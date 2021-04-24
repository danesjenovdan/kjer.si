<template src='./MapListPopover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapListPopover.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from '@nativescript/core/utils';
  import * as ApiService from '../../../services/api.service';
  import * as UiService from '../../../services/ui.service';
  import * as LocationService from "../../../services/location.service";

  export default {
    data() {
      return {
        layoutHeight: UiService.default.layoutHeight,
        rooms: [],
        loadingRooms: true
      };
    },
    mounted() {

      const height = this.$refs.container.nativeView.getMeasuredHeight();
      this.getRooms();

    },
    methods: {
      onCloseListTap() {
        this.$emit('closeListTap');
      },

      async getRooms() {
        try {
          this.loadingRooms = true;
          this.rooms = await ApiService.default.getRoomsInRadius(LocationService.default.location.latitude, LocationService.default.location.longitude);
          this.loadingRooms = false;
        } catch (e) {
          console.log('Get rooms error: ', e.response.data);
        }
      },

      onRoomTap(room) {
        this.$emit('roomTap', room);
      },

      getDistanceToRoom(room) {

        const distance = LocationService.default.getDistance({
          lat: room.lat,
          lng: room.lng
        }, {
          lat: LocationService.default.location.latitude,
          lng: LocationService.default.location.longitude
        });

        let distanceText = distance.toFixed(0) + 'm';

        if (distance > 1000) {
          distanceText = (distance / 1000).toFixed(2) + 'km';
        }

        return distanceText;

      }
    }
  };
</script>
