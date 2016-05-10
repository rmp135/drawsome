<script lang="coffee">
  module.exports =
    name:'canvas-view-comp'
    props:
      lines:
        type:Array
        default:->[]
      width:
        type:Number
        default:500
        coerce: (val) -> Number val
      scale:
        type:Number
        default:1
        coerce: (val) -> Number val
    computed:
      context: -> @$els.canvas.getContext '2d'
      scaledLines: -> @lines.map (l) => l.map (p) => [p[0]*@scale, p[1]*@scale]
    ready: ->
      @context.lineWidth = @scale*10
      @context.lineJoin = @context.lineCap = 'round'
      for line in @scaledLines
        @context.beginPath()
        @context.moveTo @lines[0][0], @lines[0][1]
        @context.moveTo line[0], line[1]
        for point in line
          @context.lineTo point[0], point[1]
        @context.stroke()
</script>

<template lang="jade">
  #draw-comp
    canvas(v-el:canvas, :width="width", :height="width")
</template>

<style lang="scss">
  #draw-comp {
    canvas {
      border:1px solid black;
    }
  }
</style>
