<script lang="coffee">
  socket = require('socket.io-client').connect()
  module.exports =
    name:'host-comp'
    data: ->
      gameStore:require '../store/gameStore.coffee'
    route:
      data: (transition) ->
        if @gameStore.game.id?
          socket.emit 'join', {gameId:@gameStore.game.id, playerName:'_host'}
          return
        @$http.get "/api/game/#{transition.to.params.gameId}"
        .then (res) ->
          socket.emit 'join', {gameId:res.data.id, playerName:'_host'}
          return 'gameStore.game':res.data
        .catch (res) ->
          transition.abort()
    ready: ->
      socket.on 'joined', (player) =>
        @gameStore.game.players.push player
      socket.on 'STATECHANGE', =>
        @$http.get "/api/game/#{@gameStore.game.id}"
        .then (res) ->
          @gameStore.game = res.data
    components:[
      require('../components/canvas-view-comp.vue')
      require('./host/pregame.vue')
      require('./host/avatar.vue')
      require('./host/guess.vue')
      require('./host/reveal.vue')
    ]
</script>

<template lang="pug">
  #host-comp
    div Code: {{gameStore.game.id}}
    div Stage: {{gameStore.game.stage}}
    host-pregame-comp(v-if="gameStore.game.stage == 'PREGAME'", :game="gameStore.game")
    host-avatar-comp(v-if="gameStore.game.stage == 'AVATAR'", :game="gameStore.game")
    host-guess-comp(v-if="gameStore.game.stage == 'GUESS'", :game="gameStore.game")
    host-reveal-comp(v-if="gameStore.game.stage == 'REVEAL'", :game="gameStore.game")
</template>

<style lang="scss">
  #host-comp {
  }
</style>
