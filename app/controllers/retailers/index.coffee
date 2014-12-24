`import Ember from 'ember'`

RetailersController = Ember.ArrayController.extend
  retailers: Ember.computed.filterBy('model', 'isRetailer')

`export default RetailersController`
