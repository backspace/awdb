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

  newFeaturesToSave: Ember.computed.filterBy 'featuresToSave', 'isNew'

  actions:
    edit: ->
      @set 'isEditing', true

    doneEditing: ->
      @set 'isSaving', true
      @get('model').save().then =>
        featuresToSave = @get 'featuresToSave'

        finish = =>
          @set 'featuresToSave', []
          @set 'isSaving', false
          @set 'isEditing', false

        finish() unless featuresToSave?

        saveNextFeature = =>
          feature = featuresToSave?.shiftObject()

          if feature?
            defer = Ember.RSVP.defer()
            context =
              promise: defer
              feature: feature

            defer.promise.then ->
              saveNextFeature()

            @send 'actuallySaveFeature', context
          else
            finish()

        saveNextFeature()


    revertEditing: ->
      model = @get('model')

      if model.get('isNew')
        model.deleteRecord()

        @transitionToRoute 'issues'
      else
        model.rollback()

        featuresToSave = @get 'featuresToSave'

        featuresToSave?.forEach (feature) ->
          feature.rollback()

        @set 'featuresToSave', []

      @set 'isEditing', false

    saveFeature: (context) ->
      promise = context.promise
      feature = context.feature

      featuresToSave = @get 'featuresToSave'

      # TODO ?! during new feature compensation distribution test, was getting a new feature with no attributes
      if (Ember.isEmpty(Ember.keys(feature.changedAttributes())) && feature.get('contributions.length') == 0) || featuresToSave?.contains(feature)
        promise.resolve()
        return

      unless featuresToSave?
        featuresToSave = []
        @set 'featuresToSave', featuresToSave

      featuresToSave.pushObject feature

      if feature.get('isNew')
        @set 'newFeature', @store.createRecord 'feature'

      promise.resolve()

    actuallySaveFeature: (context) ->
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
        feature.save().then ->
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

    buildDistribution: ->
      @transitionToRoute 'issue.distribute', @get('model')

    buildPrinting: ->
      @transitionToRoute 'issue.printings.new', @get('model')

`export default IssueIndexController`
