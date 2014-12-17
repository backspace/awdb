`import Ember from 'ember'`

IssueIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'issue'

  afterModel: ->
    @store.find('person').then (result) =>
      @set 'people', result

  setupController: (controller, model) ->
    @_super controller, model

    if Ember.isNone(model.get('title'))
      # FIXME cannot call 'send', duplicating edit action
      controller.set 'isEditing', true

    controller.set 'people', @get('people')

  actions:
    edit: ->
      @controller.set 'isEditing', true

      return undefined

    doneEditing: ->
      @modelFor('issue').save().then =>
        @controller.set 'isEditing', false

      return undefined

`export default IssueIndexRoute`
