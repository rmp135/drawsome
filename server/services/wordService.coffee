wordStore = require '../store/wordStore.coffee'
_ = require 'lodash'

wordService = {
  generateWord: ->
    rand = Math.floor(Math.random()*100)
    if rand < 50
      _.sample wordStore.prebuilds
    else
      _.sample(wordStore.adjectives)+" "+_.sample(wordStore.nouns)+" "+_.sample(wordStore.extras)
  generateWords: (num=1) ->
    wordService.generateWord() for [0..num]
} 

module.exports = wordService