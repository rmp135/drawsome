require './style.scss'
vue = require 'vue'
vuerouter = require 'vue-router'
require 'socket.io-client'

vue.use vuerouter
router = new vuerouter()
vue.use require 'vue-resource'

test = {
  name:'test'
  template:'
  <div id="test">
    <div>{{currentWord | json}}</div>
  </div>
  '
  data: ->
    from:[{
        word:"some word"
        belongsTo:["from1", "from2"]
        pickedBy:["pick1", "pick2", "pick3"]
      }
      {
        word:"another word"
        belongsTo:["from3", "from4"]
        pickedBy:["pick4", "pick5", "pick6"]
      }]
    currentWord:{}
  ready: ->
    setBelongsTo = (index, belongsTo, done) =>
      if index is belongsTo.length then return done()
      @currentWord.belongsTo = "Also #{belongsTo[index]}'s word!"
      setTimeout (=> setBelongsTo index+1, belongsTo, done), 1000
    setPicked = (index, pickedBy, done) =>
      if index is pickedBy.length then return done()
      @currentWord.pickedBy.push pickedBy[index]
      setTimeout (=> setPicked index+1, pickedBy, done), 1000
    setCurrentWord = (index, done) =>
      if index is @from.length then return done()
      @currentWord = {word:@from[index].word, belongsTo:"#{@from[index].belongsTo[0]}'s word!", pickedBy:[]}
      setTimeout (=> setPicked 0, @from[index].pickedBy, (=> setBelongsTo 1, @from[index].belongsTo, (=> setCurrentWord index+1, done))), 1000
    setCurrentWord 0, -> console.log 'done!'
}

router.map
  '/':
    name:'join'
    component: require './views/join-view.vue'
  '/host/:gameId':
    name:'host'
    component: require './views/host-view.vue'
  '/play/:gameId':
    name:'play'
    component: require './views/play-view.vue'
  '/test':
    name:'test'
    component: test

router.start {}, '#app'
