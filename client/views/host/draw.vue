<script lang="coffee">
  module.exports =
    name:'host-avatar-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentImage: -> @game.players[@game.turn].image
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-avatar-comp
    div(v-for="player in game.players") {{player.name}}
      div(v-if="player.image")
        canvas-view-comp(v-bind:lines="player.avatar", scale="0.2", width="100", v-bind:disabled="true")
      div(v-else)
        i.fa.fa-pencil
</template>

<style lang="scss">
  #host-avatar-comp {
  }
</style>
