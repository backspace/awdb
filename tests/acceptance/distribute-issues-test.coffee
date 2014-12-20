`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null

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

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

        asyncRecords.then((records) ->
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

  describe 'when distributing a new issue', (done) ->
    beforeEach (done) ->
      visit '/'
      click 'a:contains("Issues")'
      click 'button:contains("New issue")'
      fillIn 'input[name="title"]', 'Bananas are better'
      click 'button:contains("Done")'

      waitForModels ['issue']

      click 'a:contains("Distribute")'

      andThen ->
        expectElement '.subscribers li', {contains: 'Alice'}
        expectElement '.subscribers li', {contains: 'Bob'}

      click 'button:contains("Distribute to 2 subscribers")'

      waitForModels ['issue', 'subscription', 'fulfillment', 'distribution']

      andThen ->
        done()

    it 'shows that subscribers received the issue', (done) ->
      andThen ->
        expectElement 'h3', {contains: 'Bananas'}

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
      expectNoElement '.subscribers li', {contains: 'Alice'}
      expectElement '.subscribers li', {contains: 'Bob'}

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
