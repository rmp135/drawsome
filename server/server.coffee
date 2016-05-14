express = require('express')
path = require('path')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
app = express()
server = require('http').createServer app

module.exports = server

routes = require('./routes/index')

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'pug'
app.use bodyParser.json()
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
app.use '/bower_components', express.static(path.join(__dirname, '../../bower_components'))
app.use '/', routes

port = process.env.PORT or 3000
server.listen(port, ->
  console.log "Listening on port: #{port}"
)
