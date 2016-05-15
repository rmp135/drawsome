<script lang="coffee">
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
        correctClass:""
    methods:
      complete: -> 
        @$http.post "/api/game/#{@game.id}",{command:'ROUNDEND'}
    computed:
      correctClass: -> if @currentWord.word is @currentPlayer.word then "correct" else "incorrect"
      currentPlayer: -> @game.players[@game.turn]
      groupedPicks: ->
        gp = []
        allguesses = @game.players
        .filter (p) -> p.guess?
        .map (p) -> {player:p, word:p.guess}
        allpicks = @game.players
        .filter (p) -> p.pick?
        .map (p) -> {player:p, word:p.pick}
        for guess in allguesses
          if (existing = gp.find (g) -> g.word is guess.word)
            existing.belongsTo.push guess.player
          else
            gp.push {word:guess.word, isHost:false, belongsTo:[guess.player], pickedBy:[]}
        if not (allguesses.find (g) => g.word is @currentPlayer.word)
          gp.push {word:@currentPlayer.word, pickedBy:[], isHost:true, belongsTo:[@currentPlayer]}

        for pick in allpicks
          if (existing = gp.find (g) -> g.word is pick.word)
            existing.pickedBy.push pick.player
          else
            gp.push {word:pick.word, pickedBy:[pick.player]}
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
        @currentWord = {word: words[index].word, belongsTo:"", pickedBy:[], correctClass:"wait"}
        setTimeout =>
          if @currentPlayer.word isnt words[index].word then @currentWord.belongsTo = words[index].belongsTo[0]
          @currentWord.correctClass = @correctClass
          setTimeout (=> setPicked 0, words[index].pickedBy, (=> setBelongsTo 1, words[index].belongsTo, (=> setCurrentWord index+1, words, done))), timings.betweenWords
        , 1000
      setCurrentWord 0, @groupedPicks, @complete
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-reveal-comp
    canvas-view-comp(v-bind:lines="currentPlayer.image", :colour="currentPlayer.colour", scale="5")
    #revealWrapper
      .belongsTo(v-if="currentWord.belongsTo", :style="{color:currentWord.belongsTo.colour}", transition="fade") {{currentWord.belongsTo.name}}'s word!
      .currentWord(v-bind:class="currentWord.correctClass", transition="fade" ) {{currentWord.word}}
      .pickedBy
        .name(v-for="player in currentWord.pickedBy", :style="{color:player.colour}", transition="fade") {{player.name}}
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
      .currentWord {
        border-radius: 10px;
        padding:10px;
        &.wait {
          transition: all 0s linear;
        }
        &.correct {
          color:white;
          background-color:#27ae60;
        }
        &.incorrect {
          color:white;
          background-color:#c0392b;
          border-radius: 10px;
          padding:10px;
        }
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
