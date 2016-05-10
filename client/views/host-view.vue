<script lang="coffee">
  socket = require('socket.io-client').connect()
  module.exports =
    name:'host-comp'
    data: ->
      gameStore:require '../store/gameStore.coffee'
    computed:
      hasPlayers: -> @gameStore.game.players?.length > 0
      currentImage: -> @gameStore.game.players[@gameStore.game.turn].image
      groupedPicks: ->
        word = @gameStore.game.players[@gameStore.game.turn].word
        gp = {"#{word}":[]}
        for player in @gameStore.game.players when player.pick?
          gp["#{player.pick}"] ?= []
          gp["#{player.pick}"].push player.name
        return gp
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
    components:[require('../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-comp
    div Code: {{gameStore.game.id}}
    div Stage: {{gameStore.game.stage}}
    div(v-for="player in gameStore.game.players") {{player.name}} - {{player.state}}
      div(v-if="player.avatar")
        canvas-view-comp(v-bind:lines="player.avatar", scale="0.2", width="100", v-bind:disabled="true")
    div(v-if="gameStore.game.stage == 'GUESS'")
      canvas-view-comp(v-bind:lines="currentImage")
    div(v-if="gameStore.game.stage == 'REVEAL'")
      canvas-view-comp(v-bind:lines="currentImage")
      div(v-for="(pick, picker) in groupedPicks")
        div {{pick}}
        div(v-for="player in picker")
          div {{player}}
</template>

<style lang="scss">
  #host-comp {
  }
</style>
