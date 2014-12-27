`import Ember from 'ember'`

EntitiesController = Ember.ArrayController.extend
  subscribers: Ember.computed.filterBy('persistedEntities', 'isSubscribed')
  formerSubscribers: Ember.computed.filterBy('persistedEntities', 'isFormerSubscriber')
  neverSubscribers: Ember.computed.filterBy('persistedEntities', 'isNeverSubscriber')

  persistedEntities: Ember.computed.filterBy 'model', 'isNew', false

`export default EntitiesController`
