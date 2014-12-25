`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

application = null

describe 'Acceptance: Manage retail subscriptions', ->
  beforeEach (done) ->
    application = startApp()

    PouchTestHelper.buildStore(application, @currentTest.title).then (store) ->
      Ember.run ->
        Ember.RSVP.all([
          store.createRecord('entity', {name: 'Mondragón', isRetailer: true}).save(),
          store.createRecord('entity', {name: 'Chapters', isRetailer: true}).save()
        ]).then ->
          done()

  afterEach (done) ->
    waitForModels ['subscription', 'entity']

    andThen ->
      Ember.run(application, 'destroy')
      Ember.run(done)

  it 'shows no retail subscriptions', (done) ->
    viewRetailers()

    andThen ->
      expectNoElement '.js-active-retailers li'

      expectElement '.js-inactive-retailers li', {contains: 'Mondragón'}
      expectElement '.js-inactive-retailers li', {contains: 'Chapters'}

      done()

  describe 'when a retailer subscribes', ->
    beforeEach (done) ->
      viewRetailer 'Chapters'

      click 'button:contains("Create subscription")'

      waitForModels ['entity', 'subscription', 'transaction']

      andThen ->
        done()

    it 'shows on the retail subscribers list', (done) ->
      viewRetailers()

      andThen ->
        expectElement '.js-active-retailers li'
        expectElement '.js-active-retailers li', {contains: 'Chapters'}

        done()

    it 'cannot be subscribed again', (done) ->
      viewRetailer 'Chapters'

      andThen ->
        expectNoElement 'button:contains("Create subscription")'

        done()

    it 'no transaction is generated', (done) ->
      viewTransactions()

      andThen ->
        expectNoElement 'tbody tr'

        done()

    describe 'and unsubscribes', ->
      beforeEach (done) ->
        viewRetailer 'Chapters'

        click 'button:contains("End subscription")'

        waitForModels ['entity', 'subscription']

        andThen ->
          done()

      it 'shows on the inactive retailers list', (done) ->
        viewRetailers()

        andThen ->
          expectElement '.js-inactive-retailers li', {contains: 'Chapters'}

          done()

      it 'can be subscribed again', (done) ->
        viewRetailer 'Chapters'

        andThen ->
          expectElement 'button:contains("Create subscription")'
          done()

      it 'has an inactive subscription listed', (done) ->
        viewRetailer 'Chapters'

        andThen ->
          expectElement '.js-inactive-subscriptions li'
          done()
