<script lang="coffee">
  module.exports =
    name:'host-guess-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentImage: -> @game.players[@game.turn].image
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-guess-comp
    canvas-view-comp(v-bind:lines="currentImage")
</template>

<style lang="scss">
  #host-guess-comp {
  }
</style>
