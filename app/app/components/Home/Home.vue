<template src='./Home.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Home.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";

  export default {
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      }
    }
  };
</script>
