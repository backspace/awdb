`import Ember from 'ember'`

FeatureListItem = Ember.Component.extend
  tagName: 'li'

  isEditing: Ember.computed.alias('feature.isNew')

  actions:
    save: ->
      @sendAction 'save'

  titleAndContributors: Ember.computed 'feature.title', 'feature.contributors.@each.name', ->
    string = @get('feature.title')

    if Ember.isPresent(@get('feature.contributors'))
      string = "#{string}: #{@get('feature.contributors').mapBy('name').join(', ')}"

    string

`export default FeatureListItem`
