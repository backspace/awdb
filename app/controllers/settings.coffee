`import Ember from 'ember'`

SettingsController = Ember.ObjectController.extend
  url: ''
  isReplicating: false

  actions:
    replicate: ->
      pouch = @container.lookup 'pouch:main'

      @set 'isReplicating', true

      pouch.replicate.to(@get('url')).on('complete', =>
        @set 'isReplicating', false
      ).on('error', (info) =>
        alert "There was an error! Obscure error message: #{JSON.stringify(info)}"
        @set 'isReplicating', false
      )

`export default SettingsController`
