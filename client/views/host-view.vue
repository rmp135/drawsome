<script lang="coffee">
  socket = require('socket.io-client').connect()
  module.exports =
    name:'host-comp'
    data: ->
      gameStore:require '../store/gameStore.coffee'
    computed:
      game:
        get: -> @gameStore.game
        set: (game) -> @gameStore.game = game
      evenPlayers: ->
        if not @game.players? then return []
        @game.players
        .map (p, i) -> if i%2 is 0 then p
        .filter (p) -> p?
      oddPlayers: ->
        if not @game.players? then return []
        @game.players
        .map (p, i) -> if i%2 isnt 0 then p
        .filter (p) -> p?
    route:
      data: (transition) ->
        if @game.id?
          socket.emit 'join', {gameId:@game.id, playerName:'_host'}
          return
        @$http.get "/api/game/#{transition.to.params.gameId}"
        .then (res) ->
          socket.emit 'join', {gameId:res.data.id, playerName:'_host'}
          return 'game':res.data
        .catch (res) ->
          @game = null
          transition.abort()
    ready: ->
      socket.on 'JOINED', (player) =>
        @game.players.push player
      socket.on 'STATECHANGE', =>
        @$http.get "/api/game/#{@game.id}"
        .then (res) ->
          @game = res.data
    destroyed: ->
      socket.removeAllListeners 'JOINED'
      socket.removeAllListeners 'STATECHANGE'
    components:[
      require('./host/player-list.vue')
      require('./host/avatar.vue')
      require('./host/draw.vue')
      require('./host/guess.vue')
      require('./host/pick.vue')
      require('./host/reveal.vue')
      require('./host/score.vue')
    ]
</script>

<template lang="pug">
  #host-comp
    player-list-comp(v-bind:players="evenPlayers").align-left
    #center-col
      host-avatar-comp(v-if="game.stage == 'AVATAR'", :game="game")
      host-guess-comp(v-if="game.stage == 'GUESS'", :game="game")
      host-pick-comp(v-if="game.stage == 'PICK'", :game="game")
      host-draw-comp(v-if="game.stage == 'DRAW'", :game="game")
      host-reveal-comp(v-if="game.stage == 'REVEAL'", :game="game")
      host-score-comp(v-if="game.stage == 'SCORE'", :game="game")
    player-list-comp(v-bind:players="oddPlayers").align-right

</template>

<style lang="scss">
  #host-comp {
    display: flex;
    flex-direction: row;
    align-items: stretch;
    flex-wrap: no-wrap;
    align-content:stretch;
    #center-col {
      display: flex;
      flex-grow:10;
      flex-shrink: 1;
      justify-content: center;
      align-items:center;
      .align-right {
        align-items: flex-end;
      }
      .align-left {
        align-items: flex-start;
      }

    }
  }
</style>
