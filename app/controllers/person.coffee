`import Ember from 'ember'`

PersonController = Ember.ObjectController.extend
  actions:
    doneEditing: ->
      @get('model').save()

`export default PersonController`
