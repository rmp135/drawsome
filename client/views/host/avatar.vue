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
    #players
      div.player(v-for="player in game.players") {{player.name}} - {{player.state}}
        div(v-if="player.avatar")
          canvas-view-comp(v-bind:lines="player.avatar", scale="0.2", width="100", v-bind:disabled="true")
        div(v-else)
          i.fa.fa-pencil
</template>

<style lang="scss">
  #host-avatar-comp {
    #players {
      // -webkit-column-count:2;
      // -webkit-column-gap: 10em;

      .player {
        border: 1px black solid;
      }
    }
  }
</style>
