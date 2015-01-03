initializer =
  name: 'cookie-injector'
  after: ['cookie']

  initialize: (container, application) ->
    application.inject 'controller', 'cookie', 'cookie:main'
    application.inject 'component', 'cookie', 'cookie:main'

`export default initializer`
