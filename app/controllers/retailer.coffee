`import Ember from 'ember'`

RetailerController = Ember.ObjectController.extend
  requestedEditing: false

  resetEditingOnModelChange: Ember.observer 'model.id', ->
    newID = @get 'model.id'

    if newID != @oldID
      @set 'requestedEditing', false
      @oldID = newID

  isEditing: Ember.computed.any 'model.isNew', 'requestedEditing'

  newSubscription: Ember.computed 'model.isRetailer', 'model.isNew', ->
    @store.createRecord 'subscription', {count: 999}

  actions:
    doneEditing: ->
      model = @get('model')
      if model.get('isNew')
        model.save().then =>
          @transitionToRoute 'retailer', model
      else
        model.save().then =>
          @set 'requestedEditing', false

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
