<script lang="coffee">
  module.exports =
    name:'join-comp'
    data: ->
      code:"1"
      playerStore:require('../store/playerStore.coffee')
      gameStore:require('../store/gameStore.coffee')
      errors:
        room:false
        player:false
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
        .catch (err) ->
          if err.status is 404
            @errors.room = "Room does not exist."

    components:[require('../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #join-comp
    .container
      .form-group(v-bind:class="{'has-error':errors.room}")
        label(for="roomInput") Room Code
        input#roomInput(v-model="code", placeholder="Room Code").form-control
        .help-block(v-if="errors.room") {{errors.room}}
      .form-group
        label(for="nameInput") Player Name
        input#nameInput(v-model="playerStore.player.name", placeholder="Player Name").form-control
      .form-group.buttons
        button(@click="onJoinClick", :disabled="!canJoin", :class="{disabled:!canJoin}").btn.btn-primary Join
        button(@click="onHostClick").btn.btn-primary.pull-right Host
</template>

<style lang="scss">
  #join-comp {
    display: flex;
    justify-content: center;
    align-items: center;
    .buttons {
      display: flex;
      flex-direction: row;
      :nth-child(1) {
        margin-right: 10px;
      }
      :nth-child(2) {
        margin-left: 10px;
      }
      .btn {
        flex-grow: 1;
        padding: 10px;
      }
    }
    canvas {
      border:1px solid black;
    }
  }
</style>
