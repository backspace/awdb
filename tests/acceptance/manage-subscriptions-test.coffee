`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null

describe "Acceptance: Manage subscriptions", ->
  beforeEach (done) ->
    App = startApp()

    PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
      Ember.run ->
        asyncRecords = Ember.RSVP.hash
          alice: store.createRecord('person', {name: 'Alice'}).save()
          bob: store.createRecord('person', {name: 'Bob'}).save()
          cara: store.createRecord('person', {name: 'Cara'}).save()
          donna: store.createRecord('person', {name: 'Donna'}).save()

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

        asyncRecords.then((records) ->
          # TODO is there a better way to add to an RSVP.hash? HIDEOUS
          subscriptions = Ember.RSVP.hash
            alice: store.createRecord('subscription', {person: records.alice, count: 2}).save()
            bob: store.createRecord('subscription', {person: records.bob, count: 3}).save()
            donna: store.createRecord('subscription', {person: records.donna, count: 1}).save()
            records: records

          subscriptions
        ).then((subscriptions) ->
          records = subscriptions.records

          fulfillments = Ember.RSVP.hash
            fulfillment: store.createRecord('fulfillment', {issue: records.apples, person: records.alice, subscription: subscriptions.alice}).save()
            final_fulfillment: store.createRecord('fulfillment', {issue: records.apples, person: records.donna, subscription: subscriptions.donna}).save()
            subscriptions: subscriptions

          fulfillments
        ).then((fulfillments) ->
          records = fulfillments.subscriptions.records
          subscriptions = fulfillments.subscriptions

          # FIXME hack to prevent stored person IDs from being cleared
          subscriptions.alice.set 'person', records.alice
          subscriptions.bob.set 'person', records.bob
          subscriptions.donna.set 'person', records.donna

          Ember.RSVP.all([
            records.alice.save(),
            records.bob.save()
            records.donna.save()
            subscriptions.alice.save(),
            subscriptions.bob.save()
            subscriptions.donna.save()
          ]).then ->
            done()
        )

  afterEach (done) ->
    Ember.run(App, 'destroy')
    Ember.run(done)

  it 'shows issues remaining', (done) ->
    visit '/'
    click 'a:contains("People")'
    click 'a:contains("Alice")'

    andThen ->
      expectElement 'p', {contains: 'Issues remaining: 1'}
      expectElement 'li', {contains: 'Apples are amazing'}

    click 'a:contains("People")'
    click 'a:contains("Bob")'

    andThen ->
      expectElement 'p', {contains: 'Issues remaining: 3'}
      expectNoElement 'li', {contains: 'Apples are amazing'}

    click 'a:contains("People")'
    click 'a:contains("Cara")'

    andThen ->
      expectElement 'p', {contains: 'Not subscribed!'}

      done()

  it 'allows the user to create subscriptions', (done) ->
    visit '/'
    click 'a:contains("People")'
    click 'a:contains("Cara")'
    click 'button:contains("Add 3-issue subscription")'

    waitForModels ['subscription', 'person']

    # Navigate away to ensure relationship is stored on both ends
    visit '/'
    click 'a:contains("People")'
    click 'a:contains("Cara")'

    andThen ->
      expectElement 'p', {contains: 'Issues remaining: 3'}

      done()

  it 'lists current subscribers', (done) ->
    visit '/'
    click 'a:contains("People")'

    andThen ->
      expectElement '.js-subscribers li', {contains: 'Alice'}
      expectElement '.js-subscribers li', {contains: 'Bob'}
      expectNoElement '.js-subscribers li', {contains: 'Cara'}
      expectNoElement '.js-subscribers li', {contains: 'Donna'}

      done()

  it 'lists former subscribers', (done) ->
    visit '/'
    click 'a:contains("People")'

    andThen ->
      expectNoElement '.js-former-subscribers li', {contains: 'Alice'}
      expectNoElement '.js-former-subscribers li', {contains: 'Bob'}
      expectNoElement '.js-former-subscribers li', {contains: 'Cara'}
      expectElement '.js-former-subscribers li', {contains: 'Donna'}

      done()
