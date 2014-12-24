`import Ember from 'ember'`

EntitiesRoute = Ember.Route.extend
  model: ->
    @store.find 'entity'

  actions:
    createEntity: ->
      entity = @get('store').createRecord 'entity'
      @transitionTo('entity', entity)

`export default EntitiesRoute`
