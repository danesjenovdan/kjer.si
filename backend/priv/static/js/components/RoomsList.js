import { defineComponent, reactive } from '../vue.esm.prod.js'
import { fetchRooms, deleteRoom } from '../api.js'

function refreshRooms(state, token) {
  fetchRooms(token).then(({ data }) => state.rooms = data)
}

export default defineComponent({
  setup({ token }) {
    const state = reactive({ rooms: [] })
    refreshRooms(state, token)

    const deleteRoomHandler = room => {
      if (window.confirm("Are you sure?")) {
        deleteRoom(room, token).then(() => refreshRooms(state, token))
      }
    }

    return {
      state,
      deleteRoomHandler,
    }
  },

  template: /*html*/`
    <table class="table">
      <thead>
        <tr>
          <td>Name</td>
          <td>Category</td>
          <td>Lat</td>
          <td>Lng</td>
          <td>Radius</td>
          <td># Events</td>
          <td># Users</td>
          <td>Delete</td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="room in state.rooms">
          <td>{{ room.name }}</td>
          <td>{{ room.category.name }}</td>
          <td>{{ room.lat }}</td>
          <td>{{ room.lng }}</td>
          <td>{{ room.radius }}</td>
          <td>{{ room.events.length }}</td>
          <td>{{ room.users.length }}</td>
          <td>
            <button
              v-if="room.events.length === 0"
              class="delete"
              @click.stop="deleteRoomHandler(room)"
            >Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  `
})
