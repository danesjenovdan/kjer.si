<template src='./MapFabs.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapFabs.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as ApiService from '../../../services/api.service';

  export default {
    name: 'map-card',
    data() {
      return {};
    },
    mounted() {

    },
    methods: {
      onListTap() {
        this.$emit('listTap');
      },
      onCreateTap() {
        this.$emit('createTap');
      }
    }
  };
</script>
