`import Ember from 'ember'`

PeopleRoute = Ember.Route.extend
  model: ->
    @store.find 'person'

`export default PeopleRoute`
