`import Ember from 'ember'`
`import config from '../config/environment'`

IndexController = Ember.ArrayController.extend
  displayWelcome: Ember.computed 'hasVisited', ->
    return false if Ember.testing

    !@get 'hasVisited'

  hasVisited: Ember.computed('', (key, value, previousValue) ->
    cookie = @get 'cookie'

    if arguments.length > 1
      cookie.setCookie 'has-visited', value

    cookie.getCookie 'has-visited'
  )

  actions:
    rejectSample: ->
      @set 'hasVisited', true

    acceptSample: ->
      # TODO this is copied from SettingsController
      @set 'replacing', true

      pouch = @container.lookup 'pouch:main'
      databaseName = pouch._db_name

      replacementName = config.APP.sampleDatabase

      pouch.destroy().then(=>
        new PouchDB(databaseName).then((newPouch) =>
          pouch = newPouch
          pouch.replicate.from(replacementName).on('complete', =>
            @set 'hasVisited', true
            @set 'isReplacing', false
            document.location.reload()
          ).on('error', (info) ->
            alert "Error: #{JSON.stringify(info)}"
          )
        , (error) ->
          alert "Error creating new database: #{JSON.stringify(info)}"
        )
      , (error) ->
        alert "Error deleting current database: #{JSON.stringify(info)}"
      )

`export default IndexController`
