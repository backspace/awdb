`import Ember from 'ember'`

IssueIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'issue'

  afterModel: ->
    @store.find('entity').then (result) =>
      @set 'entities', result

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'entities', @get('entities')

`export default IssueIndexRoute`
