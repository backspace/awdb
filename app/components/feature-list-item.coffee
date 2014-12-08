`import Ember from 'ember'`

FeatureListItem = Ember.Component.extend
  tagName: 'li'

  isEditing: Ember.computed.alias('feature.isNew')

  actions:
    save: ->
      @sendAction 'save'

`export default FeatureListItem`
