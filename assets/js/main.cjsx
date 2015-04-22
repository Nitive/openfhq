# React

L = React.DOM

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
			{
				@props.quests.map ->
					<Quest />
			}
		</div>

React.render <Quests quests={quests} />, document.getElementsByClassName('quests')[0]


