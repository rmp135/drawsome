<script lang="coffee">
  module.exports =
    name:'host-score-comp'
    props:
      game:
        type:Object
        required:true
    data: ->
      players:[]
    computed:
      orderedPlayers: -> @game.players.sort (p1, p2) -> p1.score < p2.score
    ready: ->
      addPlayer = (i, fromList, toList, done) ->
        if i is fromList.length then return done()
        toList.push fromList[i]
        setTimeout (-> addPlayer i+1, fromList, toList, done), 1200
      addPlayer 0, @orderedPlayers, @players, (-> console.log 'done')

</script>

<template lang="pug">
  #host-score-comp
    #game-over Game Over!
    .player(v-for="player in players", :style="{backgroundColor:player.colour}", transition="fade")
      div {{player.name}}
      div {{player.score}}
</template>

<style lang="scss">
  #host-score-comp {
    #game-over {
      text-align: center;
      font-size: 3rem;
    }
    .player {
      text-align: center;
      font-size: 2rem;
      color:white;
      border: 3px solid;
      padding: 10px;
      border-radius: 10px;
      margin:5px;
      &.fade-transition {
        transition: all 0.3s ease;
        opacity: 1;
      }
      &.fade-enter, &.fade-leave {
        opacity: 0;
      }
    }
  }
</style>
