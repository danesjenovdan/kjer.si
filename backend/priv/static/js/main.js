import { createApp } from './vue.esm.prod.js'
import App from './App.js'

// TODO: reset token – until then, dev tools to clear up local storage should do
let token = null
if (!localStorage.getItem('adminToken')) {
  token = window.prompt('Secret?')
  localStorage.setItem('adminToken', token)
} else {
  token = localStorage.getItem('adminToken')
}

createApp(App, { token }).mount('#app')
