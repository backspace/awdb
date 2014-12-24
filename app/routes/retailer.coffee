`import Ember from 'ember'`

RetailerRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'entity', params.retailer_id

`export default RetailerRoute`
