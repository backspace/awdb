`import Ember from 'ember'`
`import startApp from './helpers/start-app'`

`import PouchTestHelper from './helpers/pouch-test-helper'`

application = null

describe 'Archive test data', ->
  beforeEach (done) ->
    application = startApp()

    PouchTestHelper.buildStore(application, 'http://127.0.0.1:5984/awdb-archive').then ->
      done()

  it 'constructs archival data', (done) ->
    viewEntities()
    click '.js-create'
    fillIn 'input[name=name]', 'Writer'
    fillIn 'textarea[name=address]', "123 Main St.\nWinnipeg, MB  R3C 0K0\nCanada"
    click 'label:contains("Canada")'

    click '.js-save'

    waitForAllModels()

    andThen ->
      done()
