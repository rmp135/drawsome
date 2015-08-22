express = require 'express'
router = express.Router()


router.get '/', (req, res, next) ->
  res.render 'index'

router.get '/test', (req, res, next) ->
  res.render 'test'

router.use '/api', require './api/test'

module.exports = router