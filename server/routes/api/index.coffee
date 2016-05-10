express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.json {foo:'bar'}

router.use '/game', require './game.coffee'

module.exports = router
