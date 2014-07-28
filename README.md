(work in progress)

Simple Pointer Lock API

For Chrome(webkit) and Firefox(Gecko) browsers.


	Pointer = require 'simple-pointer-lock-api'

	pointer = new Pointer

	pointer
	.on 'start', =>

		console.log 'start'

	.on 'firstMove', =>

		console.log 'firstMove'

	.on 'move', (event) =>

		console.log 'move'

		console.log event

	.on 'end', =>

		console.log 'end'


	document.addEventListener 'click', =>

		pointer.request(document.body)

		# or this will force end:
		# pointer.release()