`import Ember from 'ember'`

RetailersRoute = Ember.Route.extend
  model: ->
    @store.find('entity')

  actions:
    createRetailer: ->
      @transitionTo 'retailers.new'

`export default RetailersRoute`
