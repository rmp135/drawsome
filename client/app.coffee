require './style.scss'
vue = require 'vue'
vuerouter = require 'vue-router'
require 'socket.io-client'

vue.use vuerouter
router = new vuerouter()
vue.use require 'vue-resource'

router.map
  '/':
    name:'join'
    component: require './views/join-view.vue'
  '/host/:gameId':
    name:'host'
    component: require './views/host-view.vue'
  '/play/:gameId':
    name:'play'
    component: require './views/play-view.vue'

router.start {}, '#app'
