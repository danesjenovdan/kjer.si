<template src='./Events.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Events.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import * as AppService from '../../services/app.service';

  export default {
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted(){
      let pageContainer = this.$refs.appContainer;
      AppService.default.screen.height = pageContainer.nativeView.getMeasuredHeight();
      AppService.default.screen.width = pageContainer.nativeView.getMeasuredWidth();
    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      }
    }
  };
</script>
