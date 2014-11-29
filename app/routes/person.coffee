`import Ember from 'ember'`

PersonRoute = Ember.Route.extend
  model: (params) ->
    @store.find('person', params.person_id)

`export default PersonRoute`
