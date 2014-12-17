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

        feature.set 'issue', issue
        feature.save().then =>
          @set 'newFeature', @store.createRecord 'feature'
          issue.get('features').pushObject feature

          issue.save().then ->
            promise.resolve()
      else
        feature.save().then ->
          promise.resolve()

`export default IssueIndexController`
