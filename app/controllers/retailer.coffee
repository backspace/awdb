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

`export default RetailerController`
