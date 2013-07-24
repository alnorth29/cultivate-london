c = (tagName, cls) ->
  $("<#{tagName}></#{tagName}>").addClass(cls)

getLi = (text, searchString) ->
  index = text.toLowerCase().indexOf searchString.toLowerCase()
  li = c('li')
  if searchString and searchString.length > 0
    if index > 0
      li.append c('span').text text.substr(0, index)
    li.append c('span').addClass('highlight').text text.substr(index, searchString.length)
    li.append c('span').text text.substr(index + searchString.length)
  else
    li.text text
  li

ko.bindingHandlers.autocomplete =
  init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    values = valueAccessor()
    visible = ko.observable false
    search = ko.observable()
    resultsDisplay = c('div', 'autocomplete-results')
    results = ko.computed ->
      searchString = search()
      if not searchString
        values
      else
        _.filter values, (val) ->
          val.toLowerCase().indexOf(searchString.toLowerCase()) >= 0

    results.subscribe ->
      r = results()
      if r.length > 0
        ul = c('ul').append(
          _.map r, (res) ->
            getLi(res, search())
              .click -> $(element).val(res)
        )
        resultsDisplay.html ul
      else
        resultsDisplay.html c('div', 'no-results').text('No results')

    resultsDisplay.insertAfter(element)
    search(allBindingsAccessor().value())
    onchange = -> search($(element).val())
    $(element).keyup(onchange).change(onchange)