<template>
  <div class="grid grid-cols-6">
    <a href="#">{{ room.id }}</a>
    <div>{{ room.name }}</div>
    <div>{{ room.category.name }}</div>
    <div>{{ room.lat }}, {{ room.lng }}</div>
    <div>{{ room.users.length }}</div>
    <!-- <button
        class="rounded-full my-2 py-2 px-3 bg-red-500 text-white"
        @click="deleteRoom"
    >DELETE</button> -->
    <div class="grid grid-cols-2">
      <button
        class="rounded-full my-1 py-2 px-3 bg-blue-500 text-white"
        @click="$emit('selected')"
      >LOAD CHAT</button>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'

import api from '../services/api.service';

export default defineComponent({
  name: 'Room',
  props: {
    room: {
      type: Object,
      required: true
    }
  },
})
</script>

<style lang="scss" scoped>
</style>
