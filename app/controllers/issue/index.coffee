`import Ember from 'ember'`
`import SetPropertyOnModelChange from '../../mixins/set-property-on-model-change'`

IssueIndexController = Ember.ObjectController.extend SetPropertyOnModelChange,
  needs: ['issues']

  entities: Ember.computed.alias 'controllers.issues.entities'

  isEditing: false
  isSaving: false

  setPropertyOnModelChange:
    property: 'isEditing'
    value: false

  handleNewRecord: Ember.observer 'model.isNew', ->
    if @get('model.isNew')
      @set 'wasNew', true
      @set 'isEditing', true
    else if @get('wasNew')
      @transitionToRoute 'issue.index', @get('model')

  newFeature: Ember.computed '', (key, value) ->
    newFeature = @store.createRecord 'feature'

    if arguments.length > 1
      newFeature = value

    newFeature

  actions:
    edit: ->
      @set 'isEditing', true

    doneEditing: ->
      @set 'isSaving', true
      @get('model').save().then =>
        @set 'isSaving', false
        @set 'isEditing', false

    revertEditing: ->
      model = @get('model')

      if model.get('isNew')
        model.deleteRecord()

        @transitionToRoute 'issues'
      else
        model.rollback()

      @set 'isEditing', false

    saveFeature: (context) ->
      promise = context.promise
      feature = context.feature

      if feature.get('isNew')
        issue = @get('model')

        # FIXME convoluted nonsense to work around being unable to save the parent of unsaved children
        contributions = feature.get('contributions')
        storedContributions = []

        until Ember.isEmpty(contributions)
          contribution = contributions.get 'firstObject'
          storedContributions.pushObject contribution
          contribution.set 'feature', undefined

        feature.set 'issue', issue
        feature.save().then =>
          @set 'newFeature', @store.createRecord 'feature'
          issue.get('features').pushObject feature

          issue.save().then ->
            storedContributions.setEach 'feature', feature
            Ember.RSVP.all(storedContributions.invoke('save')).then ->
              feature.save().then ->
                promise.resolve()
      else
        Ember.RSVP.all(feature.get('contributions').invoke('save')).then ->
          feature.save().then ->
            promise.resolve()

    createEntity: (promiseAndAttributes) ->
      promise = promiseAndAttributes.promise
      attributes = promiseAndAttributes.attributes

      entity = @store.createRecord 'entity', attributes

      entity.save().then ->
        promise.resolve(entity)


`export default IssueIndexController`
