`import Ember from 'ember'`

EntityController = Ember.ObjectController.extend
  isEditing: false

  editing: (->
    @get('model.isNew') || @get('isEditing')
  ).property('model.isNew', 'isEditing')

  actions:
    doneEditing: ->
      @get('model').save()
      @set 'isEditing', false

      return @get('model')

    edit: ->
      @set 'isEditing', true

    addSubscription: (count) ->
      @store.createRecord('subscription', {entity: @get('model'), count: count}).save().then (subscription) =>
        entity = @get('model')
        entity.get('subscriptions').addObject(subscription)
        entity.save()

`export default EntityController`
