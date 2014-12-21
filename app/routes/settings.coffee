`import Ember from 'ember'`

SettingsRoute = Ember.Route.extend
  model: ->
    @container.lookup 'settings:main'

`export default SettingsRoute`
