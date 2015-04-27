if $? then $ ->
	quests = [
		{
			title: "Task name"
			author: "sea-kg"
			subject: "forensic"
			text: "Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum."
			file: null
			score: 200
		}
		{
			title: "Another task"
			author: "sea-kg"
			subject: "forensic"
			text: "Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum."
			file: null
			score: 200
		}
		{
			title: "Also another task"
			author: "sea-kg"
			subject: "forensic"
			text: "Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum."
			file: null
			score: 200
		}
		{
			title: "4th task"
			author: "sea-kg"
			subject: "forensic"
			text: "Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum."
			file: null
			score: 200
		}
	]

	ratingData = [
		{
			name: "keva"
			score: 159195
			country: "Russia"
		}
		{
			name: "More Smoked Leet Chicken"
			score: 769207
			country: "Russia"
		}
		{
			name: "Hackers"
			score: 98234
			country: "India"
		}
		{
			name: "0x234"
			score: 2143623
			country: "USA"
		}
		{
			name: "hex"
			score: 235522
			country: "Kazakhstan"
		}
		{
			name: "coolbki"
			score: 234156
			country: "Britain"
		}
		{
			name: "Whatever"
			score: 1235561
			country: "Germany"
		}
	]

	titlePrefix = "FHQ | "

	page =
		title: "#{titlePrefix}Quests"
		icons:
			main: "quests-icon.svg"
			navicon: "navicon.svg"
			toggleExtraMenu: "toggle-extra-menu.svg"

	userData =
		name: "Nitive"

	navMenuData = [
		[
			{
				text: "Profile"
				href: "#"
			}
			{
				text: "Favorites"
				href: "#"
			}
		]
		[
			{
				text: "Quests"
				href: "#"
			}
			{
				text: "Games"
				href: "#"
			}
			{
				text: "Rating"
				href: "#"
			}
			{
				text: "News"
				href: "#"
			}
		]
	]

	random = (min, max) -> Math.floor do Math.random * (max - min) + min
	loadIcon = (id, file) ->
		s = Snap "##{id}"
		Snap.load "images/#{file}", (f) ->
			s.append f.select "g"

	Quest = React.createClass
		render: ->
			<article style={height: random(150, 300)}>
				Lorem ipsum dolor sit amet, consectetur adipisicing elit. Fugiat sequi, ex natus.
			</article>

	Quests = React.createClass
		render: ->
			<div className="quests">
				{
					@props.quests.map ->
						<Quest />
				}
			</div>

	PageHeader = React.createClass
		componentDidMount: ->
			loadIcon "page-icon", page.icons.main
			loadIcon "navicon", page.icons.navicon
		render: ->
			<header className="page-header">
				<svg id="navicon" />
				<svg id="page-icon" />
				<h2>Quests</h2>
			</header>

	Search = React.createClass
		render: ->
			<div className="search ios-search-field">
				<input placeholder="Type to search..." />
			</div>

	MainContainer = React.createClass
		render: ->
			<section className="main-container">
				<PageHeader />
				<Search />
				<Quests quests={quests} />
				<footer className="page-footer"></footer>
			</section>

	NavMenu = React.createClass
		render: ->
			data = navMenuData.map (ul) ->
				<ul>
					{ ul.map (li) -> <li><a href={li.href}>{li.text}</a></li> }
				</ul>
			<nav className="nav-menu">
					<header>
						<h1>Nitive</h1>
						<svg id="toggle-extra-menu" />
					</header>
				{data}
			</nav>

	RatingMenu = React.createClass
		render: ->
			data = ratingData
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


	Page = React.createClass
		componentDidMount: ->
			loadIcon "toggle-extra-menu", page.icons.toggleExtraMenu
		render: ->
			<div className="wrap">
				<NavMenu />
				<MainContainer quests={@props.quests} />
				<RatingMenu />
			</div>


	React.render <Page />, document.body
