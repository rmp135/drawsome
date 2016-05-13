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
    div(v-if="player.state == 'GUESSING'")
      div Say what you see...
      .form-group(v-bind:class="{'has-error':error}")
        input(v-model="guess" placeholder="Guess").form-control
        .help-block(v-if="error") {{error}}
      .form-group
        button.btn.btn-primary(@click="onGuessDone", :disabled="!guess") Ready
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
