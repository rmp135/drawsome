<script lang="coffee">
  randomcolor = require 'randomcolor'
  module.exports =
    name:'player-list-comp'
    props:
      players:
        type:Array
        required:true
    methods:
      colourFromName: (name) -> randomcolor({luminosity:"dark", seed:name})
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  .player-list-comp
    .player(v-for="player in players")
      .avatar
        canvas-view-comp(v-if="player.avatar", :lines="player.avatar", :width=100, :scale=0.2, :colour="colourFromName(player.name)")
        div(v-else, :style="{color:colourFromName(player.name)}").no-avatar ?
      .player(v-bind:style="{color:colourFromName(player.name)}") {{player.name}}
</template>

<style lang="scss">
  .player-list-comp {
    .player {
      display: flex;
      align-items:center;
      flex-direction: column;
      // margin-right:50px;
    }
    .no-avatar {
      // display: flex;
      // align-content: center;
      // justify-content: center;
      text-align: center;
      line-height: 100px;
      font-size:100px;
      width: 100px;
      height:100px;
    }
  }
</style>
