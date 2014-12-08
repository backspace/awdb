`import Ember from 'ember'`

FeatureListItem = Ember.Component.extend
  tagName: 'li'

  actions:
    save: ->
      @sendAction 'save'

`export default FeatureListItem`
