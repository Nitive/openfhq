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
			title: "Minimized task"
			author: "sea-kg"
			subject: "forensic"
			text: "Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. In imperdiet eros id lacus vestibulum vestibulum."
			file: null
			score: 200
		}
	]

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

	Quest = React.createClass
		render: ->
			<article className="quest">
				Lorem ipsum dolor sit amet, consectetur adipisicing elit. Fugiat sequi, ex natus.
			</article>

	Quests = React.createClass
		render: ->
			<section className="main-container">
				<header className="page-header">
					<div className="menu-toggle" />
				</header>
				<div className="search ios-search-field" />
				<div className="quests">
					{
						@props.quests.map ->
							<Quest />
					}
				</div>
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



	Page = React.createClass
		componentDidMount: ->
			s = Snap "#toggle-extra-menu"
			Snap.load "images/toggle-extra-menu.svg", (f) ->
				g = f.select "g"
				s.append g
		render: ->
			<div className="wrap">
				<NavMenu />
				<Quests quests={@props.quests} />
				<aside className="info-menu"></aside>
			</div>


	React.render <Page quests={quests} />, document.body
