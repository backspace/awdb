`import Ember from 'ember'`

EntitySearch = Ember.Component.extend
  search: ''

  searchResults: Ember.computed 'search', 'entities', ->
    search = @get 'search'

    if search
      @get('entities').filter (entity) ->
        entity.get('name').indexOf(search) > -1
    else
      []

  actions:
    addEntity: (entity) ->
      @sendAction 'addEntity', entity

`export default EntitySearch`
