`import Ember from 'ember'`

EntitySearch = Ember.Component.extend
  search: ''

  searchResults: Ember.computed 'search', 'entities', ->
    search = @get 'search'

    if search
      search = search.toLowerCase()
      @get('entities').filter (entity) ->
        entity.get('name').toLowerCase().indexOf(search) > -1
    else
      []

  actions:
    addEntity: (entity) ->
      @sendAction 'addEntity', entity

`export default EntitySearch`
