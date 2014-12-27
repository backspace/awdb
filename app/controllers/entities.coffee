`import Ember from 'ember'`

EntitiesController = Ember.ArrayController.extend
  subscribers: Ember.computed.filterBy('model', 'isSubscribed')
  formerSubscribers: Ember.computed.filterBy('model', 'isFormerSubscriber')

  persistedEntities: Ember.computed.filterBy 'model', 'isNew', false

`export default EntitiesController`
