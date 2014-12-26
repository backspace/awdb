`import Ember from 'ember'`

EntitiesRoute = Ember.Route.extend
  model: ->
    @store.find 'entity'

  actions:
    createEntity: ->
      @transitionTo('entities.new')

`export default EntitiesRoute`
