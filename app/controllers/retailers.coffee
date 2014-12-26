`import Ember from 'ember'`

RetailersController = Ember.ArrayController.extend
  allRetailers: Ember.computed.filterBy('model', 'isRetailer')
  retailers: Ember.computed.filterBy('allRetailers', 'isNew', false)

  activeRetailers: Ember.computed.filterBy 'retailers', 'isSubscribed'

  inactiveRetailers: Ember.computed.filterBy 'retailers', 'isNotSubscribed'

`export default RetailersController`
