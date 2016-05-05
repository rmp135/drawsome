express = require('express')
path = require('path')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')

routes = require('./routes/index')

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use bodyParser.json()
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
app.use '/bower_components', express.static(path.join(__dirname, '../../bower_components'))
app.use '/', routes

port = process.env.PORT or 3000
app.listen(port, ->
  console.log "Listening on port: #{port}"
)
