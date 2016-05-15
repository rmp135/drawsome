<script lang="coffee">
  module.exports =
    name:'host-avatar-comp'
    props:
      game:
        type:Object
        required:true
</script>

<template lang="pug">
  #host-avatar-comp
    div Waiting for players to join the game.
    div Game Code: {{game.id}}
    //- div Current Players:
    //- div(v-for="player in game.players") {{player.name}}
</template>

<style lang="scss">
  #host-avatar-comp {
    * {
      text-align: center;
      font-size: 3rem;
    }
  }
</style>
