`import Ember from 'ember'`

NewMailoutRoute = Ember.Route.extend
  model: (params) ->
    # FIXME hack to ensure entities are loaded even upon refresh

    mailout = @store.createRecord 'mailout', {issue: @modelFor('issue')}

    Ember.RSVP.hash
      issue: @store.find 'issue', @paramsFor('issue').issue_id
      mailout: mailout
      entities: @store.find 'entity'

  actions:
    showMailout: (mailout) ->
      @transitionTo 'issue.mailouts.mailout', mailout
      undefined

`export default NewMailoutRoute`
