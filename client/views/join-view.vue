<script lang="coffee">
  module.exports =
    name:'join-comp'
    data: ->
      code:"1"
      playerStore:require('../store/playerStore.coffee')
      gameStore:require('../store/gameStore.coffee')
      lines:[]
    computed:
      canJoin: -> @code isnt "" and @playerStore.player.name isnt ""
    methods:
      onHostClick: ->
        @$http.post '/api/game/create', {gameId:@code}
        .then (res) ->
          @gameStore.game = res.data
          @$router.go {name:'host', params:{gameId:res.data.id}}
      onJoinClick: ->
        @$http.post "/api/game/#{@code}/join", {name:@playerStore.player.name}
        .then (res) ->
          @gameStore.game = res.data.game
          @playerStore.player = res.data.player
          @$router.go {name:'play', params:{gameId:@gameStore.game.id}}
    components:[require('../components/canvas-comp.vue')]
</script>

<template lang="jade">
  #join-comp
    button(@click="onHostClick").btn.btn-default Host
    input(v-model="code").form-control
    input(v-model="playerStore.player.name").form-control
    button(@click="onJoinClick", :disabled="!canJoin", :class="{disabled:!canJoin}").btn.btn-default Join
</template>

<style lang="scss">
  #join-comp {
    canvas {
      border:1px solid black;
    }
  }
</style>
