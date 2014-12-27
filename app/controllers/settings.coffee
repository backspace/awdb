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

  replacementUrl: Ember.computed('', (key, value, previousValue) ->
    cookie = @get 'cookie'

    # setter
    if arguments.length > 1
      cookie.setCookie 'replacement-url', value

    cookie.getCookie 'replacement-url'
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

    replace: ->
      if confirm("Are you sure you want to erase the current database and replace it with the one at #{@get('replacementUrl')}?")
        @set 'isReplacing', true

        pouch = @container.lookup 'pouch:main'
        databaseName = pouch._db_name

        replacementName = @get('replacementUrl')

        pouch.destroy().then =>
          new PouchDB(databaseName).then (newPouch) =>
            pouch = newPouch
            pouch.replicate.from(replacementName).on('complete', =>
              console.log "??"
              @set 'isReplacing', false
              document.location.reload()
            ).on('error', (info) =>
              alert "Error: #{JSON.stringify(info)}"
            )
      else

    save: (callback) ->
      promise = @get('model').save()
      callback(promise)

`export default SettingsController`
