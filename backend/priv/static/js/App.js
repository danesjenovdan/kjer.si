import { defineComponent, reactive } from './vue.esm.prod.js'

async function fetchUsers(token) {
  const getUsers = await window.fetch('/api/admin/users', {
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` }
  })
  return await getUsers.json()
}

async function toggleUserActive(user, token) {
  await window.fetch(`/api/admin/users/${user.id}`, {
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    method: 'PUT',
    body: JSON.stringify({
      user: {
        is_active: !user.is_active
      }
    })
  })
}

function refreshUsers(state, token) {
  fetchUsers(token).then(({ data }) => state.users = data)
}

export default defineComponent({
  setup({ token }) {
    const state = reactive({ users: [] })
    refreshUsers(state, token)

    const deactivate = (user) => {
      toggleUserActive(user, token).then(() => refreshUsers(state, token))
    }

    return {
      state,
      deactivate,
    }
  },

  template: /*html*/`
    <table>
      <thead>
        <tr>
          <td>UID</td>
          <td>Nickname</td>
          <td>Is Active?</td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in state.users">
          <td>{{ user.uid }}</td>
          <td>{{ user.nickname }}</td>
          <td><input type="checkbox" :checked="user.is_active" disabled/></td>
          <td>
            <button @click="deactivate(user)">
              {{ user.is_active ? 'Deactivate' : 'Activate' }}
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  `
})
