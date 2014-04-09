app = angular.module 'selectize', []

NG_OPTIONS_REGEXP = /^\s*([\s\S]+?)(?:\s+as\s+([\s\S]+?))?(?:\s+group\s+by\s+([\s\S]+?))?\s+for\s+(?:([\$\w][\$\w]*)|(?:\(\s*([\$\w][\$\w]*)\s*,\s*([\$\w][\$\w]*)\s*\)))\s+in\s+([\s\S]+?)(?:\s+track\s+by\s+([\s\S]+?))?$/

sortedKeys = (obj) ->
	keys = []
	for key of obj
		keys.push key  if obj.hasOwnProperty(key)
	keys.sort()

app.directive 'selectize', ($parse) ->
	require: '?ngModel'
	link:(scope, element, attributes, ngModel) ->
		optionsExp = attributes.selectize
		match = optionsExp.match(NG_OPTIONS_REGEXP)

		displayFn = $parse(match[2] or match[1])
		valueName = match[4] or match[6]
		keyName = match[5]
		groupByFn = $parse(match[3] or "")
		valueFn = $parse((if match[2] then match[1] else valueName))
		valuesFn = $parse(match[7])
		track = match[8]
		trackFn = (if track then $parse(match[8]) else null)

		values = valuesFn(scope)
		# options = ({'id':value, 'title':value} for value in values)

		index = 0

		keys = if keyName then sortedKeys(values) else values

		options = []

		locals = {}
		for key,index in keys
			if keyName
				key = keys[index]
				continue if key.charAt(0) is "$"
				locals[keyName] = key
			else
				key = index

			locals[valueName] = values[key]
			# optionGroupName = groupByFn(scope, locals) or ""

			# unless optionGroup = optionGroups[optionGroupName]
			# 	optionGroup = optionGroups[optionGroupName] = []
			# 	optionGroupNames.push optionGroupName

			label = displayFn(scope, locals) # what will be seen by the user
			value = valueFn(scope, locals)
			options.push
				id: value
				title: label

		# keys = if keyName then sortedKeys(values) else values

		# locals = {}
		# for key,index in keys
		# 	locas[]

		element.selectize
			valueField: 'id'
			labelField: 'title'
			searchField: ['title']
			options: options
			# [
			# 	{'id':'yes', 'title':'yes'}
			# 	{'id':'no', 'title':'no'}
			# 	{'id':'maybe', 'title':'maybe'}
			# ]
			create: false

		return unless ngModel

		element.on 'change', ->
			scope.$apply ->
				ngModel.$setViewValue element.val()

		ngModel.$render = ->
			element.setValue ngModel.$viewValue