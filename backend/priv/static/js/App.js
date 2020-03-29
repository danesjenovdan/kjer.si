import { defineComponent } from './vue.esm.prod.js'
import UsersList from './components/UsersList.js'
import RoomsList from './components/RoomsList.js'

export default defineComponent({
  components: { UsersList, RoomsList },
  props: ['token'],
  template: /*html*/`
    <header class="container">
      <h1 class="title">Kjer.si Admin</h1>
    </header>
    <main class="container">
      <div class="box">
        <h2 class="subtitle">Registered users</h2>
        <users-list :token="token"></users-list>
      </div>

      <div class="box">
        <h2 class="subtitle">Rooms</h2>
        <rooms-list :token="token"></rooms-list>
      </div>
    </main>
  `
})
