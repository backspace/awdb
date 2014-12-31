`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

application = null

describe "Acceptance: Manage retailers", ->
  beforeEach (done) ->
    application = startApp()

    PouchTestHelper.buildStore(application, @currentTest.title).then (store) ->
      Ember.run ->
        Ember.RSVP.Promise.all([
          store.createRecord('entity', {name: 'Awesomeness', address: '123 Awesome Avenue', isRetailer: true}).save(),
          store.createRecord('entity', {name: 'Bodaciousness', isRetailer: true}).save(),
          store.createRecord('entity', {name: 'A human'}).save()
        ]).then ->
          done()

  afterEach (done) ->
    endAcceptanceTest(done)

  it 'lists only the retailers', (done) ->
    viewRetailers()

    andThen ->
      expectElement 'li', {contains: 'Awesomeness'}
      expectElement 'li', {contains: 'Bodaciousness'}
      expectElement 'li:not(.heading)', 2

      done()

  it "shows a retailer's details", (done) ->
    viewRetailer 'Awesomeness'

    andThen ->
      expectElement 'h3', {contains: 'Awesomeness'}
      expectElement 'p', {contains: '123 Awesome Avenue'}

      done()

  it 'supports creating a retailer', (done) ->
    viewRetailers()

    click '.js-create'
    fillIn 'input[name="name"]', 'Controversial'
    click 'button:contains("Done")'

    waitForModels ['entity']

    click 'a:contains("Retailers")'

    andThen ->
      expectElement 'li', {contains: 'Controversial'}

      done()

  it 'supports editing a retailer', (done) ->
    viewRetailer 'Bodaciousness'

    click 'button:contains("Edit")'
    fillIn 'input[name="name"]', 'Better'
    click 'button:contains("Done")'

    click 'a:contains("Retailers")'

    andThen ->
      expectElement 'li', {contains: 'Better'}
      done()
