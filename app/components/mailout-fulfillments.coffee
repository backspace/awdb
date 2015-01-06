`import Ember from 'ember'`

MailoutFulfillments = Ember.Component.extend
  subscription: Ember.computed.filterBy 'fulfillments', 'isForSubscription'
  retailSubscription: Ember.computed.filterBy 'fulfillments', 'isForRetailSubscription'
  contribution: Ember.computed.filterBy 'fulfillments', 'isForContribution'
  extra: Ember.computed.filterBy 'fulfillments', 'isExtra'

  actions:
    deleteFulfillment: (fulfillment) ->
      @sendAction 'deleteFulfillment', fulfillment

`export default MailoutFulfillments`
