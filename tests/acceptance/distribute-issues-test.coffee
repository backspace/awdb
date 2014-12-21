`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null
people = null

describe "Acceptance: Distribute issues", ->
  # Copied from manage-subscriptions-test; DRY up somehow?
  beforeEach (done) ->
    App = startApp()

    PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
      Ember.run ->
        asyncRecords = Ember.RSVP.hash
          alice: store.createRecord('person', {name: 'Alice', address: 'Alice address'}).save()
          bob: store.createRecord('person', {name: 'Bob', address: 'Bob address'}).save()
          cara: store.createRecord('person', {name: 'Cara'}).save()

          artist: store.createRecord('person', {name: 'Artist'}).save()
          extra: store.createRecord('person', {name: 'Extra'}).save()

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

        asyncRecords.then((records) ->
          people = records

          # TODO is there a better way to add to an RSVP.hash? HIDEOUS
          subscriptions = Ember.RSVP.hash
            alice: store.createRecord('subscription', {person: records.alice, count: 2}).save()
            bob: store.createRecord('subscription', {person: records.bob, count: 3}).save()
            records: records

          subscriptions
        ).then((subscriptions) ->
          records = subscriptions.records

          fulfillments = Ember.RSVP.hash
            fulfillment: store.createRecord('fulfillment', {issue: records.apples, subscription: subscriptions.alice}).save()
            subscriptions: subscriptions

          fulfillments
        ).then((fulfillments) ->
          records = fulfillments.subscriptions.records
          subscriptions = fulfillments.subscriptions

          # FIXME hack to prevent stored person IDs from being cleared
          subscriptions.alice.set 'person', records.alice
          subscriptions.bob.set 'person', records.bob

          Ember.RSVP.all([
            records.alice.save(),
            records.bob.save()
            subscriptions.alice.save(),
            subscriptions.bob.save()
          ]).then ->
            done()
        )

  afterEach (done) ->
    Ember.run(App, 'destroy')
    Ember.run(done)

  describe 'with a new issue', (done) ->
    beforeEach (done) ->
      visit '/'
      click 'a:contains("Issues")'
      click 'button:contains("New issue")'
      fillIn 'input[name="title"]', 'Bananas are better'
      click 'button:contains("Done")'

      waitForModels ['issue']

      fillIn 'input[name="title"]', 'Not so much potassium though'
      fillIn 'select[name="contributor"]:last', people.artist.id
      click 'i.fa-check'

      waitForModels ['feature', 'issue']

      click 'a:contains("Distribute")'

      andThen ->
        done()

    it 'the proposed distribution lists active subscribers and contributors as recipients', (done) ->
      andThen ->
        expectElement '.recipients li', {contains: 'Alice'}
        expectElement '.recipients li', {contains: 'Bob'}

        expectElement '.recipients li', {contains: 'Artist'}

        done()

    describe 'having an additional recipient', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'xtr'
        click 'li:contains("Extra") .fa-plus'

        andThen ->
          done()

      it 'the new recipient is listed', (done) ->
        andThen ->
          expectElement '.recipients li', {contains: 'Extra'}

          done()

      describe ', when it is distributed', ->
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
          click 'a:contains("People")'
          click 'a:contains("Extra")'

          andThen ->
            expectElement 'li', {contains: 'Bananas are better'}

            done()

    describe 'that has been distributed', ->
      beforeEach (done) ->
        click 'button:contains("Distribute to 3 recipients")'

        waitForModels ['issue', 'subscription', 'fulfillment', 'distribution']

        andThen ->
          done()

      it 'shows the completed distribution', (done) ->
        andThen ->
          expectElement 'h2', {contains: "Distribution of issue Bananas are better"}
          expectElement 'a', {contains: 'Alice'}

          done()

      it 'shows that subscribers received the issue', (done) ->
        visit '/'
        click 'a:contains("People")'
        click 'a:contains("Alice")'

        andThen ->
          expectElement 'p', {contains: 'Not subscribed!'}
          expectElement 'li', {contains: 'Bananas are better'}

        click 'a:contains("People")'
        click 'a:contains("Bob")'

        andThen ->
          expectElement 'p', {contains: 'Issues remaining: 2'}
          expectElement 'li', {contains: 'Bananas are better'}

          done()

      it 'shows that the contributor received the issue', (done) ->
        click 'a:contains("People")'
        click 'a:contains("Artist")'

        andThen ->
          expectElement 'li', {contains: 'Bananas are better'}

          done()

      it 'shows that the non-subscriber did not receive the issue', (done) ->
        click 'a:contains("People")'
        click 'a:contains("Cara")'

        andThen ->
          expectNoElement 'li', {contains: 'Bananas are better'}

          done()

      it 'retains the addresses in the distribution even if they have since changed', (done) ->
        visit '/'
        click 'a:contains("People")'
        click 'a:contains("Alice")'
        click 'button:contains("Edit")'
        fillIn('textarea[name="address"]', 'New address for Alice')
        click('button:contains("Done")')

        waitForModels ['person']

        visit '/'
        click 'a:contains("Issues")'
        click 'a:contains("Bananas")'
        click '.distributions li a'

        andThen ->
          expectElement 'p', {contains: 'Alice address'}
          expectElement 'p', {contains: 'Bob address'}

          done()

  it 'does not automatically distribute to subscribers who have already received an issue', (done) ->
    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Apples")'

    click 'a:contains("Distribute")'

    andThen ->
      expectNoElement '.recipients li', {contains: 'Alice'}
      expectElement '.recipients li', {contains: 'Bob'}

      done()

  describe 'when there is another subscriber', (done) ->
    beforeEach (done) ->
      visit '/'
      click 'a:contains("People")'
      click 'a:contains("Cara")'
      click 'button:contains("Add")'

      waitForModels ['subscription', 'person']

      andThen ->
        done()

    describe 'and the new subscriber is deleted from the distribution', (done) ->
      beforeEach (done) ->
        visit '/'
        click 'a:contains("Issues")'
        click 'a:contains("Apples")'
        click 'a:contains("Distribute")'

        click 'li:contains("Cara") .fa-trash'

        click 'button:contains("Distribute")'

        waitForModels ['distribution', 'fulfillment', 'issue', 'subscription']

        andThen ->
          done()

      it 'does not distribute to the new subscriber', (done) ->
        click 'a:contains("Issues")'
        click 'a:contains("Apples")'
        click '.distributions li a'

        andThen ->
          expectElement 'a', {contains: 'Bob'}
          expectNoElement 'a', {contains: 'Cara'}

          done()
