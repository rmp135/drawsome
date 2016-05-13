<script lang="coffee">
  module.exports =
    name:'host-reveal-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentImage: -> @game.players[@game.turn].image
      groupedPicks: ->
        word = @game.players[@game.turn].word
        gp = {"#{word}":[]}
        for player in @game.players when player.pick?
          gp["#{player.pick}"] ?= []
          gp["#{player.pick}"].push player.name
        return gp
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-reveal-comp
    canvas-view-comp(v-bind:lines="currentImage")
    div(v-for="(pick, picker) in groupedPicks")
      div {{pick}}
      div(v-for="player in picker")
        div {{player}}
</template>

<style lang="scss">
  #host-reveal-comp {
  }
</style>
