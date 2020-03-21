import { defineComponent } from './vue.esm.prod.js'
import UsersList from './components/UsersList.js'
import RoomsList from './components/RoomsList.js'

export default defineComponent({
  components: { UsersList, RoomsList },
  props: ['token'],
  template: /*html*/`
    <h2>Registered users</h2>
    <users-list :token="token"></users-list>

    <h2>Rooms</h2>
    <rooms-list :token="token"></rooms-list>
  `
})
