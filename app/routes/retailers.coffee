`import Ember from 'ember'`

RetailersRoute = Ember.Route.extend
  model: ->
    @store.find('entity')

  actions:
    createRetailer: ->
      retailer = @store.createRecord 'entity', {isRetailer: true}
      @transitionTo 'retailer', retailer

`export default RetailersRoute`
