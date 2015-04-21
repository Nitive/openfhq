express = require 'express'
app = express()

app.set 'port', process.env.PORT || 5000
app.set 'views', __dirname + '/public'

app.engine 'html', require('ejs').renderFile
app.set 'view engine', 'ejs'
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
	res.render 'quests.html'

app.get '/welcome', (req, res) ->
	res.render 'startpage.html'

app.listen app.get('port'), ->
	console.log "Node app is running at localhost:" + app.get 'port'
