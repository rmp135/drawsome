<script lang="coffee">
  module.exports =
    name:'player-list-comp'
    props:
      players:
        type:Array
        required:true
    methods:
      isWaiting: (player) -> player.state not in ['WAITING', 'READY']
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  .player-list-comp
    .player(v-for="player in players", :style="{color:player.colour}")
      .avatar
        canvas-view-comp(v-if="player.avatar", :lines="player.avatar", :width=100, :colour="player.colour")
        div(v-else).no-avatar ?
      .player {{player.name}}
      .status(v-bind:class="{animate:isWaiting(player)}")
        template(v-if="isWaiting(player)")
          i.fa.fa-pencil
        template(v-else)
          i.fa.fa-check
</template>

<style lang="scss">
  @keyframes wobble {
    from {
      transform: rotate(-45deg);
    }
    to {
      transform: rotate(45deg);
    }
  }
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
      font-size: 100px;
      width: 100px;
      height: 100px;
    }
    .status {
      font-size:3rem;
      &.animate {
        animation-duration: 1s;
        animation-name: wobble;
        animation-iteration-count:infinite;
        animation-direction: alternate;
        animation-timing-function: ease-in-out;
        
      }
    }
  }
</style>
