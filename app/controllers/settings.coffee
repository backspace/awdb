`import Ember from 'ember'`

SettingsController = Ember.ObjectController.extend
  url: ''

  actions:
    replicate: ->
      pouch = @container.lookup 'pouch:main'
      pouch.replicate.to @get('url')

`export default SettingsController`
