`import Ember from 'ember'`

RetailerController = Ember.ObjectController.extend
  requestedEditing: false

  isEditing: Ember.computed.any 'model.isNew', 'requestedEditing'

  actions:
    doneEditing: ->
      @get('model').save()
      @set 'requestedEditing', false

      @get 'model'

    edit: ->
      @set 'requestedEditing', true

    subscribe: ->
      retailer = @get 'model'
      subscription = @store.createRecord('subscription', {entity: retailer, count: 999})
      subscription.save().then (subscription) ->
        retailer.get('subscriptions').addObject subscription
        retailer.save()

    endSubscription: ->
      retailer = @get 'model'
      subscription = retailer.get 'activeSubscription'

      subscription.end()

`export default RetailerController`
