`import Ember from 'ember'`

IssueIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'issue'

  afterModel: ->
    @store.find('entity').then (result) =>
      @set 'entities', result

  setupController: (controller, model) ->
    @_super controller, model

    if Ember.isNone(model.get('title'))
      # FIXME cannot call 'send', duplicating edit action
      controller.set 'isEditing', true

    controller.set 'entities', @get('entities')

  actions:
    edit: ->
      @controller.set 'isEditing', true

      return undefined

    doneEditing: ->
      @modelFor('issue').save().then =>
        @controller.set 'isEditing', false

      return undefined

`export default IssueIndexRoute`
