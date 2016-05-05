require './style.scss'
Vue = require 'Vue'

app = new Vue {
  el:"#app"
  components:[require './components/comp.vue']
}
