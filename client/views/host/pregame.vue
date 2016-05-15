<script lang="coffee">
  module.exports =
    name:'host-pregame-comp'
    props:
      game:
        type:Object
        required:true
</script>

<template lang="pug">
  #host-pregame-comp
    div Waiting for players to join the game.
    div Game Code: {{game.id}}
    //- div Current Players:
    //- div(v-for="player in game.players") {{player.name}}
</template>

<style lang="scss">
  #host-pregame-comp {
    * {
      text-align: center;
      font-size: 3rem;
    }
  }
</style>
