`import config from '../config/environment'`

initializer =
  name: 'pouch'
  before: ['store']

  initialize: (container, app) ->
    pouch = new PouchDB(config.APP.databaseName)

    adapter = EmberPouch.Adapter.extend
      db: pouch

    app.register 'adapter:application', adapter

`export default initializer`
