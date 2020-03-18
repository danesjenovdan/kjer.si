<template src='./MapCard.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapCard.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as ApiService from '../../../services/api.service';

  export default {
    props: {
      room: null
    },
    data() {
      return {
        room: this.room
      };
    },
    mounted() {


    },
    methods: {
      onOpenTap() {
        this.$emit('tap', {});
      }
    }
  };
</script>
