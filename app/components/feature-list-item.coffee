`import Ember from 'ember'`

FeatureListItem = Ember.Component.extend
  tagName: 'li'
  classNameBindings: ['isNew:js-new:js-persisted']

  # FIXME seems pretty messy

  isNew: Ember.computed.alias('feature.isNew')
  isEditing: false

  placeholder: Ember.computed 'isNew', ->
    if @get 'isNew'
      "New feature title"
    else
      "Feature title"

  setIsEditing: (->
    @set 'isEditing', @get('isNew')
  ).on 'init'

  resetIsEditing: (->
    @setIsEditing()
  ).observes 'feature.id'

  contributions: Ember.computed 'feature.contributions', ->
    contributionsWithNew = Ember.copy(@get('feature.contributions').mapBy('.'))
    contributionsWithNew.pushObject(@get('newContribution'))

    contributionsWithNew

  newContribution: null,
  setNewContribution: Ember.on 'init', ->
    @set 'newContribution', Ember.Object.create({entity: Ember.Object.create({id: null})})

  appendNewContribution: Ember.observer 'newContribution.entity.id', ->
    if @get('newContribution.entity.id')
      @get('feature').appendNewContributor(@get('newContribution.entity.id'))
      @setNewContribution()

  actions:
    save: ->
      # Pattern from http://stackoverflow.com/a/20810854/760389
      defer = Ember.RSVP.defer()
      defer.promise.then(=>
        # TODO the isDestroyed/isDestroying checks are only for testing, seems weird
        @set 'isEditing', false unless @get('isDestroyed') || @get('isDestroying') || @get('isNew')
      , ->
        alert "An error saving the feature!"
      )

      @sendAction 'save',
        promise: defer
        feature: @get('feature')

    cancel: ->
      @get('feature').rollback()
      @set 'isEditing', false
    edit: ->
      @set 'isEditing', true

    addContributor: (contributor) ->
      @set 'newContribution.entity.id', contributor.id

  titleAndContributors: Ember.computed 'feature.title', 'feature.contributors.@each.name', ->
    string = @get('feature.title')

    if Ember.isPresent(@get('feature.contributors'))
      string = "#{string}: #{@get('feature.contributors').mapBy('name').join(', ')}"

    string

`export default FeatureListItem`
