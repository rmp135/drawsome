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
    template(v-if="player.state == 'DRAWING'")
      .text {{player.word}}
      canvas-comp(v-bind:lines.sync="image", :width="width", :colour="player.colour")
      button.btn.btn-primary(@click="onImageDone") Ready
    template(v-else)
      .text Waiting for players...
</template>

<style lang="scss">
  #play-draw-comp {
    display: flex;
    justify-content: center;
    flex-direction: column;
    .text {
      font-size: 2rem;
      text-align: center;
    }
  }
</style>
