React = require "react"
Router = require "react-router"
$ = require "jquery"
Cookie = require "js-cookie"

DefaultRoute = Router.DefaultRoute
Link = Router.Link
Route = Router.Route
Redirect = Router.Redirect
RouteHandler = Router.RouteHandler
NotFoundRoute = Router.NotFoundRoute

Snap = require 'snapsvg'
marked = require 'marked'
NProgress = require 'nprogress'
humane = require 'humane-js'

icons = require './icons.coffee'
baseData = require './data.coffee'

u = require './utilities.coffee'
api = require './api.coffee'

do NProgress.start


$(document).on 'click', '.page-header', ->
	themes = ['standart', 'violet'].map (e) -> "theme_#{e}.css"
	$('link[href^=theme]').attr 'href', (i, value) ->
		next = themes.indexOf(value) + 1
		themes[if next >= themes.length then 0 else next]


random = (min, max) -> Math.floor do Math.random * (max - min) + min
loadIcon = (querySelector, file) ->
	s = Snap querySelector
	Snap.load "images/#{file}", (f) ->
		s.append f.select "g"


Quest = React.createClass

	getInitialState: ->
		opened: @props.data.opened or no

	componentDidMount: ->
		sn = Snap React.findDOMNode @refs.footer
		sn.path "M 2,10 L 17,24 32,10"
			.attr
				fill: "none"
				stroke: "#343d46"
				strokeWidth: 3

		@cat = icons.quest.submit Snap React.findDOMNode @refs.submit

	toggle: ->
		@props.data.opened = not @props.data.opened
		@setState just: "update"

	submitQuest: (e) ->
		if e.type is 'keypress' and e.which is 13 or e.type is 'click' # if enter or click
			answer = @refs.flagInput.getDOMNode().value
			if answer
				api.quests.pass @props.data.questid, answer, ((response) ->
					if response.result is 'ok'
						@cat.submitQuest yes
					else if response.result is 'fail'
						@cat.submitQuest no
						notify = do humane.create
						notify.log baseData.errors[response.error.code] or response.error.message
				).bind this

	render: ->
		quest = @props.data
		filter = @props.filterText.replace /[^\w\s]/gi, ""

		name = quest.name
		text = (marked quest.text).replace /src="(?!http:\/\/)/, 'src="#{u.domen}/'

		try
			re = new RegExp "(#{filter})", "ig"
			if name.search re isnt -1 and filter isnt ""
				name = name.replace re, "<mark>$1</mark>"

		catch e
			console.warn "Warning: #{e.message}"

		name += "<sup>#{quest.solved}</sup>"

		<article className={if @props.data.opened then "opened" else ""}>
			<h4 data-info="#{quest.subject} #{quest.score}" data-author="by #{quest.author}" dangerouslySetInnerHTML={__html: name} />
			<div className="download" />
			<div className="quest__text" dangerouslySetInnerHTML={__html: text} />
			<footer>
				<div onClick={@toggle} className="footer-arrow"><svg ref="footer" /></div>
				<div className="footer-right">
					<input type="text" ref='flagInput' placeholder="Type your flag..." onKeyPress={@submitQuest} />
					<svg className="submit-quest" ref="submit" onClick={@submitQuest} />
				</div>
			</footer>
		</article>


Quests = React.createClass

	getInitialState: ->
		quests: []

	componentDidMount: ->
		do NProgress.start
		api.quests.list ((response) ->
			if response.result is "ok"

				quests = []
				for quest in response.data
					quest.author ||= "Author"
					quest.text ||= "**Necessitatibus** facere excepturi ~~fuga~~ cum _tenetur_ ipsa `corporis perferendis` deleniti deserunt, officia expedita saepe voluptate aperiam non."
					quests.push quest

				@setState quests: quests
				do NProgress.done

		).bind this

	render: ->
		filterText = @props.filterText.toLowerCase().trim()
		data = @state.quests
			.filter (e) -> (e.text.toLowerCase().indexOf(filterText) != -1) or (e.name.toLowerCase().indexOf(filterText) != -1)
			.map (e, i) -> <Quest filterText={filterText} data={e} />

		center = data.length // 2
		center += 1 if data.length % 2 != 0

		<div className="quests">
			<div>
				{data[...center]}
			</div>
			<div>
				{data[center..]}
			</div>
			{if data.length is 0 then <center>Nothing is here...</center>}
		</div>


PageHeader = React.createClass

	_paper: undefined

	componentDidMount: ->
		loadIcon ".navicon", icons.navicon
		@_paper = Snap React.findDOMNode @refs.pageIcon
		try
			icons.pageHeader[@props.title] Snap React.findDOMNode @refs.pageIcon
		catch e
			console.warn "Нет иконки #{@props.title}"

	componentDidUpdate: ->
		document.title = "FHQ | #{@props.title.charAt(0).toUpperCase()}#{@props.title.slice 1}"
		do @_paper.clear
		try
			icons.pageHeader[@props.title] @_paper
		catch e
			console.warn "Нет иконки #{@props.title}"

	render: ->
		<header className="page-header">
			<svg className="navicon" />
			<svg className="page-icon" ref="pageIcon" />
			<h2>{@props.title}</h2>
		</header>


SearchBar = React.createClass

	handleChange: ->
		@props.onUserInput @refs.filterTextInput.getDOMNode().value

	render: ->
		<div className="search">
			<input
				type="text"
				value={@props.filterText}
				ref="filterTextInput"
				placeholder="Type to search..."
				onChange={@handleChange}
			/>
		</div>


Profile = React.createClass
	render: ->
		<div />


Starred = React.createClass
	render: ->
		<div />


FilterableQuests = React.createClass

	getInitialState: ->
		filterText: ""

	handleUserInput: (filterText) ->
		@setState
			filterText: filterText

	render: ->

		<div>
			<SearchBar
				filterText={@state.filterText}
				onUserInput={@handleUserInput}
			/>
			<Quests
				filterText={@state.filterText}
			/>
		</div>


Game = React.createClass

	render: ->
		<article className="game">
			<h4 data-info="#{@props.data.type_game}, #{@props.data.state}, #{@props.data.form}" data-orgs=" by #{@props.data.organizators}" className="game__title">{@props.data.title}</h4>
			<figure className="game__imgblock">
				<img src={unless @props.data.logo.indexOf("http") then @props.data.logo else "#{u.domen}/#{@props.data.logo}" } className="game__logo" />
				<div onClick={@props.handleClick} className="game__choose-btn #{if @props.isCurrent then 'game__choose-btn--disable' else ''} transparent-button">{if @props.isCurrent then 'Chosen' else 'Choose'}</div>
			</figure>
			<div className="game__text" dangerouslySetInnerHTML={__html: @props.data.description} />
		</article>

Games = React.createClass

	getInitialState: ->
		data: []
		currentGame: Cookie.get 'currentGame'

	setCurrentGame: (id) ->
		if @state.currentGame isnt id
			do NProgress.start
			api.games.choose id, ((response) ->
				if response.result is "ok"
					@setState currentGame: id
					u.setCookie 'currentGame', id
					do NProgress.done
			).bind this

	componentWillMount: ->
		do NProgress.start

	componentDidMount: ->
		do NProgress.start
		api.games.list ((result) ->
			if result.result is "ok"
				@setState
					data: result.data
					currentGame: Cookie.get 'currentGame'
				do NProgress.done
		).bind this

	render: ->
		games = []
		$.each @state.data, ((key, value) ->
			games.push <Game isCurrent={value.id is @state.currentGame} handleClick={@setCurrentGame.bind(this, value.id)} data={value} />
		).bind this

		<div className="games">
			{games}
		</div>


Rating = React.createClass

	render: ->
		<div />


News = React.createClass

	render: ->
		<div />


NavMenu = React.createClass

	componentDidMount: ->
		sn = Snap ".nav-menu header svg"
		sn.circle 14, 14, 13
			.attr
				fill: "#000"
				strokeWidth: 1.2
		sn.path "M8,11 L14,18 L20,11"
			.attr
				fill: "none"
				strokeWidth: 1.2

	render: ->
		<nav className="nav-menu">
			<header>
				<h1>Nitive</h1>
				<svg />
			</header>
			<ul>
				<li><Link to="profile">Profile</Link></li>
				<li><Link to="starred">Starred</Link></li>
			</ul>
			<ul>
				<li><Link to="quests">Quests</Link></li>
				<li><Link to="games">Games</Link></li>
				<li><Link to="rating">Rating</Link></li>
				<li><Link to="news">News</Link></li>
			</ul>
		</nav>


RatingMenu = React.createClass

	render: ->
		data = baseData.rating
			.sort (team, prev) -> prev.score - team.score
			.map (team, i) ->
				<figure data-place="#{i+1}">
					<h4>{team.name}</h4>
					<div>{team.score}</div>
					<div>{team.country}</div>
				</figure>

		<aside className="rating">
			<h1>Rating</h1>
			{data}
		</aside>


MainContainer = React.createClass

	render: ->
		<section className="main-container">
			<PageHeader title={@props.routes[@props.routes.length-1].name} />
			<div className="content-wrapper">
				<div className="content">
					<RouteHandler />
				</div>
				<footer className="page-footer"></footer>
			</div>
		</section>


App = React.createClass

	componentDidMount: ->
		document.title = "FHQ"
		do NProgress.done

	render: ->
		<div className="wrap">
			<NavMenu />
			<RouteHandler {...@props} />
			<RatingMenu />
		</div>


routes =
	<Route name="app" path="/" handler={App}>
		<Route handler={MainContainer}>
			<Redirect from="/" to="games" />
			<Route path="profile" name="profile" handler={Profile} />
			<Route path="games" name="games" handler={Games} />
			<Route path="news" name="news" handler={News} />
			<Route path="quests" name="quests" handler={FilterableQuests} />
			<Route path="starred" name="starred" handler={Starred} />
			<Route path="rating" name="rating" handler={Rating} />

			<Redirect from="*" to="games" /> # 404 to games
		</Route>
	</Route>


module.exports = ->
	Router.run routes, Router.HistoryLocation, (Handler, props) ->
		React.render <Handler {...props}/>, document.body
