`import Ember from 'ember'`

EntityController = Ember.ObjectController.extend
  isEditing: false

  resetEditingOnModelChange: Ember.observer 'model.id', ->
    newID = @get 'model.id'

    if newID != @oldID
      @set 'isEditing', false
      @oldID = newID

  editing: (->
    @get('model.isNew') || @get('isEditing')
  ).property('model.isNew', 'isEditing')

  newSubscription: Ember.computed 'model.isNew', ->
    @store.createRecord 'subscription'

  actions:
    doneEditing: ->
      model = @get('model')
      if model.get('isNew')
        model.save().then =>
          @transitionToRoute 'entity', model
      else
        model.save().then =>
          @set 'isEditing', false

    edit: ->
      @set 'isEditing', true

    subscribe: ->
      subscription = @get('newSubscription')
      subscription.set 'entity', @get('model')
      subscription.save().then =>
        @get('model').save()

`export default EntityController`
