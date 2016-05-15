<script lang="coffee">
  randomcolor = require 'randomcolor'
  module.exports =
    name:'host-reveal-comp'
    props:
      game:
        type:Object
        required:true
    data: ->
      currentWord:
        word: ""
        belongsTo: ""
        pickedBy: []
    methods:
      colourByName: (name) -> randomcolor {luminosity:'dark', seed:name}
      complete: -> 
        @$http.post "/api/game/#{@game.id}",{command:'ROUNDEND'}
    computed:
      currentImage: -> @game.players[@game.turn].image
      currentColour: -> @colourByName @currentPlayer.name
      currentPlayer: -> @game.players[@game.turn]
      groupedPicks: ->
        gp = []
        allguesses = @game.players
        .filter (p) -> p.guess?
        .map (p) -> {name:p.name, word:p.guess}
        allpicks = @game.players
        .filter (p) -> p.pick?
        .map (p) -> {name:p.name, word:p.pick}
        for guess in allguesses
          if (existing = gp.find (g) -> g.word is guess.word)
            existing.belongsTo.push guess.name
          else
            gp.push {word:guess.word, isHost:false, belongsTo:[guess.name], pickedBy:[]}
        if not (allguesses.find (g) => g.word is @currentPlayer.word)
          gp.push {word:@currentPlayer.word, pickedBy:[], isHost:true, belongsTo:[@currentPlayer.name]}

        for pick in allpicks
          if (existing = gp.find (g) -> g.word is pick.word)
            existing.pickedBy.push pick.name
          else
            gp.push {word:pick.word, pickedBy:[pick.name]}
        gp = gp.filter (g) -> g.pickedBy.length isnt 0 or g.isHost
        return gp
    ready: ->
      timings = {
        begin:1000
        betweenWords:1000
        betweenPicks:1000
        betweenBelongsTo:1000
        afterComplete:2000
        afterAllPicks:1000
      }
      setBelongsTo = (index, belongsTo, done) =>
        if index is belongsTo.length then return setTimeout done, timings.betweenBelongsTo
        @currentWord.belongsTo = belongsTo[index]
        setTimeout (=> setBelongsTo index+1, belongsTo, done), timings.betweenBelongsTo
      setPicked = (index, pickedBy, done) =>
        if index is pickedBy.length then return setTimeout done, timings.afterAllPicks
        @currentWord.pickedBy.push pickedBy[index]
        setTimeout (=> setPicked index+1, pickedBy, done), timings.betweenPicks
      setCurrentWord = (index, words, done) =>
        if index is words.length then return setTimeout done, timings.afterComplete
        @currentWord = {word: words[index].word, belongsTo:"", pickedBy:[]}
        setTimeout =>
          @currentWord.belongsTo = words[index].belongsTo[0]
          setTimeout (=> setPicked 0, words[index].pickedBy, (=> setBelongsTo 1, words[index].belongsTo, (=> setCurrentWord index+1, words, done))), timings.betweenWords
        , 1000
      setTimeout (=> setCurrentWord 0, @groupedPicks, @complete), timings.begin
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-reveal-comp
    canvas-view-comp(v-bind:lines="currentImage", :colour="currentColour")
    #revealWrapper
      .belongsTo(v-if="currentWord.belongsTo", :style="{color:colourByName(currentWord.belongsTo)}", transition="fade") {{currentWord.belongsTo}}'s word!
      .currentWord {{currentWord.word}}
      .pickedBy
        .name(v-for="name in currentWord.pickedBy", :style="{color:colourByName(name)}", transition="fade") {{name}}
</template>

<style lang="scss">
  #host-reveal-comp {
    .fade-transition {
      transition: all 0.3s linear;
    }
    .fade-leave {
      transition: all 0s linear;
      opacity: 0;
    }
    .fade-enter {
      transform:scale(3);
    }
    #revealWrapper {
      display: flex;
      flex-direction: column;
      font-size: 3rem;
      align-items: center;
      * {
        // border:1px solid black;
      }
      .currentWord {
      }
      .pickedBy {
        display: flex;
        .name {
          padding: 1rem;
        }
      }
    }
  }
</style>
