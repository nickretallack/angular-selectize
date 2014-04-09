app = angular.module 'selectize', []

NG_OPTIONS_REGEXP = /^\s*([\s\S]+?)(?:\s+as\s+([\s\S]+?))?(?:\s+group\s+by\s+([\s\S]+?))?\s+for\s+(?:([\$\w][\$\w]*)|(?:\(\s*([\$\w][\$\w]*)\s*,\s*([\$\w][\$\w]*)\s*\)))\s+in\s+([\s\S]+?)(?:\s+track\s+by\s+([\s\S]+?))?$/

app.directive 'selectize', ($parse) ->
	require: '?ngModel'
	link:(scope, element, attributes, ngModel) ->
		optionsExp = attributes.selectize
		match = optionsExp.match(NG_OPTIONS_REGEXP)

		# displayFn = $parse(match[2] or match[1])
		# valueName = match[4] or match[6]
		# keyName = match[5]
		# groupByFn = $parse(match[3] or "")
		# valueFn = $parse((if match[2] then match[1] else valueName))
		# valuesFn = $parse(match[7])
		# track = match[8]
		# trackFn = (if track then $parse(match[8]) else null)

		element.selectize
			valueField: 'id'
			labelField: 'title'
			searchField: ['title']
			options: [
				{'id':'yes', 'title':'yes'}
				{'id':'no', 'title':'no'}
				{'id':'maybe', 'title':'maybe'}
			]
			create: false

		# editor = ace.edit element[0]
		# editor.focus() # greedy focus
		# editor.setFontSize 13
		# editor.setTheme("ace/theme/monokai")

		# session = editor.getSession()
		# session.setMode("ace/mode/javascript")

		# # attributes.$observe 'syntax', (syntax) ->
		# #     if syntax and syntax isnt 'plain'
		# #         SyntaxMode = require("ace/mode/#{syntax}").Mode
		# #         session.setMode new SyntaxMode()

		# # set up data binding
		# return unless ngModel

		# changing = false
		# ngModel.$render = ->
		# 	changing = true
		# 	session.setValue ngModel.$viewValue or ''
		# 	changing = false

		# read = -> ngModel.$setViewValue session.getValue()
		# session.on 'change', -> scope.$apply read unless changing
