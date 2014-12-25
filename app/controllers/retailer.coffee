`import Ember from 'ember'`

RetailerController = Ember.ObjectController.extend
  requestedEditing: false

  isEditing: Ember.computed.any 'model.isNew', 'requestedEditing'

  newSubscription: Ember.computed 'model.isRetailer', 'model.isNew', ->
    @store.createRecord 'subscription', {count: 999}

  actions:
    doneEditing: ->
      @get('model').save()
      @set 'requestedEditing', false

      @get 'model'

    edit: ->
      @set 'requestedEditing', true

    subscribe: ->
      subscription = @get('newSubscription')
      subscription.set 'entity', @get('model')
      subscription.save().then =>
        @get('model').save()

    endSubscription: ->
      retailer = @get 'model'
      subscription = retailer.get 'activeSubscription'

      subscription.end()

`export default RetailerController`
