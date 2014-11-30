`import Ember from 'ember'`

PersonController = Ember.ObjectController.extend
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

`export default PersonController`
