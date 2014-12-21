`import Ember from 'ember'`

IssueIndexController = Ember.ObjectController.extend
  isEditing: false

  newFeature: Ember.computed '', (key, value) ->
    newFeature = @store.createRecord 'feature'

    if arguments.length > 1
      newFeature = value

    newFeature

  actions:
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

`export default IssueIndexController`
