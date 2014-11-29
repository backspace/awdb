`import Ember from 'ember'`

PeopleRoute = Ember.Route.extend
  model: ->
    @store.find 'person'

  actions:
    createPerson: ->
      person = @get('store').createRecord 'person'
      @transitionTo('person', person)

`export default PeopleRoute`
