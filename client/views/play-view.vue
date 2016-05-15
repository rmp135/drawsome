<script lang="coffee">
  socket = require('socket.io-client').connect()
  module.exports =
    name:'play-comp'
    data: ->
      gameStore:require('../store/gameStore.coffee')
      playerStore:require('../store/playerStore.coffee')
    computed:
      gameStage: -> @gameStore.game.stage
      isCurrentTurn: -> @gameStore.game.turn is @gameStore.game.players.findIndex (p) => p.name is @playerStore.player.name
    route:
      canActivate: ->
        (require '../store/gameStore.coffee').game.id?
    ready: ->
      socket.on 'joined', (player) => @gameStore.game.players.push player
      socket.emit('join', {gameId: @gameStore.game.id, playerName:@playerStore.player.name})
      socket.on 'STATECHANGE', =>
        @$http.get "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}"
        .then (res) ->
          @gameStore.game = res.data.game
          @playerStore.player = res.data.player
    components:[
      require('./play/avatar.vue')
      require('./play/draw.vue')
      require('./play/guess.vue')
      require('./play/pick.vue')
      require('./play/reveal.vue')
    ]
</script>

<template lang="pug">
  #play-comp
    play-avatar-comp(v-if="gameStage == 'AVATAR'", :game="gameStore.game", :player="playerStore.player")
    play-draw-comp(v-if="gameStage == 'DRAW'", :game="gameStore.game", :player="playerStore.player")
    play-guess-comp(v-if="gameStage == 'GUESS'", :game="gameStore.game", :player="playerStore.player")
    play-pick-comp(v-if="gameStage == 'PICK'", :game="gameStore.game", :player="playerStore.player")
    play-reveal-comp(v-if="gameStage == 'REVEAL'", :game="gameStore.game", :player="playerStore.player")
</template>

<style lang="scss">
  #play-comp {
  }
</style>
