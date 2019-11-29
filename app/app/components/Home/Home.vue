<template src='./Home.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Home.scss" lang="scss">
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
      console.log('Value: ', AppService.default.value);
      AppService.default.value = AppService.default.value + 1;
    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      }
    }
  };
</script>
