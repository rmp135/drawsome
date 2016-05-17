<script lang="coffee">
  module.exports =
    name:'host-pick-comp'
    props:
      game:
        type:Object
        required:true
    computed:
      currentPlayer: -> @game.players[@game.turn]
      guesses: ->
        playerGuesses = @game.players
        .map (p) -> p.guess
        .filter (g) -> g?
        guesses = playerGuesses.concat @game.players[@game.turn].word
        # guesses.push "" for [0..Math.floor(Math.random()*5)]
        for guess, i in guesses
          j = Math.floor(Math.random() * (i + 1));
          temp = guesses[i];
          guesses[i] = guesses[j];
          guesses[j] = temp;
        return guesses
      firstHalf: -> @guesses.slice 0, @guesses.length/2
      secondHalf: -> @guesses.slice @guesses.length/2, @guesses.length
    methods:
      randOffset: -> 
        dir = if Math.random() < 0.5 then "left" else "right"
        amount = Math.floor(Math.random()*100)
        return {"#{dir}":"#{amount}px"}
    components:[require('../../components/canvas-view-comp.vue')]
</script>

<template lang="pug">
  #host-pick-comp
    .guesses
      .guess(v-for="guess in firstHalf", track-by="$index", :style="randOffset()") {{guess}}
    canvas-view-comp(v-bind:lines="currentPlayer.image", :colour="currentPlayer.colour", scale="5")
    .guesses
      .guess(v-for="guess in secondHalf", track-by="$index", :style="randOffset()") {{guess}}
</template>

<style lang="scss">
  #host-pick-comp {
    display: flex;
    .guesses {
      display: flex;
      flex-direction: column;
      .guess {
        font-size: 3rem;
        flex-grow:1;
        position: relative;
      }
    }
  }
</style>
