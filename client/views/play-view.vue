<script lang="coffee">
  socket = require('socket.io-client').connect()
  module.exports =
    name:'play-comp'
    data: ->
      gameStore:require('../store/gameStore.coffee')
      playerStore:require('../store/playerStore.coffee')
      avatar:[]
      image:[]
      guess:""
      picked:""
    computed:
      picks: -> ((@gameStore.game.players.filter (p) => p.name isnt @playerStore.player.name and p.state isnt 'WAITING').map (p) -> p.guess).concat (@gameStore.game.players[@gameStore.game.turn]).word
      width: -> [document.body.offsetWidth-10, 500].reduce (w, w2) -> if w < w2 then w else w2
      canBeginGame: -> @gameStore.game.players.length > 2
      gameStage: -> @gameStore.game.stage
      playerState: -> @playerStore.player.state
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
    methods:
      onReadyClick: ->
        @$http.post "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}",{command:'READY'}
        .then (res) ->
          @playerStore.player = res.data.player
          @gameStore.game = res.data.game
      onAvatarDone: ->
        @$http.post "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}",{command:'READY', avatar:@avatar}
        .then (res) ->
          @avatar.length = 0
          @playerStore.player = res.data.player
          @gameStore.game = res.data.game
      onImageDone: ->
        @$http.post "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}",{command:'READY', image:@image}
        .then (res) ->
          @image.length = 0
          @playerStore.player = res.data.player
          @gameStore.game = res.data.game
      onGuessDone: ->
        @$http.post "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}",{command:'READY', guess:@guess}
        .then (res) ->
          @playerStore.player = res.data.player
          @gameStore.game = res.data.game
      onPickDone: (pick) ->
        @$http.post "/api/game/#{@gameStore.game.id}/#{@playerStore.player.name}",{command:'READY', pick}
        .then (res) ->
          @playerStore.player = res.data.player
          @gameStore.game = res.data.game

    components:[require('../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #play-comp
    div(v-for="player in gameStore.game.players") {{player.name}}
    div(v-if="gameStage == 'PREGAME'")
      div(v-if="playerState == 'WAITING' && canBeginGame")
        button.btn.btn-default(@click="onReadyClick") Ready
      div(v-else)
        div Waiting for players...
    div(v-if="gameStage == 'AVATAR'")
      div(v-if="playerState == 'AVATAR'")
        canvas-comp(v-bind:lines.sync="avatar", :width="width")
        button.btn.btn-default(@click="onAvatarDone") Ready
      div(v-else)
        div Waiting for players...
    div(v-if="gameStage == 'DRAW'")
      div(v-if="playerState == 'DRAWING'")
        div {{playerStore.player.word}}
        canvas-comp(v-bind:lines.sync="image", :width="width")
        button.btn.btn-default(@click="onImageDone") Ready
      div(v-else)
        div Waiting for players...
    div(v-if="gameStage == 'GUESS'")
      div(v-if="playerState == 'GUESSING'")
        div Say what you see...
        input(v-model="guess")
        button.btn.btn-default(@click="onGuessDone") Ready
      div(v-else)
        div Waiting for players...
    div(v-if="gameStage == 'PICK'")
      div(v-if="playerState == 'PICKING'")
        div(v-for="pick in picks")
          button.btn.btn-default(@click="onPickDone(pick)") {{pick}}
      div(v-else)
        div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
