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
      picks: -> 
        playerGuesses = @game.players
        .filter (p) => p.name isnt @player.name and p.guess?
        .map (p) -> p.guess
        .filter (g, i, self) => self.indexOf(g) is i and g isnt @player.guess
        playerGuesses.concat (@game.players[@game.turn]).word
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
