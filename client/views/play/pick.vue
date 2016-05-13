<script lang="coffee">
  module.exports =
    name:'play-pick-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    computed:
      picks: -> ((@game.players.filter (p, i) => p.name isnt @player.name and i isnt @game.turn).map (p) -> p.guess).concat (@game.players[@game.turn]).word
    methods:
      onPickDone: (pick) ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', pick}
</script>

<template lang="pug">
  #play-pick-comp
    div(v-if="player.state == 'PICKING'")
      div(v-for="pick in picks")
        button.btn.btn-default(@click="onPickDone(pick)") {{pick}}
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
