<script lang="coffee">
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
    methods:
      pluralise: (word, base) -> if base is 1 then word else "#{word}s"
      onReadyClick: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', avatar:@avatar, width:@width}
      onStartClick: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'ALLREADY'}
    components:[require('../../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #player-avatar-comp
    template(v-if="player.state == 'AVATAR'")
      .text Draw yo' self!
      canvas-comp(v-bind:lines.sync="avatar", :width="width", :colour="player.colour")
      button.btn.btn-primary(@click="onReadyClick") Ready
    template(v-else)
      .text(v-if="availablePlayers < 3") Need {{3 - availablePlayers}} more {{pluralise("player", 3 - availablePlayers)}}...
      template(v-else)
        button.btn.btn-primary(@click="onStartClick") Start Game
</template>

<style lang="scss">
  #player-avatar-comp {
    display: flex;
    justify-content: center;
    flex-direction: column;
    .text {
      font-size: 2rem;
      text-align: center;
    }
  }
</style>
