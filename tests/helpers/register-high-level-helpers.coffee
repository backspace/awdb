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

  Ember.Test.registerAsyncHelper 'viewTransactions', ->
    visit '/'
    click 'a:contains("Transactions")'

  Ember.Test.registerAsyncHelper 'expectTransaction', (app, attributes) ->
    expectElement "tr:contains(#{attributes.entity})", {contains: attributes.event} if attributes.event?

    debitOrCredit = if attributes.amount < 0 then 'debit' else 'credit'

    expectElement "tr:contains(#{attributes.entity}) td.#{debitOrCredit} + .added", {contains: "$#{Math.abs(attributes.amount)}"}

`export default register`
