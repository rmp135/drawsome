<script lang="coffee">
  module.exports =
    name:'host-guess-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentPlayer: -> @game.players[@game.turn]
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-guess-comp
    canvas-view-comp(v-bind:lines="currentPlayer.image", :colour="currentPlayer.colour", scale="5")
</template>

<style lang="scss">
  #host-guess-comp {
  }
</style>
