`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null
entities = null

describe "Acceptance: Distribute issues", ->
  # Copied from manage-subscriptions-test; DRY up somehow?
  beforeEach (done) ->
    App = startApp()

    PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
      Ember.run ->
        asyncRecords = Ember.RSVP.hash
          alice: store.createRecord('entity', {name: 'Alice', address: 'Alice address'}).save()
          bob: store.createRecord('entity', {name: 'Bob', address: 'Bob address'}).save()
          cara: store.createRecord('entity', {name: 'Cara', classification: 'international'}).save()

          bookstore: store.createRecord('entity', {name: 'Bookstore', address: 'Bookstore address', isRetailer: true}).save()
          dépanneur: store.createRecord('entity', {name: 'Dépanneur', address: 'Dépanneur address', isRetailer: true}).save()

          artist: store.createRecord('entity', {name: 'Artist'}).save()
          extra: store.createRecord('entity', {name: 'Extra'}).save()

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

        asyncRecords.then((records) ->
          entities = records

          # TODO is there a better way to add to an RSVP.hash? HIDEOUS
          subscriptions = Ember.RSVP.hash
            alice: store.createRecord('subscription', {entity: records.alice, count: 2}).save()
            bob: store.createRecord('subscription', {entity: records.bob, count: 3}).save()
            bookstore: store.createRecord('subscription', {entity: records.bookstore, copies: 30, cost: 10}).save()

            records: records

          subscriptions
        ).then((subscriptions) ->
          records = subscriptions.records

          fulfillments = Ember.RSVP.hash
            fulfillment: store.createRecord('fulfillment', {issue: records.apples, subscription: subscriptions.alice}).save()
            bookstoreFulfillment: store.createRecord('fulfillment', {issue: records.apples, subscription: subscriptions.bookstore}).save()

            subscriptions: subscriptions

          fulfillments
        ).then((fulfillments) ->
          records = fulfillments.subscriptions.records
          subscriptions = fulfillments.subscriptions

          # FIXME hack to prevent stored entity IDs from being cleared
          subscriptions.alice.set 'entity', records.alice
          subscriptions.bob.set 'entity', records.bob
          subscriptions.bookstore.set 'entity', records.bookstore

          Ember.RSVP.all([
            records.alice.save(),
            records.bob.save(),
            records.bookstore.save(),
            subscriptions.alice.save(),
            subscriptions.bob.save(),
            subscriptions.bookstore.save()
          ]).then ->
            done()
        )

  afterEach (done) ->
    endAcceptanceTest(done)

  describe 'with a new issue', (done) ->
    beforeEach (done) ->
      viewIssues()
      click 'button:contains("New issue")'
      fillIn 'input[name="title"]', 'Bananas are better'
      click 'button:contains("Done")'

      waitForModels ['issue']

      fillIn 'input[name="title"]', 'Not so much potassium though'

      fillIn 'input[type="search"]', 'artist'
      click 'li:contains("Artist") .fa-plus'

      click 'i.fa-check'

      waitForModels ['feature', 'issue']

      click 'a:contains("Distribute")'

      andThen ->
        done()

    it 'the proposed distribution lists active subscribers and contributors as recipients', (done) ->
      andThen ->
        expectElement '.subscriptions li', {contains: 'Alice'}
        expectElement '.subscriptions li', {contains: 'Bob'}

        expectElement '.retailSubscriptions li', {contains: 'Bookstore'}
        expectElement 'li li:contains("Bookstore")', {contains: '30 @ $10/each'}

        expectElement '.contributions li', {contains: 'Artist'}

        done()

    it 'uses the default $100 feature compensation', (done) ->
      andThen ->
        expect(find('input[type="number"]').val()).to.equal('100')

        done()

    describe 'having an additional recipient', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'ext'
        click 'li:contains("Extra") .fa-plus'

        andThen ->
          done()

      it 'the new recipient is listed', (done) ->
        andThen ->
          expectElement '.extras li', {contains: 'Extra'}

          done()

      describe 'when it is distributed', ->
        beforeEach (done) ->
          click 'button:contains("Distribute")'

          waitForModels ['issue', 'subscription', 'fulfillment', 'distribution']

          andThen ->
            done()

        it 'shows the new recipient in the completed distribution', (done) ->
          andThen ->
            expectElement 'a', {contains: 'Extra'}

            done()

        it 'shows that the new recipient received the issue', (done) ->
          viewEntity 'Extra'

          andThen ->
            expectElement 'li', {contains: 'Bananas are better'}

            done()

    describe 'that has been distributed', ->
      beforeEach (done) ->
        fillIn 'input[type="number"]', '200'

        click 'button:contains("Distribute to 4 recipients")'

        waitForModels ['issue', 'subscription', 'fulfillment', 'distribution', 'transaction']

        andThen ->
          done()

      it 'shows the completed distribution', (done) ->
        andThen ->
          expectElement 'h2', {contains: "Distribution of issue Bananas are better"}
          expectElement 'a', {contains: 'Alice'}
          expectElement 'a', {contains: 'Bookstore'}

          done()

      it 'shows that subscribers received the issue', (done) ->
        viewEntity 'Alice'

        andThen ->
          expectElement 'p', {contains: 'Not subscribed!'}
          expectElement 'li', {contains: 'Bananas are better'}

        viewEntity 'Bob'

        andThen ->
          expectElement 'p', {contains: 'Issues remaining: 2'}
          expectElement 'li', {contains: 'Bananas are better'}

          done()

      it 'shows that the retailer received the issue', (done) ->
        viewRetailer 'Bookstore'

        andThen ->
          expectElement 'li', {contains: 'Bananas are better'}

          done()

      it 'shows that the contributor received the issue', (done) ->
        viewEntity 'Artist'

        andThen ->
          expectElement 'li', {contains: 'Bananas are better'}

          done()

      it 'shows that the non-subscribers did not receive the issue', (done) ->
        viewEntity 'Cara'

        andThen ->
          expectNoElement 'li', {contains: 'Bananas are better'}

        viewRetailer 'Dépanneur'

        andThen ->
          expectNoElement 'li', {contains: 'Bananas are better'}

          done()

      it 'retains the addresses in the distribution even if they have since changed', (done) ->
        viewEntity 'Alice'
        click 'button:contains("Edit")'
        fillIn('textarea[name="address"]', 'New address for Alice')
        click('button:contains("Done")')

        waitForModels ['entity']

        viewIssue 'Bananas'
        click '.distributions li a'

        andThen ->
          expectElement 'p', {contains: 'Alice address'}
          expectElement 'p', {contains: 'Bob address'}

          done()

      it 'created a transaction for contributor compensation', (done) ->
        viewTransactions()

        andThen ->
          # TODO fix withinElement, doesn’t reset scope
          # withinElement 'tr:contains("Artist")', ->
          #   expectElement 'td', {contains: '-$200'}
          #   expectElement 'td', {contains: 'Contribution'}
          expectElement 'tr:contains("Artist") td', {contains: '-$200'}
          expectElement 'tr:contains("Artist") td', {contains: 'Contribution'}

          done()

      # FIXME this calculation is temporary, needs clarification
      it 'creates a transaction for the retail subscription', (done) ->
        viewTransactions()

        andThen ->
          # withinElement 'tr:contains("Bookstore")', ->
          #   expectElement 'td', {contains: '$300'}
          #   expectElement 'td', {contains: 'Fulfillment'}
          expectElement 'tr:contains("Bookstore") td', {contains: '$300'}
          expectElement 'tr:contains("Bookstore") td', {contains: 'Fulfillment'}

          done()

  it 'does not suggest subscribers who have already received an issue', (done) ->
    viewIssue 'Apples'

    click 'a:contains("Distribute")'

    andThen ->
      expectNoElement '.recipients li', {contains: 'Alice'}
      expectNoElement '.recipients li', {contains: 'Bookstore'}
      expectElement '.subscriptions li', {contains: 'Bob'}

      done()

  describe 'when there is another subscriber', (done) ->
    beforeEach (done) ->
      viewEntity 'Cara'

      click 'input[name=3]'
      click 'button.js-subscribe'

      waitForModels ['subscription', 'entity']

      andThen ->
        done()

    describe 'and the new subscriber is deleted from the distribution', (done) ->
      beforeEach (done) ->
        viewIssue 'Apples'
        click 'a:contains("Distribute")'

        click 'li.subscriptions li:contains("Cara") .fa-trash'

        click 'button:contains("Distribute")'

        waitForModels ['distribution', 'fulfillment', 'issue', 'subscription']

        andThen ->
          done()

      it 'does not distribute to the new subscriber', (done) ->
        viewIssue 'Apples'
        click '.distributions li a'

        andThen ->
          expectElement 'a', {contains: 'Bob'}
          expectNoElement 'a', {contains: 'Cara'}

          done()

  describe 'when the default feature compensation is changed', (done) ->
    beforeEach (done) ->
      visit '/'
      click 'a:contains("Settings")'
      fillIn 'input[name=featureCompensation]', '50'
      click 'button:contains("Save")'

      waitForModels ['settings']

      andThen ->
        done()

    it 'uses the new feature compensation in a distribution', (done) ->
      viewIssues()
      click 'button:contains("New issue")'
      fillIn 'input[name="title"]', 'Cantaloupe is capricious'
      click 'button:contains("Done")'

      waitForModels ['issue']

      fillIn 'input[name="title"]', 'Sometimes so good'

      fillIn 'input[type="search"]', 'artist'
      click 'li:contains("Artist") .fa-plus'

      click 'i.fa-check'

      waitForModels ['feature', 'issue']
      viewIssue 'Cantaloupe'
      click 'a:contains("Distribute")'

      andThen ->
        expect(find('input[type="number"]').val()).to.equal('50')

        done()
