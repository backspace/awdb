`import Ember from 'ember'`

EntitySubscriptionList = Ember.Component.extend
  subscriptionsSort: ['createdAt:desc']
  subscriptions: Ember.computed.sort 'entity.subscriptions', 'subscriptionsSort'

`export default EntitySubscriptionList`
