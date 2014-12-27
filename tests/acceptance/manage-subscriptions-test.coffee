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
          alice: store.createRecord('entity', {name: 'Alice'}).save()
          bob: store.createRecord('entity', {name: 'Bob'}).save()
          cara: store.createRecord('entity', {name: 'Cara'}).save()
          donna: store.createRecord('entity', {name: 'Donna'}).save()

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

        asyncRecords.then((records) ->
          # TODO is there a better way to add to an RSVP.hash? HIDEOUS
          subscriptions = Ember.RSVP.hash
            alice: store.createRecord('subscription', {entity: records.alice, count: 2}).save()
            bob: store.createRecord('subscription', {entity: records.bob, count: 3}).save()
            donna: store.createRecord('subscription', {entity: records.donna, count: 1}).save()
            records: records

          subscriptions
        ).then((subscriptions) ->
          records = subscriptions.records

          fulfillments = Ember.RSVP.hash
            fulfillment: store.createRecord('fulfillment', {issue: records.apples, entity: records.alice, subscription: subscriptions.alice}).save()
            final_fulfillment: store.createRecord('fulfillment', {issue: records.apples, entity: records.donna, subscription: subscriptions.donna}).save()
            subscriptions: subscriptions

          fulfillments
        ).then((fulfillments) ->
          records = fulfillments.subscriptions.records
          subscriptions = fulfillments.subscriptions

          # FIXME hack to prevent stored entity IDs from being cleared
          subscriptions.alice.set 'entity', records.alice
          subscriptions.bob.set 'entity', records.bob
          subscriptions.donna.set 'entity', records.donna

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
    endAcceptanceTest(done)

  it 'shows issues remaining', (done) ->
    viewEntity 'Alice'

    andThen ->
      expectElement 'p', {contains: 'Issues remaining: 1'}
      expectElement 'li', {contains: 'Apples are amazing'}

    viewEntity 'Bob'

    andThen ->
      expectElement 'p', {contains: 'Issues remaining: 3'}
      expectNoElement 'li', {contains: 'Apples are amazing'}

    viewEntity 'Cara'

    andThen ->
      expectElement 'p', {contains: 'Not subscribed!'}

      done()

  describe 'with someone who is not subscribed', ->
    beforeEach (done) ->
      viewEntity 'Cara'

      andThen ->
        done()

    describe 'when they subscribe with custom subscription cost', ->
      beforeEach (done) ->
        click 'input[name=3]'
        fillIn 'input[name=cost]', '400'

        click 'button.js-subscribe'

        waitForModels ['subscription', 'entity']

        andThen ->
          done()

      it 'results in a subscription transaction for the custom cost', (done) ->
        viewTransactions()

        andThen ->
          expectElement 'tr:contains("Cara") td', {contains: "$400"}
          expectElement 'tr:contains("Cara") td', {contains: 'Subscription'}

          done()

    rates =
      Canada: 30
      USA: 35
      International: 40
      Institution: 45

    for own classification, rate of rates
      do (classification, rate) ->
        describe "creating a new subscription for #{classification}", ->
          beforeEach (done) ->
            click 'button:contains("Edit")'
            click "label:contains('#{classification}')"
            click 'button:contains("Done")'

            waitForModels ['entity']

            click 'input[name=3]'
            click 'button.js-subscribe'

            waitForModels ['subscription', 'entity']

            andThen ->
              done()

          it "results in a subscription transaction for $#{rate}", (done) ->
            viewTransactions()

            andThen ->
              # withinElement 'tr:contains("Cara")', ->
              #   expectElement 'td', {contains: "$#{rate}"}
              #   expectElement 'td', {contains: 'Subscription'}
              expectElement 'tr:contains("Cara") td', {contains: "$#{rate}"}
              expectElement 'tr:contains("Cara") td', {contains: 'Subscription'}

              done()

    describe 'when the subscriber is an institution', ->
      beforeEach (done) ->
        click 'button:contains("Edit")'
        click 'label:contains("Institution")'
        click 'button:contains("Done")'

        waitForModels ['entity']

        andThen ->
          done()

      describe 'and the rate for institutions has been changed', ->
        beforeEach (done) ->
          click 'a:contains("Settings")'
          fillIn 'input[name=subscriptionInstitution3]', 100
          fillIn 'input[name=subscriptionInstitution6]', 200
          click 'button:contains("Save")'

          waitForModels ['settings']

          andThen ->
            done()

        costsByIssueCount =
          3: 100
          6: 200

        for issueCount, cost of costsByIssueCount
          do (issueCount, cost) ->
            describe "when a #{issueCount}-issue subscription is created", ->
              beforeEach (done) ->
                viewEntity 'Cara'

                click "input[name=#{issueCount}]"
                click "button.js-subscribe"

                waitForModels ['subscription', 'entity']

                andThen ->
                  done()

              it 'shows the new subscription', (done) ->
                # Navigate away to ensure relationship is stored on both ends
                viewEntity 'Cara'

                andThen ->
                  expectElement 'p', {contains: "Issues remaining: #{issueCount}"}

                  done()

              it "results in a subscription transaction for the new rate", (done) ->
                viewTransactions()

                andThen ->
                  expectElement 'tr:contains("Cara") td', {contains: "$#{cost}"}

                  done()

  it 'lists current subscribers', (done) ->
    viewEntities()

    andThen ->
      expectElement '.js-subscribers li', {contains: 'Alice'}
      expectElement '.js-subscribers li', {contains: 'Bob'}
      expectNoElement '.js-subscribers li', {contains: 'Cara'}
      expectNoElement '.js-subscribers li', {contains: 'Donna'}

      done()

  it 'lists former subscribers', (done) ->
    viewEntities()

    andThen ->
      expectNoElement '.js-former-subscribers li', {contains: 'Alice'}
      expectNoElement '.js-former-subscribers li', {contains: 'Bob'}
      expectNoElement '.js-former-subscribers li', {contains: 'Cara'}
      expectElement '.js-former-subscribers li', {contains: 'Donna'}

      done()
