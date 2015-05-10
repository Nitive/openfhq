React = require "react"
Router = require "react-router"

DefaultRoute = Router.DefaultRoute
Link = Router.Link
Route = Router.Route
Redirect = Router.Redirect
RouteHandler = Router.RouteHandler
NotFoundRoute = Router.NotFoundRoute

Snap = require 'snapsvg'
icons = require "./icons.coffee"
baseData = require "./data.coffee"

module.exports = ->

	titlePrefix = "FHQ | "

	page =
		title: "#{titlePrefix}Quests"
		icons:
			main: "quests-icon.svg"
			navicon: "navicon.svg"
			toggleExtraMenu: "toggle-extra-menu.svg"


	random = (min, max) -> Math.floor do Math.random * (max - min) + min
	loadIcon = (querySelector, file) ->
		s = Snap querySelector
		Snap.load "images/#{file}", (f) ->
			s.append f.select "g"

	Quest = React.createClass
		componentDidMount: ->
			sn = Snap React.findDOMNode @refs.footer
			sn.path "M 2,10 L 17,24 32,10"
				.attr
					fill: "none"
					stroke: "#343d46"
					strokeWidth: 3.0

			sm = icons.quest.submit Snap React.findDOMNode @refs.submit

		getInitialState: ->
			opened: @props.data.opened or no

		handleClick: ->
			@props.data.opened = not @props.data.opened
			@setState just: "update"

		render: ->
			quest = @props.data
			filter = @props.filterText

			if filter
				title = []
				arr = quest.title.split new RegExp filter, "i"
				position = 0
				for i in [0...arr.length]
					mainText = arr[i]
					len = filter.length
					position += mainText.length + len
					title.push {mainText}
					title.push <mark>{quest.title.substr(position - len, len)}</mark> if (i != arr.length - 1) and filter

				text = []
				arr = quest.text.split new RegExp filter, "i"
				position = 0
				for i in [0...arr.length]
					mainText = arr[i]
					len = filter.length
					position += mainText.length + len
					text.push {mainText}
					text.push <mark>{quest.text.substr(position - len, len)}</mark> if (i != arr.length - 1) and filter
			else
				title = quest.title
				text = quest.text

			<article className={if @props.data.opened then "opened" else ""}>
				<h4 data-info="#{quest.subject} #{quest.score}" data-author="by #{quest.author}">{title}<sup>{quest.solved}</sup></h4>
				<div className="download" />
				<p>{text}</p>
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
			loadIcon ".navicon", page.icons.navicon
			# loadIcon ".page-icon", page.icons.main
			sn = Snap ".page-icon"
			for i in [0..1]
				for j in [0..1]
					sn.rect i*12, j*12, 8, 8, 1
						.attr
							fill: "none"
							stroke: "#fff"
							strokeWidth: 1.7
		render: ->
			<header className="page-header">
				<svg className="navicon" />
				<svg className="page-icon" />
				<h2>Quests</h2>
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

	Games = React.createClass
		render: ->
			<div />

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
				<PageHeader />
				<div className="content">
					<RouteHandler />
				</div>
				<footer className="page-footer"></footer>
			</section>


	App = React.createClass
		render: ->
			<div className="wrap">
				<NavMenu />
				<MainContainer />
				<RatingMenu />
			</div>

	routes =
		<Route name="app" path="/" handler={App}>
			<Redirect from="/" to="games" />
			<Route path="profile" name="profile" handler={Profile} />
			<Route path="games" name="games" handler={Games} />
			<Route path="news" name="news" handler={News} />
			<Route path="/game/:id">
				<DefaultRoute name="quests" handler={FilterableQuests} />
				<Route path="starred" name="starred" handler={Starred} />
				<Route path="rating" name="rating" handler={Rating} />
			</Route>
		</Route>

	Router.run routes, (Handler) ->
		React.render <Handler/>, document.body

