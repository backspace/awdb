`import Ember from 'ember'`

RetailersController = Ember.ArrayController.extend
  retailers: Ember.computed.filterBy('model', 'isRetailer')

  activeRetailers: Ember.computed.filterBy 'retailers', 'isSubscribed'

  inactiveRetailers: Ember.computed.filterBy 'retailers', 'isNotSubscribed'

`export default RetailersController`
