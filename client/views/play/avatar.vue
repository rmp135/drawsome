<script lang="coffee">
  randomcolor = require 'randomcolor'
  module.exports =
    name:'play-avatar-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    data: ->
      avatar:[]
    computed:
      width: -> [document.body.offsetWidth-10, 500].reduce (w, w2) -> if w < w2 then w else w2
      availablePlayers: -> (@game.players.filter (p) -> p.state is "READY").length
      colour: -> randomcolor {luminosity:'dark', seed:@player.name}
    methods:
      onReadyClick: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', avatar:@avatar}
      onStartClick: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'ALLREADY'}
    components:[require('../../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #player-avatar-comp
    template(v-if="player.state == 'AVATAR'")
      canvas-comp(v-bind:lines.sync="avatar", :width="width", :colour="colour")
      button.btn.btn-primary(@click="onReadyClick") Ready
    template(v-else)
      div(v-if="availablePlayers < 3") Need {{3 - availablePlayers}} more players...
      template(v-else)
        button.btn.btn-primary(@click="onStartClick") Start Game
</template>

<style lang="scss">
  #player-avatar-comp {
  }
</style>
