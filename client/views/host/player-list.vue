<script lang="coffee">
  module.exports =
    name:'player-list-comp'
    props:
      players:
        type:Array
        required:true
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  .player-list-comp
    .player(v-for="player in players")
      .avatar
        canvas-view-comp(v-if="player.avatar", :lines="player.avatar", :width=100, :colour="player.colour")
        div(v-else, :style="{color:player.colour}").no-avatar ?
      .player(v-bind:style="{color:player.colour}") {{player.name}}
</template>

<style lang="scss">
  .player-list-comp {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    flex-grow: 1;
    flex-shrink: 2;
    flex-basis: 200px;
    padding: 5px;
    .player {
      display: flex;
      align-items:center;
      flex-direction: column;
      font-size: 2rem;
    }
    .no-avatar {
      text-align: center;
      line-height: 100px;
      font-size:100px;
      width: 100px;
      height:100px;
    }
  }
</style>
