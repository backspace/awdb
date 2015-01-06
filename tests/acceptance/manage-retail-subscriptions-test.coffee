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
    endAcceptanceTest(done)

  it 'shows no retail subscriptions', (done) ->
    viewRetailers()

    andThen ->
      expectNoElement '.js-active-retailers li:not(.heading)'

      expectElement '.js-inactive-retailers li', {contains: 'Mondragón'}
      expectElement '.js-inactive-retailers li', {contains: 'Chapters'}

      done()

  it 'uses the default retail issue cost', (done) ->
    viewRetailer 'Chapters'

    andThen ->
      expect(find('input[name=cost]').val()).to.equal('8')
      done()

  describe 'when a retailer subscribes', ->
    cost = '50'
    copies = '100'

    beforeEach (done) ->
      viewRetailer 'Chapters'

      fillIn 'input[name=cost]', cost
      fillIn 'input[name=copies]', copies
      click 'button.js-subscribe'

      waitForModels ['entity', 'subscription', 'transaction']

      andThen ->
        done()

    it 'shows on the retail subscribers list', (done) ->
      viewRetailers()

      andThen ->
        expectElement '.js-active-retailers li:not(.heading)'
        expectElement '.js-active-retailers li', {contains: 'Chapters'}

        done()

    it 'shows its subscription details', (done) ->
      viewRetailer 'Chapters'

      andThen ->
        expectElement '.cost', {contains: cost}
        expectElement '.copies', {contains: copies}

        done()

    it 'cannot be subscribed again', (done) ->
      viewRetailer 'Chapters'

      andThen ->
        expectNoElement 'button.js-subscribe'

        done()

    it 'no transaction is generated', (done) ->
      viewTransactions()

      andThen ->
        expectNoElement 'tbody tr'

        done()

    describe 'and unsubscribes', ->
      beforeEach (done) ->
        viewRetailer 'Chapters'

        click 'button.js-unsubscribe'

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
          expectElement 'button.js-subscribe'
          done()

      it 'has an inactive subscription listed', (done) ->
        viewRetailer 'Chapters'

        andThen ->
          expectElement '.subscription.is-exhausted'
          done()
