<template>
  <div class="grid grid-cols-1">
    <div class="grid grid-cols-6">
      <h1>id</h1>
      <h1>name</h1>
      <h1>category name</h1>
      <h1>coordinates</h1>
      <h1>number of users</h1>
      <!-- <h1>DANGER ZONE</h1> -->
      <h1>Actions</h1>
    </div>
    <div v-for="room in sortedRooms" :key="room.id">
      <room :room="room" @deleted="refreshRooms" @selected="$emit('selected', room.id)" />
    </div>
    <button
        class="rounded-full my-2 py-2 px-3 bg-green-500 text-white"
        @click="refreshRooms"
    >REFRESH ROOMS</button>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'
import api from '../services/api.service';

import Room from '../components/Room.vue';

export default defineComponent({
  name: 'Rooms',
  components: {
    Room,
  },
  props: {
    token: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      rooms: [],
    };
  },
  computed: {
    sortedRooms() {
      return this.rooms.sort((a, b) => b.users.length - a.users.length);
    },
  },
  async mounted() {
    this.refreshRooms();
  },
  methods: {
    async refreshRooms() {
      console.log('refreshing rooms');
      const token = await api.getToken();
      this.rooms = await api.getRooms(token);
    },
  },
})
</script>

<style lang="scss" scoped>
</style>
