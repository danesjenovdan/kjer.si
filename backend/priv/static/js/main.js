import { createApp } from './vue.esm.prod.js'
import App from './App.js'

// TODO: reset token
let token = null
if (!localStorage.getItem('adminToken')) {
  token = window.prompt('Secret?')
  localStorage.setItem('adminToken', token)
} else {
  token = localStorage.getItem('adminToken')
}

createApp(App, { token }).mount('#app')
