# fix first scroll
window.scrollBy(0, 1);
$(->
	$('.menu-toggle').click(->
		$('.main-container').toggleClass 'opened-menu'
	)
) if $?
