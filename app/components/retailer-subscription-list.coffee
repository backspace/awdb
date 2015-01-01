`import Ember from 'ember'`

RetailerSubscriptionList = Ember.Component.extend
  subscriptionsSort: ['createdAt:desc']
  subscriptions: Ember.computed.sort 'retailer.subscriptions', 'subscriptionsSort'

  actions:
    save: ->
      @sendAction 'save'

    end: ->
      @sendAction 'end'

`export default RetailerSubscriptionList`
