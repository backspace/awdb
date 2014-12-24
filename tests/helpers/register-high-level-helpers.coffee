`import Ember from 'ember'`

register = ->
  Ember.Test.registerAsyncHelper 'viewEntities', (app) ->
    visit '/'
    click 'a:contains("Entities")'

  Ember.Test.registerAsyncHelper 'viewEntity', (app, name) ->
    viewEntities()
    click "a:contains('#{name}')"

  Ember.Test.registerAsyncHelper 'viewIssues', ->
    visit '/'
    click 'a:contains("Issues")'

  Ember.Test.registerAsyncHelper 'viewIssue', (app, name) ->
    viewIssues()
    click "a:contains('#{name}')"

  Ember.Test.registerAsyncHelper 'viewRetailers', ->
    visit '/'
    click 'a:contains("Retailers")'

  Ember.Test.registerAsyncHelper 'viewRetailer', (app, name) ->
    viewRetailers()
    click "a:contains('#{name}')"

`export default register`
