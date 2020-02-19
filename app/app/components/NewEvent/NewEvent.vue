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
        limitedEvent: false,
        numSeats: 3
      }
    },

    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted() {
      let pageContainer = this.$refs.appContainer;
      AppService.default.screen.height = pageContainer.nativeView.getMeasuredHeight();
      AppService.default.screen.width = pageContainer.nativeView.getMeasuredWidth();

      this.$refs.pageRef.nativeView.actionBarHidden = true;
    },
    methods: {
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
      }
    }
  };
</script>
