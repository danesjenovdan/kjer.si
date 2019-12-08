<template src='./Chat.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Chat.scss" lang="scss">
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
    mounted() {
      this.$refs.pageRef.nativeView.actionBarHidden = true;
    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      }
    }
  };
</script>
