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
    template(v-if="player.state == 'GUESSING'")
      .text Say what you see...
      .form-group(v-bind:class="{'has-error':error}")
        input(v-model="guess" placeholder="Guess").form-control
        .help-block.text(v-if="error") {{error}}
      .form-group
        button.btn.btn-primary(@click="onGuessDone", :disabled="!guess") Submit
    .text(v-else) Waiting for players...
</template>

<style lang="scss">
  #play-guess-comp {
    display: flex;
    justify-content: center;
    flex-direction: column;
    width:100%;
    padding:10px;
    .form-group {
      button {
        width:100%;
      }
    }
    .text {
      font-size: 2rem;
      text-align: center;
    }
  }
</style>
