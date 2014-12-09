`import Ember from 'ember'`

FeatureListItem = Ember.Component.extend
  tagName: 'li'
  classNameBindings: ['isNew:js-new:js-persisted']

  # FIXME seems pretty messy

  isNew: Ember.computed.alias('feature.isNew')
  isEditing: false

  setIsEditing: (->
    @set 'isEditing', @get('isNew')
  ).on 'init'

  resetIsEditing: (->
    @setIsEditing()
  ).observes 'feature.id'

  contributors: Ember.computed 'feature.contributors', ->
    contributorsWithNew = Ember.copy(@get('feature.contributors').mapBy('.'))
    contributorsWithNew.pushObject(@get('newContributor'))

    contributorsWithNew

  newContributor: null,
  setNewContributor: Ember.on 'init', ->
    @set 'newContributor', Ember.Object.create()

  appendNewContributor: Ember.observer 'newContributor.id', ->
    if @get('newContributor.id')
      @get('feature').appendNewContributor(@get('newContributor.id')) 
      @setNewContributor()

  actions:
    save: ->
      if @get('isNew')
        @sendAction 'save'
      else
        @get('feature').save().then =>
          @set 'isEditing', false
    cancel: ->
      @get('feature').rollback()
      @set 'isEditing', false
    edit: ->
      @set 'isEditing', true

  titleAndContributors: Ember.computed 'feature.title', 'feature.contributors.@each.name', ->
    string = @get('feature.title')

    if Ember.isPresent(@get('feature.contributors'))
      string = "#{string}: #{@get('feature.contributors').mapBy('name').join(', ')}"

    string

`export default FeatureListItem`
