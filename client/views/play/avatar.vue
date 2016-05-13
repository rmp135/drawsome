<script lang="coffee">
  module.exports =
    name:'play-avatar-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    data: ->
      avatar:[]
    computed:
      width: -> [document.body.offsetWidth-10, 500].reduce (w, w2) -> if w < w2 then w else w2
    methods:
      onAvatarDone: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', avatar:@avatar}
    components:[require('../../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #player-avatar-comp
    div(v-if="player.state == 'AVATAR'")
      canvas-comp(v-bind:lines.sync="avatar", :width="width")
      button.btn.btn-default(@click="onAvatarDone") Ready
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
