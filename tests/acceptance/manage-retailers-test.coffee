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
          store.createRecord('retailer', {name: 'Awesomeness', address: '123 Awesome Avenue'}).save(),
          store.createRecord('retailer', {name: 'Bodaciousness'}).save()
        ]).then ->
          done()

  afterEach (done) ->
    Ember.run(application, 'destroy')
    Ember.run(done)

  it 'lists the retailers', (done) ->
    visit '/'
    click 'a:contains("Retailers")'

    andThen ->
      expectElement 'li', {contains: 'Awesomeness'}
      expectElement 'li', {contains: 'Bodaciousness'}
      expectElement 'li', 2

      done()

  it "shows a retailer's details", (done) ->
    visit '/'
    click 'a:contains("Retailers")'
    click 'a:contains("Awesomeness")'

    andThen ->
      expectElement 'h3', {contains: 'Awesomeness'}
      expectElement 'p', {contains: '123 Awesome Avenue'}

      done()

  it 'supports creating a retailer', (done) ->
    visit '/'
    click 'a:contains("Retailers")'

    click 'button:contains("New")'
    fillIn 'input[name="name"]', 'Controversial'
    click 'button:contains("Done")'

    click 'a:contains("Retailers")'

    andThen ->
      expectElement 'li', {contains: 'Controversial'}

      done()

  it 'supports editing a retailer', (done) ->
    visit '/'
    click 'a:contains("Retailers")'
    click 'a:contains("Bodaciousness")'

    click 'button:contains("Edit")'
    fillIn 'input[name="name"]', 'Better'
    click 'button:contains("Done")'

    click 'a:contains("Retailers")'

    andThen ->
      expectElement 'li', {contains: 'Better'}
      done()
