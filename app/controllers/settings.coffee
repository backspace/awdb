`import Ember from 'ember'`

SettingsController = Ember.ObjectController.extend
  isReplicating: false

  url: Ember.computed('', (key, value, previousValue) ->
    cookie = @get 'cookie'

    # setter
    if arguments.length > 1
      cookie.setCookie 'replication-url', value

    cookie.getCookie 'replication-url'
  )

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

    save: ->
      @get('model').save()

`export default SettingsController`
