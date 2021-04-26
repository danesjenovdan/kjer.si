<template>
  <div class="grid grid-cols-1">
    <h1>This is room: {{ roomId }}</h1>
    <div class="grid grid-cols-2" v-for="message in messages" :key="message.id">
        <div class="grid grid-cols-1 bg-blue-100 m-1">
            <p class="text-xs">{{ message.userNickname }}</p>
            <p class="text-lg">{{ message.content }}</p>
        </div>
        <button
            class="rounded-full my-2 py-2 px-3 bg-red-500 text-white"
            @click="deleteMessage"
        >DELETE</button>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'

import api from '../services/api.service';

export default defineComponent({
  name: 'Messages',
  props: {
    roomId: {
      type: String,
      required: true
    }
  },
  data() {
      return {
          messages: [],
      };
  },
  async mounted() {
      this.messages = await this.getMessages();
  },
  watch: {
      async roomId(newRoomId) {
          this.messages = await this.getMessages();
      },
  },
  methods: {
      async getMessages() {
          const token = await api.getToken();
          const messages = await api.getMessages(token, this.roomId);
          console.log(messages);
          return messages;
      },
      async deleteMessage() {
          alert('TODO');
      },
  }
})
</script>

<style lang="scss" scoped>
</style>
