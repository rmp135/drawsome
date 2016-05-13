<script lang="coffee">
  module.exports =
    name:'play-draw-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
    data: ->
      image:[]
    computed:
      width: -> [document.body.offsetWidth-10, 500].reduce (w, w2) -> if w < w2 then w else w2
    methods:
      onImageDone: ->
        @$http.post "/api/game/#{@game.id}/#{@player.name}",{command:'READY', image:@image}
    components:[require('../../components/canvas-comp.vue')]
</script>

<template lang="pug">
  #play-draw-comp
    div(v-if="player.state == 'DRAWING'")
      div {{player.word}}
      canvas-comp(v-bind:lines.sync="image", :width="width")
      button.btn.btn-default(@click="onImageDone") Ready
    div(v-else)
      div Waiting for players...
</template>

<style lang="scss">
  #play-comp {
  }
</style>
