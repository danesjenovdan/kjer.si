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
    <table>
      <thead>
        <tr>
          <td>name</td>
          <td>category</td>
          <td>lat</td>
          <td>lng</td>
          <td>radius</td>
          <td># events</td>
          <td># users</td>
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
              @click.stop="deleteRoomHandler(room)"
              :disabled="room.events.length > 0"
              :title="room.events.length > 0 ? 'This room has events and thus can not be deleted at this time.' : ''"
            >Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  `
})
