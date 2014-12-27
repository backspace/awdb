`import Ember from 'ember'`

EntitiesController = Ember.ArrayController.extend
  subscribers: Ember.computed.filterBy('persistedEntities', 'isSubscribed')
  formerSubscribers: Ember.computed.filterBy('persistedEntities', 'isFormerSubscriber')
  neverSubscribers: Ember.computed.filterBy('persistedEntities', 'isNeverSubscriber')

  nonRetailers: Ember.computed.filterBy 'model', 'isRetailer', false
  persistedEntities: Ember.computed.filterBy 'nonRetailers', 'isNew', false

`export default EntitiesController`
