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
			score: 859195
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
			score: 543623
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
	loadIcon = (querySelector, file) ->
		s = Snap querySelector
		Snap.load "images/#{file}", (f) ->
			s.append f.select "g"

	Quest = React.createClass
		componentDidMount: ->
			sn = Snap React.findDOMNode @refs.footer
			sn.path "M 2,10 L 17,24 L 32,10"
				.attr
					fill: "none"
					stroke: "#343d46"
					strokeWidth: 3.0
			sm = Snap React.findDOMNode @refs.submit
			sm.path "M34.8,6.5 C34.5,6.1 33.9,6.1 33.6,6.5 L21.8,18.7 L16.8,13.5 C16.5,13.2 16,13.2 15.6,13.5 L12.8,16.5 C12.5,16.8 12.5,17.4 12.8,17.7 L21.2,26.5 C21.4,26.7 21.6,26.8 21.8,26.8 C22,26.8 22.3,26.7 22.4,26.5 L37.6,10.7 C37.8,10.5 37.9,10.3 37.9,10 C37.9,9.8 37.8,9.6 37.6,9.4 L34.8,6.5 Z"
				.attr
					fill: "#343d46"
		render: ->
			<article>
				<h4>Minimized task<sup>5</sup></h4>
				<div className="download" />
				<p>Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum.</p>
				<footer>
					<div className="footer-arrow"><svg ref="footer" /></div>
					<div className="footer-right">
						<input type="text" placeholder="Type your flag..." />
						<svg className="submit-quest" ref="submit" />
					</div>
				</footer>
			</article>

	Quests = React.createClass
		render: ->
			quests = @props.quests.map -> <Quest />
			<div className="quests">
				<div>
					{quests[..(quests.length // 2 - 1)]}
				</div>
				<div>
					{quests[(quests.length // 2)..]}
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

	Search = React.createClass
		render: ->
			<div className="search">
				<input placeholder="Type to search..." />
			</div>

	MainContainer = React.createClass
		render: ->
			<section className="main-container">
				<PageHeader />
				<div className="content">
					<Search />
					<Quests quests={quests} />
				</div>
				<footer className="page-footer"></footer>
			</section>

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
			data = navMenuData.map (ul) ->
				<ul>
					{ ul.map (li) -> <li><a href={li.href}>{li.text}</a></li> }
				</ul>
			<nav className="nav-menu">
					<header>
						<h1>Nitive</h1>
						<svg />
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
		render: ->
			<div className="wrap">
				<NavMenu />
				<MainContainer quests={@props.quests} />
				<RatingMenu />
			</div>


	React.render <Page />, document.body
