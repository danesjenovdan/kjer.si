import { createApp } from './vue.esm.prod.js'
import { getAdminUserToken } from './api.js'
import App from './App.js'

async function main () {
  const uid = window.localStorage.getItem('uid') || window.prompt('Who are you?')
  window.localStorage.setItem('uid', uid)
  try {
    const token = await getAdminUserToken(uid.toString())
    createApp(App, { token }).mount('#app')
  } catch (e) {
    document.writeln('Ti tu nisi.')
  }
}

main()
