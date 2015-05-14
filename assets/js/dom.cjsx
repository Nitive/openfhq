React = require "react"
Router = require "react-router"
$ = require "jquery"

DefaultRoute = Router.DefaultRoute
Link = Router.Link
Route = Router.Route
Redirect = Router.Redirect
RouteHandler = Router.RouteHandler
NotFoundRoute = Router.NotFoundRoute

Snap = require 'snapsvg'
marked = require 'marked'
NProgress = require 'nprogress'

icons = require "./icons.coffee"
baseData = require "./data.coffee"


titlePrefix = "FHQ | "

currentPage =
	title: "Quests"


random = (min, max) -> Math.floor do Math.random * (max - min) + min
loadIcon = (querySelector, file) ->
	s = Snap querySelector
	Snap.load "images/#{file}", (f) ->
		s.append f.select "g"


ProgressMixin =
	componentWillMount: ->
		do NProgress.start
	componentDidMount: ->
		do NProgress.done

Quest = React.createClass
	componentDidMount: ->
		sn = Snap React.findDOMNode @refs.footer
		sn.path "M 2,10 L 17,24 32,10"
			.attr
				fill: "none"
				stroke: "#343d46"
				strokeWidth: 3.0

		icons.quest.submit Snap React.findDOMNode @refs.submit

	getInitialState: ->
		opened: @props.data.opened or no

	handleClick: ->
		@props.data.opened = not @props.data.opened
		@setState just: "update"

	render: ->
		quest = @props.data
		filter = @props.filterText

		title = quest.title
		text = marked quest.text

		re = new RegExp "(#{filter})", "ig"
		if title.search re != -1 and filter
			title = title.replace re, "<mark>$1</mark>"
		title += "<sup>#{quest.solved}</sup>"

		<article className={if @props.data.opened then "opened" else ""}>
			<h4 data-info="#{quest.subject} #{quest.score}" data-author="by #{quest.author}" dangerouslySetInnerHTML={__html: title} />
			<div className="download" />
			<div className="quest__text" dangerouslySetInnerHTML={__html: text} />
			<footer>
				<div onClick={@handleClick} className="footer-arrow"><svg ref="footer" /></div>
				<div className="footer-right">
					<input type="text" placeholder="Type your flag..." />
					<svg className="submit-quest" ref="submit" />
				</div>
			</footer>
		</article>

Quests = React.createClass
	render: ->
		filterText = @props.filterText.toLowerCase().trim()
		data = baseData.quests
			.filter (e) -> (e.text.toLowerCase().indexOf(filterText) != -1) or (e.title.toLowerCase().indexOf(filterText) != -1)
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
		</div>

PageHeader = React.createClass
	componentDidMount: ->
		loadIcon ".navicon", icons.navicon
		icons.pageHeader[@props.title] Snap React.findDOMNode @refs.pageIcon

	componentDidUpdate: ->
		paper = Snap React.findDOMNode @refs.pageIcon
		do paper.clear
		try
			icons.pageHeader[@props.title] paper
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
	mixins: [ProgressMixin]
	render: ->
		<div />

Starred = React.createClass
	mixins: [ProgressMixin]
	render: ->
		<div />

FilterableQuests = React.createClass
	mixins: [ProgressMixin]
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
			<h4 data-orgs="by #{123}" className="game__title">{@props.data.title}</h4>
			<img className="game__image" />
			<div className="game__choose-btn game__choose-btn--active">Choose</div>
			<div className="quest__text" dangerouslySetInnerHTML={__html: @props.data.description} />
		</article>


Games = React.createClass
	mixins: [ProgressMixin]

	getInitialState: ->
		data: []

	componentDidMount: ->
		$.ajax
			url: "http://fhq.keva.su/api/games/list.php?token=#{baseData.user.token}"
			dataType: "json"
			cache: true
			success: ((result) ->
				if result.result is "ok"
					console.log "result is #{result}"
					@replaceState data: result.data
			).bind this
			error: -> alert "Error #1"

	render: ->
		games = []
		$.each @state.data, (key, value) ->
			games.push <Game data={value} />

		<div>
			{games}
		</div>

Rating = React.createClass
	mixins: [ProgressMixin]
	render: ->
		<div />

News = React.createClass
	mixins: [ProgressMixin]
	render: ->
		<div />


NavMenu = React.createClass
	componentDidMount: ->
		sn = Snap ".nav-menu header svg"
		sn.circle 14, 14, 13
			.attr
				fill: "#000"
				stroke: "#00e090"
				strokeWidth: 1.2
		sn.path "M8,11 L14,18 L20,11"
			.attr
				fill: "none"
				stroke: "#00e090"
				strokeWidth: 1.2

	render: ->
		game = {id: 1}
		<nav className="nav-menu">
			<header>
				<h1>Nitive</h1>
				<svg />
			</header>
			<ul>
				<li><Link to="profile">Profile</Link></li>
				<li><Link to="starred" params={game}>Starred</Link></li>
			</ul>
			<ul>
				<li><Link to="quests" params={game}>Quests</Link></li>
				<li><Link to="games">Games</Link></li>
				<li><Link to="rating" params={game}>Rating</Link></li>
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
	mixins: [ProgressMixin]
	componentDidMount: ->
		document.title = "FHQ | #{currentPage.title}"
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
			<Route path="game/:id">
				<DefaultRoute name="quests" handler={FilterableQuests} />
				<Route path="starred" name="starred" handler={Starred} />
				<Route path="rating" name="rating" handler={Rating} />
			</Route>
			<Redirect from="*" to="games" /> # 404 to games
		</Route>
	</Route>

module.exports = ->
	Router.run routes, (Handler, props) ->
		React.render <Handler {...props}/>, document.body
