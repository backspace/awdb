`import Ember from 'ember'`

SingleFieldForm = Ember.Component.extend
  actions:
    click: ->
      @sendAction 'action'

`export default SingleFieldForm`
