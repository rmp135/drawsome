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
    div Current Players:
    div(v-for="player in game.players") {{player.name}}
</template>

<style lang="scss">
  #host-pregame-comp {
  }
</style>
