`import Ember from 'ember'`

RetailersRoute = Ember.Route.extend
  model: ->
    @store.find 'retailer'

  actions:
    createRetailer: ->
      retailer = @store.createRecord 'retailer'
      @transitionTo 'retailer', retailer

`export default RetailersRoute`
