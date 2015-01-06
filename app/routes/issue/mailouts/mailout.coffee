`import Ember from 'ember'`

MailoutRoute = Ember.Route.extend
  model: (params) ->
    @store.find('mailout', params.mailout_id)

`export default MailoutRoute`
