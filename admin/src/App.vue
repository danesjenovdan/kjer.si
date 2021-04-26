<template>
  <div class="container">
    <rooms :token="token" @selected="selectRoom" />
    <messages v-if="selectedRoomId" :room-id="selectedRoomId" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import api from './services/api.service';

import Rooms from './components/Rooms.vue';
import Messages from './components/Messages.vue';

export default defineComponent({
  name: 'App',
  components: { Rooms, Messages },
  data () {
    return {
      token: '',
      selectedRoomId: null,
    };
  },
  async beforeCreate() {
    this.token = await api.getToken();
  },
  methods: {
    selectRoom(roomId) {
      this.selectedRoomId = roomId;
    },
  },
})
</script>

<style lang="scss">
</style>
