express = require 'express'
router = express.Router()
shortid = require 'shortid'
_ = require 'lodash'

{games} = require '../../store/gameStore.coffee'
words = require '../../store/wordStore.coffee'

findGameById = (id) -> games.find (game) -> game.id is id
findPlayerInGameByName = (game, name) -> game.players.find (p) -> p.name is name

io = require '../../socket.coffee'

io.on 'connection', (socket) ->
  socket.on 'join', ({gameId, playerName}) ->
    socket.join gameId

router.post '/create', (req, res) ->
  game = games.find (g) -> g.id is req.body.gameId
  if not game?
    game = {
      id:shortid.generate()
      stage:'PREGAME'
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
  player = game.players.find (player) -> player.name is req.body.name
  if player?
    res.json {game, player}
    return
  player =  {name:req.body.name, state:'WAITING'}
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
  res.json game
  # switch game.state
  #   when 'REVEAL'
  #     switch command
  #       when 'STAGEEND'

router.post '/:gameId/:playerName', (req, res) ->
  game = findGameById req.params.gameId
  if not game? then return res.sendStatus 404
  player = findPlayerInGameByName game, req.params.playerName
  command = req.body.command
  if not player? or not command? then return res.sendStatus 403
  switch game.stage
    when "PREGAME"
      switch command
        when 'READY'
          player.state = 'READY'
      if (game.players.every (p) -> p.state is "READY")
        game.stage = 'AVATAR'
        player.state = 'AVATAR' for player in game.players
    when 'AVATAR'
      switch command
        when 'READY'
          player.state = 'READY'
          player.avatar = req.body.avatar
      if (game.players.every (p) -> p.state is "READY")
        game.stage = "DRAW"
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
        game.players[0].state = "WAITING"
        for player, i in game.players when i isnt 0
          player.state = 'GUESSING'
    when 'GUESS'
      switch command
        when 'READY'
          player.state = 'READY'
          player.guess = req.body.guess
      if (game.players.every (p) -> p.state isnt "GUESSING")
        game.stage = 'PICK'
        player.state = 'PICKING' for player, i in game.players when i isnt game.turn
    when 'PICK'
      switch command
        when 'READY'
          player.state = 'READY'
          player.pick = req.body.pick
      if (game.players.every (p) -> p.state in ["READY", "WAITING"])
        game.stage = 'REVEAL'
        player.state = 'READY' for player, i in game.players

  io.of('/').to(game.id).emit 'STATECHANGE'
  res.json {game, player}

module.exports = router
