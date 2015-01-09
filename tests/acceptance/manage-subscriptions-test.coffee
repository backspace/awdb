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
          records.aliceSub = store.createRecord('subscription', {entity: records.alice, count: 2}).save()
          records.bobSub = store.createRecord('subscription', {entity: records.bob, count: 3}).save()
          records.donnaSub = store.createRecord('subscription', {entity: records.donna, count: 1}).save()

          Ember.RSVP.hash(records)
        ).then((records) ->
          records.fulfillment = store.createRecord('fulfillment', {issue: records.apples, entity: records.alice, subscription: records.aliceSub}).save()
          records.final_fulfillment = store.createRecord('fulfillment', {issue: records.apples, entity: records.donna, subscription: records.donnaSub}).save()

          Ember.RSVP.hash(records)
        ).then((records) ->
          # FIXME hack to prevent stored entity IDs from being cleared
          records.aliceSub.set 'entity', records.alice
          records.bobSub.set 'entity', records.bob
          records.donnaSub.set 'entity', records.donna

          Ember.RSVP.all([
            records.alice.save(),
            records.bob.save()
            records.donna.save()
            records.aliceSub.save(),
            records.bobSub.save()
            records.donnaSub.save()
          ]).then ->
            done()
        )

  afterEach (done) ->
    endAcceptanceTest(done)

  it 'shows issues remaining', (done) ->
    @timeout 3000
    viewEntity 'Alice'

    andThen ->
      expectElement '.future', 1
      expectElement 'li', {contains: 'Apples are amazing'}

    viewEntity 'Bob'

    andThen ->
      expectElement '.future', 3
      expectNoElement 'li', {contains: 'Apples are amazing'}

    viewEntity 'Cara'

    andThen ->
      expectNoElement '.subscription:not(.new) .future'

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
          expectTransaction
            entity: 'Cara'
            event: 'Subscription'
            amount: 400

          done()

    describe 'when the subscriber is an institution', ->
      beforeEach (done) ->
        click 'button:contains("Edit")'
        click 'label:contains("Institution") input'
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
                  expectElement '.future', parseInt(issueCount)

                  done()

              it "results in a subscription transaction for the new rate", (done) ->
                viewTransactions()

                andThen ->
                  expectTransaction
                    entity: 'Cara'
                    event: 'Subscription'
                    amount: cost

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
