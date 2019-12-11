<template src='./Chat.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Chat.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import * as AppService from '../../services/app.service';
  import * as app from 'tns-core-modules/application';
  import * as platform from 'tns-core-modules/platform';

  export default {
    data() {
      return {
        showMenu: false
      }
    },
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted() {

      if (platform.isAndroid) {
        const window = app.android.startActivity.getWindow();
        window.setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
      }

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
      onContainerTap() {
        this.showMenu = false;
      },
      onMenuTap() {
        console.log('TAP: open menu');
        setTimeout(() => {
          this.showMenu = true;
        }, 10);
      },
      onEventsTap() {
        console.log('TAP: events');
      }
    }
  };

</script>
