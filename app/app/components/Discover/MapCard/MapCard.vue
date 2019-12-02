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
    data() {
      return {};
    },
    mounted() {

    },
    methods: {
      onOpenTap() {

        this.$emit('tap', {});

        // try {
        //
        //   console.log('Uid: ', AppService.default.uid);
        //
        //   const response = await ApiService.default.post('/users', {
        //     user: {
        //       uid: AppService.default.uid,
        //       nickname: 'Francis'
        //     }
        //   });
        //   console.log('Response status: ', response.status);
        // } catch (e) {
        //   console.log('Error: ', e);
        // }
      },
      async onDeleteTap() {
        try {

          console.log('Uid: ', AppService.default.uid);

          const response = await ApiService.default.delete(`/users/${AppService.default.uid}`);
          console.log('Response status: ', response.status);
        } catch (e) {
          console.log('Error: ', e);
        }
      }
    }
  };
</script>
