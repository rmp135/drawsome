express = require 'express'
router = express.Router()


router.get '/', (req, res, next) ->
  res.render 'index'

router.use '/test', require './api/test'

module.exports = router