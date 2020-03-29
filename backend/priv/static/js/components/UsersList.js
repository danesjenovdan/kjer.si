import { defineComponent, reactive } from '../vue.esm.prod.js'
import { fetchUsers, toggleUserActive } from '../api.js'

function refreshUsers(state, token) {
  fetchUsers(token).then(({ data }) => state.users = data)
}

export default defineComponent({
  setup({ token }) {
    const state = reactive({ users: [] })
    refreshUsers(state, token)

    const deactivateUserHandler = user => {
      toggleUserActive(user, token).then(() => refreshUsers(state, token))
    }

    return {
      state,
      deactivateUserHandler,
    }
  },

  template: /*html*/`
    <table class="table">
      <thead>
        <tr>
          <td>UID</td>
          <td>Nickname</td>
          <td>Is Active?</td>
          <td>Deactivate</td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in state.users">
          <td>{{ user.uid }}</td>
          <td>{{ user.nickname }}</td>
          <td><input type="checkbox" :checked="user.is_active" disabled/></td>
          <td>
            <button @click="deactivateUserHandler(user)">
              {{ user.is_active ? 'Deactivate' : 'Activate' }}
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  `
})
