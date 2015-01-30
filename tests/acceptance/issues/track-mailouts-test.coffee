`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

App = null
entities = null

describe "Acceptance: Track issue mailouts", ->
  # TODO speed this up
  @timeout 5000

  # Copied from manage-subscriptions-test; DRY up somehow?
  beforeEach (done) ->
    App = startApp()

    PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
      Ember.run ->
        asyncRecords = Ember.RSVP.hash
          alice: store.createRecord('entity', {name: 'Alice', address: 'Alice address'}).save()
          bob: store.createRecord('entity', {name: 'Bob', address: 'Bob address'}).save()
          previewer: store.createRecord('entity', {name: 'Previewer', address: 'Previewer address'}).save()
          cara: store.createRecord('entity', {name: 'Cara', classification: 'international'}).save()

          bookstore: store.createRecord('entity', {name: 'Bookstore', address: 'Bookstore address', isRetailer: true}).save()
          dépanneur: store.createRecord('entity', {name: 'Dépanneur', address: 'Dépanneur address', isRetailer: true}).save()

          artist: store.createRecord('entity', {name: 'Artist', address: 'Artist address'}).save()
          extra: store.createRecord('entity', {name: 'Extra', address: 'Extra address'}).save()
          addressless: store.createRecord('entity', {name: 'Addressless'}).save()

          apples: store.createRecord('issue', {title: 'Apples are amazing'}).save()

          feature: store.createRecord('feature', {title: 'Crunchy is better'}).save()

        asyncRecords.then((records) ->
          # FIXME hackery nightmare
          records.apples.get('features').addObject(records.feature)

          records.aliceSub = store.createRecord('subscription', {entity: records.alice, count: 2}).save()
          records.bobSub = store.createRecord('subscription', {entity: records.bob, count: 3}).save()
          records.previewerSub = store.createRecord('subscription', {entity: records.previewer, count: 2}).save()
          records.bookstoreSub = store.createRecord('subscription', {entity: records.bookstore, copies: 30, cost: 10}).save()

          records.saveIssue = records.apples.save()
          records.contribution = store.createRecord('contribution', {feature: records.feature}).save()


          Ember.RSVP.hash(records)
        ).then((records) ->
          records.contribution.set 'entity', records.artist
          records.feature.set 'issue', records.apples

          records.fulfilment = store.createRecord('fulfillment', {issue: records.apples, subscription: records.previewerSub}).save()

          records.saveContribution = records.contribution.save()
          records.saveFeature = records.feature.save()

          Ember.RSVP.hash(records)
        ).then((records) ->
          # FIXME hack to prevent stored entity IDs from being cleared
          records.aliceSub.set 'entity', records.alice
          records.bobSub.set 'entity', records.bob
          records.bookstoreSub.set 'entity', records.bookstore
          records.previewerSub.set 'entity', records.previewer

          Ember.RSVP.all([
            records.alice.save(),
            records.bob.save(),
            records.bookstore.save(),
            records.previewer.save(),
            records.aliceSub.save(),
            records.bobSub.save(),
            records.bookstoreSub.save(),
            records.previewerSub.save()
          ]).then ->
            done()
        )

  afterEach (done) ->
    endAcceptanceTest(done)

  describe 'when there is another subscriber', (done) ->
    beforeEach (done) ->
      viewEntity 'Cara'

      click 'input[name=3]'
      click 'button.js-subscribe'

      waitForModels ['subscription', 'entity']

      andThen ->
        done()

    describe 'and the new subscriber is deleted from the mailout', (done) ->
      beforeEach (done) ->
        viewIssue 'Apples'
        click '.js-build-mailout'

        click '.js-subscriptions li:contains("Cara") .js-delete'

        click '.js-save-mailout'

        waitForModels ['mailout', 'fulfillment', 'issue', 'subscription']

        andThen ->
          done()

      it 'does not mail to the new subscriber', (done) ->
        viewIssue 'Apples'
        click '.mailouts li a'

        andThen ->
          expectElement 'a', {contains: 'Bob'}
          expectNoElement 'a', {contains: 'Cara'}

          done()

  describe 'building a mailout for the existing issue', ->
    beforeEach (done) ->
      viewIssue 'Apples'
      click '.js-build-mailout'

      andThen ->
        done()

    it 'does not suggest subscribers who have already received an issue', (done) ->
      andThen ->
        expectNoElement '.js-recipients li', {contains: 'Previewer'}
        expectElement '.js-recipients li', {contains: 'Bookstore'}
        expectElement '.js-subscriptions li', {contains: 'Bob'}

        done()

    it 'will not mail when there are no recipients', (done) ->
      click '.js-delete'

      andThen ->
        expectElement '.js-save-mailout[disabled]'

        done()

    it 'the proposed mailout lists active subscribers and contributors as recipients', (done) ->
      andThen ->
        expectElement '.js-subscriptions li', {contains: 'Alice'}
        expectElement '.js-subscriptions li', {contains: 'Bob'}

        expectElement '.js-retail-subscriptions li', {contains: 'Bookstore'}

        expectElement '.js-contributions li', {contains: 'Artist'}

        done()

    it 'uses the default $100 feature compensation', (done) ->
      andThen ->
        expect(find('input[type="number"]').val()).to.equal('100')

        done()

    describe 'with additional recipient with no address', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'Addressless'
        click 'li:contains("Addressless") .js-add-entity'

        andThen ->
          done()

      it 'the new recipient is listed with a warning', (done) ->
        andThen ->
          expectElement '.js-extras li.warning[title*="no address"]', {contains: 'Addressless'}

          done()

      it 'will not mail because the recipient has no address', (done) ->
        andThen ->
          expectElement 'button.js-save-mailout[disabled]'

          done()

    describe 'with an additional recipient who has an address and gets two copies', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'ext'
        click 'li:contains("Extra") .js-add-entity'

        fillIn '.js-count', '2'

        andThen ->
          done()

      describe 'when it is saved', ->
        beforeEach (done) ->
          click '.js-save-mailout'

          waitForModels ['issue', 'subscription', 'fulfillment', 'mailout']

          andThen ->
            done()

        it 'shows the new recipient in the completed mailout', (done) ->
          andThen ->
            expectElement 'a', {contains: 'Extra'}

            done()

        it 'shows that the new recipient received the issue', (done) ->
          viewEntity 'Extra'

          andThen ->
            expectElement 'li[data-count=2]', {contains: 'Apples are amazing'}

            done()

        it 'shows a transaction for the default back issue cost', (done) ->
          viewTransactions()

          andThen ->
            expectTransaction
              entity: 'Extra'
              event: 'Fulfillment'
              amount: 20

            done()

      describe 'and an overridden back issue cost', ->
        beforeEach (done) ->
          fillIn 'li:contains(Extra) input[type=number]', '100'

          click '.js-save-mailout'

          waitForModels ['issue', 'subscription', 'fulfillment', 'mailout']

          andThen ->
            done()

        it 'results in a transaction for the custom amount', (done) ->
          viewTransactions()

          andThen ->
            expectTransaction
              entity: 'Extra'
              event: 'Fulfillment'
              amount: 100

            done()

    describe 'when it is mailed', ->
      beforeEach (done) ->
        fillIn 'input[type="number"]', '200'
        click '.js-save-mailout'

        waitForModels ['issue', 'subscription', 'fulfillment', 'mailout']

        andThen ->
          done()

      it 'shows the completed mailout', (done) ->
        andThen ->
          expectElement 'h2', {contains: "Mailout of issue Apples are amazing"}
          expectElement 'a', {contains: 'Alice'}
          expectElement 'a', {contains: 'Bookstore'}

          expectElement 'li:contains(Bookstore)', {contains: '30'}
          expectElement 'li:contains(Bookstore)', {contains: '10'}

          done()

      it 'shows that the non-subscribers did not receive the issue', (done) ->
        viewEntity 'Cara'

        andThen ->
          expectNoElement 'li', {contains: 'Apples'}

        viewRetailer 'Dépanneur'

        andThen ->
          expectNoElement 'li', {contains: 'Apples'}

          done()

      it 'shows that subscribers and the retailer and contributor received the issue', (done) ->
        viewEntity 'Alice'

        andThen ->
          expectElement 'li', {contains: 'Apples are amazing'}

        viewEntity 'Bob'

        andThen ->
          expectElement '.future', 2
          expectElement 'li', {contains: 'Apples are amazing'}

        viewRetailer 'Bookstore'

        andThen ->
          expectElement 'li', {contains: 'Apples are amazing'}

        viewEntity 'Artist'

        andThen ->
          expectElement 'li.is-multiple', {contains: 'Apples are amazing'}

          done()

      it 'retains the name in the mailout even if it has since changed', (done) ->
        viewEntity 'Alice'
        click 'button:contains("Edit")'
        fillIn('input[name=name]', 'Newname')
        click('button:contains("Done")')

        waitForModels ['entity']

        viewIssue 'Apples'
        click '.mailouts li a'

        andThen ->
          expectElement 'a', {contains: 'Alice'}

          done()

      it 'created a transaction for contributor compensation', (done) ->
        viewTransactions()

        andThen ->
          expectTransaction
            entity: 'Artist'
            event: 'Contribution'
            amount: -200

          done()

      # FIXME this calculation is temporary, needs clarification
      it 'creates a transaction for the retail subscription', (done) ->
        viewTransactions()

        andThen ->
          expectTransaction
            entity: 'Bookstore'
            event: 'Fulfillment'
            amount: 300

          done()

      describe 'for a second mailout', (done) ->
        beforeEach (done) ->
          viewIssue 'Apples'
          click '.js-build-mailout'

          andThen -> done()

        it 'does not fulfill contributors', (done) ->
          andThen ->
            expectNoElement '.js-contributions li', {contains: 'Artist'}
            expectNoElement 'input[type=number]'

            done()

        it 'nor compensate them', (done) ->
          # Must add recipient so the mailout saves
          fillIn 'input[type="search"]', 'ext'
          click 'li:contains("Extra") .js-add-entity'

          click '.js-save-mailout'

          waitForModels ['issue', 'subscription', 'fulfillment', 'mailout']

          viewTransactions()

          andThen ->
            expectElement 'tr:contains(Artist)'

            done()

      it 'but links to the compensation transaction', (done) ->
        viewIssue 'Apples'

        andThen ->
          expectElement 'li:contains("Crunchy") a[href*=transactions]'
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

    it 'uses the new feature compensation in a mailout', (done) ->
      viewIssues()
      click '.js-create'
      fillIn 'input[name="title"]', 'Cantaloupe is capricious'
      click 'button:contains("Done")'

      waitForModels ['issue']

      click '.js-edit'

      fillIn '.js-new input[name="title"]', 'Sometimes so good'

      fillIn 'input[type="search"]', 'artist'
      click 'li:contains("Artist") .js-add-entity'

      click '.js-save-feature'

      click '.js-save'

      waitForModels ['feature', 'issue']

      viewIssue 'Cantaloupe'
      click '.js-build-mailout'

      andThen ->
        expect(find('input[type="number"]').val()).to.equal('50')

        done()
