if $? then $ ->
	quests = [
		{
			title: "Sudoku"
			author: "sea-kg"
			subject: "crypto"
			text: "Necessitatibus facere excepturi fuga cum tenetur ipsa corporis perferendis deleniti deserunt, officia expedita saepe voluptate aperiam non."
			file: null
			score: 100
			solved: 8
		}
		{
			title: "Terrorists"
			author: "by.smirnowmaks"
			subject: "forensic"
			text: "Doloribus expedita hic reiciendis eum, at ab consectetur quidem ducimus sequi, consequuntur eos quas dignissimos incidunt assumenda dicta et quisquam tenetur. Vitae, mollitia fuga sequi omnis, sint earum possimus odit cumque? Nulla?"
			file: null
			score: 200
			solved: 14
		}
		{
			title: "Maximus"
			author: "IS_Chaser"
			subject: "forensic"
			text: "Provident voluptatibus consequatur a modi, accusamus molestiae atque debitis repellendus nostrum rerum dolores quas ipsam ex obcaecati necessitatibus nulla quasi. Temporibus cumque perspiciatis omnis molestiae praesentium rem mollitia, necessitatibus ipsam, vero ut."
			file: null
			score: 500
			solved: 0
		}
		{
			title: "Mikki"
			author: "sea-kg"
			subject: "reverse"
			text: "Sed obcaecati recusandae, molestiae eos suscipit quod, natus dolorem facilis ipsam sunt, inventore aut."
			file: null
			score: 300
			solved: 123
		}
		{
			title: "Aliens"
			author: "sea-kg"
			subject: "stego"
			text: "Quos ullam, tempore asperiores quae provident debitis ut repellat excepturi sapiente voluptatum illum magnam, ab saepe accusantium earum voluptatibus quibusdam eaque."
			file: null
			score: 500
			solved: 999
		}
		{
			title: "Small data"
			author: "sea-kg"
			subject: "ppc"
			text: "Assumenda ipsa ex nisi illum impedit, minima quod deleniti enim."
			file: null
			score: 200
			solved: 214552
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
				text: "Starred"
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
			sn.path "M 2,10 L 17,24 32,10"
				.attr
					fill: "none"
					stroke: "#343d46"
					strokeWidth: 3.0

			sm = Snap React.findDOMNode @refs.submit
			bg = sm.rect 0, 0, 50, 32
				.attr
					fill: "none"
					opacity: 0
			g = do sm.g
			g.transform "T13,6"
			path = g.path "M 21,0 L 9,13 3,7 0,10 9,19 24,3 21,0 Z"
				.attr
					fill: "#343d46"

			smClicking = no
			sm.hover (->
				if smClicking then return
				path.animate
					fill: "#00e090"
					300
					mina.ease
				bg.animate
					fill: "#232831"
					opacity: 1
					300
					mina.ease
			), ->
				if smClicking then return
				path.animate
					fill: "#232831"
					300
					mina.ease
				bg.animate
					fill: "none"
					opacity: 0
					300
					mina.ease

			sm.mousedown (e) ->
				if smClicking then return
				smClicking = yes
				rightFlag = Math.random() > .5
				bg.stop()
				path.stop()
				bgColor =
				if rightFlag then "#00e090" else "#f22e3e"
				path.attr
					fill: "#fff"
				bg.attr
					fill: bgColor
				.animate
					opacity: 1
					500
					mina.lineal
				path.animate
					transform: "s 1.3,1.3"
					1000
					mina.elastic
					->
						@animate
							fill: "#232831"
							transform: "s 1,1",
							100
							mina.lineal
						bg.animate
							opacity: 0
							100
							mina.lineal
							->
								smClicking = no

		render: ->
			quest = quests[@props.id]
			<article>
				<h4 data-info="#{quest.subject} #{quest.score}" data-author="by #{quest.author}">{quest.title}<sup>{quest.solved}</sup></h4>
				<div className="download" />
				<p>{quest.text}</p>
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
			data = quests.map (a, i) -> <Quest id=i />
			<div className="quests">
				<div>
					{data[..(data.length // 2 - 1)]}
				</div>
				<div>
					{data[(data.length // 2)..]}
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
					<Quests />
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
