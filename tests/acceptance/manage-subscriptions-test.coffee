`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null
store = null

describe "Acceptance: Manage subscriptions", ->
  beforeEach (done) ->
    App = startApp()

    currentTest = @currentTest

    andThen ->
      store = PouchTestHelper.setup(App, currentTest.title)

      Ember.run ->
        asyncRecords = Ember.RSVP.hash
          alice: store.createRecord('person', {name: 'Alice'}).save()
          bob: store.createRecord('person', {name: 'Bob'}).save()
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
    PouchTestHelper.teardown(done)

  it 'shows issues remaining', (done) ->
    visit '/'
    click 'a:contains("People")'
    click 'a:contains("Alice")'

    andThen ->
      expect(find('p:contains("Issues remaining: 1")')).to.have.length 1
      expect(find('li:contains("Apples are amazing")')).to.have.length 1

      click 'a:contains("People")'
      click 'a:contains("Bob")'

      andThen ->
        expect(find('p:contains("Issues remaining: 3")')).to.have.length 1
        expect(find('li:contains("Apples are amazing")')).to.have.length 0

        click 'a:contains("People")'
        click 'a:contains("Cara")'

        andThen ->
          expect(find('p:contains("Not subscribed!")')).to.have.length 1

          done()
