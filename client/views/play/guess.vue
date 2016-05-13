<script lang="coffee">
  module.exports =
    name:'play-guess-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    data: ->
      guess:""
      error:""
    methods:
      onGuessDone: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', guess:@guess}
        .catch (err) ->
          if err.status is 400
            @error = err.data
            @guess = ""
</script>

<template lang="pug">
  #play-guess-comp
    div(v-if="error") {{error}}
    div(v-if="player.state == 'GUESSING'")
      div Say what you see...
      input(v-model="guess")
      button.btn.btn-default(@click="onGuessDone") Ready
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
