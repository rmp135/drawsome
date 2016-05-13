<script lang="coffee">
  module.exports =
    name:'play-pregame-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    methods:
      onReadyClick: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY'}
</script>

<template lang="pug">
  #play-pregame-comp
    div(v-if="player.state == 'WAITING' && game.players.length>2")
      button.btn.btn-default(@click="onReadyClick") Ready
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
