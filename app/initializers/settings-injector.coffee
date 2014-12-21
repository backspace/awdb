initializer =
  name: 'settings-injector'
  after: ['pouch']

  initialize: (container, application) ->
    store = container.lookup 'store:main'

    store.find('settings').then (allSettings) ->
      settings = allSettings.get 'firstObject'

      unless settings?
        settings = store.createRecord 'settings'
        settings.save()

      application.register 'settings:main', settings, {instantiate: false}
      # FIXME this doesn't work
      application.inject 'model', 'settings', 'settings:main'

`export default initializer`
