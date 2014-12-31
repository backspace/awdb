`import Ember from 'ember'`
`import SetPropertyOnModelChange from '../mixins/set-property-on-model-change'`

EntityController = Ember.ObjectController.extend SetPropertyOnModelChange,
  isEditing: false

  setPropertyOnModelChange:
    property: 'isEditing'
    value: false

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

    revertEditing: ->
      model = @get('model')

      if model.get 'isNew'
        model.deleteRecord()
      else
        model.rollback()

      @set 'isEditing', false

    edit: ->
      @set 'isEditing', true

    subscribe: ->
      subscription = @get('newSubscription')
      subscription.set 'entity', @get('model')
      subscription.save().then =>
        @get('model').save()

`export default EntityController`
