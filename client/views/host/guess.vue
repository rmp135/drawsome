<script lang="coffee">
  randomcolor = require 'randomcolor'
  module.exports =
    name:'host-guess-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentImage: -> @game.players[@game.turn].image
      currentColour: -> randomcolor {luminosity:'dark', seed:@game.players[@game.turn].name}
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-guess-comp
    .tagline(v-bind:style="{color:currentColour}") Say what you see...
    canvas-view-comp(v-bind:lines="currentImage", :colour="currentColour")
</template>

<style lang="scss">
  #host-guess-comp {
    .tagline {
      text-align: center;
      font-size: 3rem;
    }
  }
</style>
