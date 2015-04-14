# fix first scroll
$(->
	$('.menu-toggle').click(->
		$('.main-container').toggleClass 'opened-menu'
	)
) if $?
