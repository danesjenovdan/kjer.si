<template src='./NewEvent.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./NewEvent.scss" lang="scss">
</style>


<script>

  import Discover from "../Discover/Discover";
  import Toggle from "../shared/Toggle/Toggle";
  import * as AppService from '../../services/app.service';

  export default {

    components: {
      Toggle
    },

    data() {
      return {
        title: '',
        description: '',
        limitedEvent: false,
        numSeats: 1,
        date: null,
        time: null
      }
    },

    computed: {
      message() {
        return "Blank {N}-Vue app";
      },
      seatsString() {

        const numSeats = Number(this.numSeats);

        if (numSeats === 0) {
          return 'Udeležencev';
        } else if (numSeats === 1) {
          return 'Udeleženec';
        } else if (numSeats === 2) {
          return 'Udeleženca';
        } else if (numSeats === 3 || numSeats === 4) {
          return 'Udeleženci';
        } else if (numSeats > 4) {
          return 'Udeležencev';
        }

        return 'Udeležencev';
      },
      isActive() {
        return this.title && this.description && this.date && this.time;
      },
      minDate() {
        return new Date();
      }
    },
    mounted() {
      let pageContainer = this.$refs.appContainer;
      AppService.default.screen.height = pageContainer.nativeView.getMeasuredHeight();
      AppService.default.screen.width = pageContainer.nativeView.getMeasuredWidth();

      this.$refs.pageRef.nativeView.actionBarHidden = true;
    },
    methods: {
      onDateChange(event) {
        console.log('New date: ', event.value);
        this.date = event.value;
      },
      onTimeChange(event) {
        console.log('New time: ', event.value);
        this.time = event.value;
      },
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      },
      onBackTap() {
        console.log('TAP: go back');
        this.$navigateBack();
      },
      onLimitedCheckedChange(value) {
        this.limitedEvent = value;
        console.log('Checked change: ', value);
      },
      onSeatsChange() {
        console.log('On seats change');
        if (this.numSeats > 10) {
          this.numSeats = 10;
        }
      }
    }
  };
</script>
