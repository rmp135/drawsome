express = require 'express'
router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index'

router.use '/api', require './api'

module.exports = router
