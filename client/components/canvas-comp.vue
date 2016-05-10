<script lang="coffee">
  module.exports =
    name:'canvas-comp'
    props:
      lines:
        type:Array
        twoWay:true
        default:->[]
      width:
        type:Number
        default:500
        coerce: (val) -> Number val
      disabled:
        type:Boolean
        default:false
    data: ->
      points:[]
      isDrawing: false
    computed:
      context: -> @$els.canvas.getContext '2d'
    ready: ->
      @context.lineWidth = 10
      @context.lineJoin = @context.lineCap = 'round'
      if @lines.length > 0
        @context.beginPath()
        @context.moveTo @lines[0][0], @lines[0][1]
        for line in @lines
          for point in line
            @context.lineTo point[0], point[1]
        @context.stroke()
    methods:
      clear: ->
        return if @disabled
        @context.clearRect(0, 0, @context.canvas.width, @context.canvas.height);
        @lines = []
      getPoint: (e) ->
        rect = @$els.canvas.getBoundingClientRect();
        x = (e.touches?[0].clientX or e.clientX) - rect.left;
        y = (e.touches?[0].clientY or e.clientY) - rect.top;
        return [x, y]
      beginDrawing: (e) ->
        return if @disabled
        e.preventDefault()
        @isDrawing = true
        point = @getPoint e
        @points.push point
        @points.push [point[0],point[1]+1]
      traceLine: (e) ->
        return if @disabled
        if not @isDrawing then return
        @points.push @getPoint e
        @context.beginPath()
        @context.moveTo @points[0][0], @points[0][1]
        for point in @points
          @context.lineTo point[0], point[1]
        @context.stroke()
      endDrawing: (e) ->
        return if @disabled
        @context.beginPath()
        @context.moveTo @points[0][0], @points[0][1]
        for point in @points
          @context.lineTo point[0], point[1]
        @context.stroke()
        @isDrawing = false
        @lines.push @points
        @points = []
</script>

<template lang="jade">
  #draw-comp
    canvas(v-el:canvas, :width="width", :height="width", @mousedown='beginDrawing', @touchstart='beginDrawing', @touchmove='traceLine', @touchend='endDrawing', @mouseup='endDrawing', @mousemove='traceLine')
    //- button(@click="clear") Clear
</template>

<style lang="scss">
  #draw-comp {
    canvas {
      border:1px solid black;
    }
  }
</style>
