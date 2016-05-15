express = require 'express'
router = express.Router()
shortid = require 'shortid'
_ = require 'lodash'
randomcolor = require 'randomcolor'

{games} = require '../../store/gameStore.coffee'
words = require '../../store/wordStore.coffee'

findGameById = (id) -> games.find (game) -> game.id is id
findPlayerInGameByName = (game, name) -> game.players.find (p) -> p.name is name

io = require '../../socket.coffee'

io.on 'connection', (socket) ->
  socket.on 'join', ({gameId, playerName}) ->
    socket.join gameId

router.post '/create', (req, res) ->
  gameId = if req.body.gameId is "" then null else req.body.gameId
  game = games.find (g) -> g.id is gameId
  if not game?
    game = {
      id:(gameId ? shortid.generate())
      stage:'AVATAR'
      players:[]
    }
    games.push game
  res.json game

router.get '/:gameId', (req, res) ->
  game = findGameById req.params.gameId
  if not game? then return res.sendStatus 404
  res.json game

router.post '/:gameId/join', (req, res) ->
  game = findGameById req.params.gameId
  if not game? then return res.sendStatus 404
  player = findPlayerInGameByName game, req.params.playerName
  if player?
    res.json {game, player}
    return
  player =  {name:req.body.name, state:'AVATAR', colour:randomcolor({luminosity:'dark', seed:req.body.name}), score:0}
  game.players.push player
  io.of('/').to(req.params.gameId).emit('joined', player)
  res.json {game, player}

router.get '/:gameId/:playerName', (req, res) ->
  game = findGameById req.params.gameId
  if not game? then return res.sendStatus 404
  player = findPlayerInGameByName game, req.params.playerName
  if not player? then return res.sendStatus 404
  res.json {game, player}

router.post '/:gameId', (req, res) ->
  game = findGameById req.params.gameId
  command = req.body.command
  if not game? then return res.sendStatus 404
  if not command? then return res.sendStatus 403
  switch game.stage
    when 'REVEAL'
      switch command
        when 'ROUNDEND'
          game.turn++
          if game.turn < game.players.length
            game.players[game.turn].guess = null
            game.players[game.turn].pick = null
            game.stage = "GUESS"
            for player, i in game.players when i isnt game.turn
              player.state = 'GUESSING'
          else
            game.stage = "SCORE"
            player.state = "WAITING" for player in game.players
  io.of('/').to(game.id).emit 'STATECHANGE'
  res.json game


router.post '/:gameId/:playerName', (req, res) ->
  game = findGameById req.params.gameId
  if not game? then return res.sendStatus 404
  player = findPlayerInGameByName game, req.params.playerName
  command = req.body.command
  if not player? or not command? then return res.sendStatus 403
  switch game.stage
    when 'AVATAR'
      switch command
        when 'READY'
          player.state = 'READY'
          player.avatar = req.body.avatar
        when 'ALLREADY'
          game.stage = 'DRAW'
          player.state = 'DRAW' for player in game.players
          gameWords = _.sampleSize(words, game.players.length).map (w) -> w.toLowerCase()
          for player, i in game.players
            player.state = 'DRAWING'
            player.word = gameWords[i]
    when 'DRAW'
      switch command
        when 'READY'
          player.state = 'READY'
          player.image = req.body.image
      if (game.players.every (p) -> p.state is "READY")
        game.stage = "GUESS"
        game.turn = 0
        game.players[game.turn].state = "WAITING"
        for player, i in game.players when i isnt game.turn
          player.state = 'GUESSING'
    when 'GUESS'
      switch command
        when 'READY'
          if req.body.guess is game.players[game.turn].word
            return res.status(400).send "That is the correct answer. Please submit another answer."
          player.state = 'READY'
          player.guess = req.body.guess
      if (game.players.every (p) -> p.state isnt "GUESSING")
        game.stage = 'PICK'
        player.state = 'PICKING' for player, i in game.players when i isnt game.turn
    when 'PICK'
      switch command
        when 'READY'
          pick = req.body.pick
          player.state = 'READY'
          player.pick = pick
          if pick is game.players[game.turn].word
            player.score += 1000
          else
            player.score -= 500
      if (game.players.every (p) -> p.state in ["READY", "WAITING"])
        game.stage = 'REVEAL'
        player.state = 'READY' for player, i in game.players

  io.of('/').to(game.id).emit 'STATECHANGE'
  res.json {game, player}

module.exports = router
