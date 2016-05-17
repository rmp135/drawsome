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
      colour:
        type:String
        default: "#000000"
    computed:
      context: -> @$els.canvas.getContext '2d'
      scaledLines: -> @lines.map (l) => l.map (v) => v.map (c) => c * @scale
    ready: ->
      @context.lineWidth = @scale*2
      @context.lineJoin = @context.lineCap = 'round'
      @context.strokeStyle = @colour
      for line in @scaledLines
        @context.beginPath()
        @context.moveTo @lines[0][0], @lines[0][1]
        @context.moveTo line[0], line[1]
        for point in line
          @context.lineTo point[0], point[1]
        @context.stroke()
</script>

<template lang="pug">
  .canvas-view-comp
    canvas(v-el:canvas, :width="width", :height="width")
</template>

<style lang="scss">
  .canvas-view-comp {
    display: flex;
    justify-content: center;
  }
</style>
