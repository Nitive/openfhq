# React

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

Quest = React.createClass
	render: ->
		<article className="quest">
			Lorem ipsum dolor sit amet, consectetur adipisicing elit. Fugiat sequi, ex natus.
		</article>

Quests = React.createClass
	render: ->
		<div>
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
		</div>

React.render <Quests quests={quests} />, document.querySelector('.main-container')


		# <header className="page-header">
		# 	<div className="menu-toggle"></div>
		# </header>
		# <div className="search ios-search-field"></div>
		# <div className="quests">
		# 	{
		# 		@props.quests.map ->
		# 			<Quest />
		# 	}
		# </div>
		# <footer className="page-footer"></footer>
