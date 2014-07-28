vendors = ['', 'webkit', 'moz']

module.exports = class MouseLock

	constructor: ->

		@x = 0
		@y = 0

		@firstTime = yes

		do @_handleEvents

		@_events = {}

	_handleEvents: =>

		for vendor in vendors

			document.addEventListener vendor + 'pointerlockchange', @_lockChange, false

			document.addEventListener vendor + 'pointerlockerror', @_lockError, false

		return

	_lockError: (event) =>

		@_events.error(event) if @_events.error?

		return

	_lockChange: (event) =>

		if document.pointerLockElement is @div || document.mozPointerLockElement is @div || document.webkitPointerLockElement is @div

			document.addEventListener "mousemove", @_mouseMoveListener, false

			@_events.start() if @_events.start?

		else

			document.removeEventListener "mousemove", @_mouseMoveListener, false

			@_events.end() if @_events.end?

			@firstTime = yes

			@x = 0
			@y = 0

		return

	_mouseMoveListener: (e) =>

		if @firstTime

			@clientX = e.clientX
			@clientY = e.clientY

			@layerX = e.layerX
			@layerY = e.layerY

			@pageX = e.pageX
			@pageY = e.pageY

			@offsetX = e.offsetX
			@offsetY = e.offsetY

			@screenX = e.screenX
			@screenY = e.screenY


			returnEvent =

				clientX: @clientX
				clientY: @clientY

				layerX: @layerX
				layerY: @layerY

				pageX: @pageX
				pageY: @pageY

				offsetX: @offsetX
				offsetY: @offsetY

				screenX: @screenX
				screenY: @screenY

				movementX: movementX
				movementY: movementY

				x: @x
				y: @y


			@_events.firstMove(returnEvent) if @_events.firstMove?

			@firstTime = no

		movementX = e.movementX || e.mozMovementX || e.webkitMovementX ||	0
		movementY = e.movementY || e.mozMovementY || e.webkitMovementY ||	0

		@x += movementX
		@y += movementY

		returnEvent =

			clientX: @clientX + @x
			clientY: @clientY + @y

			layerX: @layerX + @x
			layerY: @layerY + @y

			pageX: @pageX + @x
			pageY: @pageY + @y

			offsetX: @offsetX + @x
			offsetY: @offsetY + @y

			screenX: @screenX + @x
			screenY: @screenY + @y

			movementX: movementX
			movementY: movementY

			x: @x
			y: @y

		@_events.move(returnEvent) if @_events.move?

		return

	request: (@div) =>

		@div.requestPointerLock =  @div.requestPointerLock || @div.mozRequestPointerLock || @div.webkitRequestPointerLock

		do @div.requestPointerLock

		@

	release: =>

		document.exitPointerLock = document.exitPointerLock || document.mozExitPointerLock || document.webkitExitPointerLock

		do document.exitPointerLock

		@

	on: (job, callback) =>

		@_events[job] = callback

		@