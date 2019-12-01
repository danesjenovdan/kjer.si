<template src='./MapListPopover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapListPopover.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from 'tns-core-modules/utils/utils';
  import * as ApiService from '../../../services/api.service';
  import * as UiService from '../../../services/ui.service';

  export default {
    name: 'map-card',
    data() {
      return {
        layoutHeight: UiService.default.layoutHeight
      };
    },
    mounted() {

      const height = this.$refs.container.nativeView.getMeasuredHeight();

    },
    methods: {
      onCloseListTap() {
        this.$emit('closeListTap');
      }
    }
  };
</script>
