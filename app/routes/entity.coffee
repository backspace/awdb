`import Ember from 'ember'`

EntityRoute = Ember.Route.extend
  model: (params) ->
    @store.find('entity', params.entity_id)

`export default EntityRoute`
