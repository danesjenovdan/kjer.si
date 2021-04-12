<template src='./MapCard.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapCard.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from '@nativescript/core/utils/utils';
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
