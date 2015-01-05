`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

`import PouchTestHelper from '../helpers/pouch-test-helper'`

App = null
entities = null

describe "Acceptance: Distribute issues", ->
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

    describe 'and the new subscriber is deleted from the distribution', (done) ->
      beforeEach (done) ->
        viewIssue 'Apples'
        click '.js-build-distribution'

        click '.js-subscriptions li:contains("Cara") .js-delete'

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

  describe 'building a distribution for the existing issue', ->
    beforeEach (done) ->
      viewIssue 'Apples'
      click '.js-build-distribution'

      andThen ->
        done()

    it 'does not suggest subscribers who have already received an issue', (done) ->
      andThen ->
        expectNoElement '.js-recipients li', {contains: 'Previewer'}
        expectElement '.js-recipients li', {contains: 'Bookstore'}
        expectElement '.js-subscriptions li', {contains: 'Bob'}

        done()

    it 'will not distribute when there are no recipients', (done) ->
      click '.js-delete'

      andThen ->
        expectElement '.js-distribute[disabled]'

        done()

    it 'the proposed distribution lists active subscribers and contributors as recipients', (done) ->
      andThen ->
        expectElement '.js-subscriptions li', {contains: 'Alice'}
        expectElement '.js-subscriptions li', {contains: 'Bob'}

        expectElement '.js-retail-subscriptions li', {contains: 'Bookstore'}

        expectElement '.js-contributions li', {contains: 'Artist'}

        done()

    it 'uses the default $100 feature compensation', (done) ->
      andThen ->
        expectElement 'li:contains("Crunchy is better: Artist") input[type=number]'
        expect(find('input[type="number"]').val()).to.equal('100')

        done()

    describe 'with additional recipient with no address', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'Addressless'
        click 'li:contains("Addressless") .fa-plus'

        andThen ->
          done()

      it 'the new recipient is listed with a warning', (done) ->
        andThen ->
          expectElement '.js-extras li.warning[title*="no address"]', {contains: 'Addressless'}

          done()

      it 'will not distribute because the recipient has no address', (done) ->
        andThen ->
          expectElement 'button.js-distribute[disabled]'

          done()

    describe 'with an additional recipient who has an address', ->
      beforeEach (done) ->
        fillIn 'input[type="search"]', 'ext'
        click 'li:contains("Extra") .fa-plus'

        andThen ->
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
            expectElement 'li', {contains: 'Apples are amazing'}

            done()

    describe 'when it is distributed', ->
      beforeEach (done) ->
        fillIn 'input[type="number"]', '200'
        click 'button:contains("Distribute")'

        waitForModels ['issue', 'subscription', 'fulfillment', 'distribution']

        andThen ->
          done()

      it 'shows the completed distribution', (done) ->
        andThen ->
          expectElement 'h2', {contains: "Distribution of issue Apples are amazing"}
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
          expectElement 'li', {contains: 'Apples are amazing'}

          done()

      it 'retains the name in the distribution even if it has since changed', (done) ->
        viewEntity 'Alice'
        click 'button:contains("Edit")'
        fillIn('input[name=name]', 'Newname')
        click('button:contains("Done")')

        waitForModels ['entity']

        viewIssue 'Apples'
        click '.distributions li a'

        andThen ->
          expectElement 'a', {contains: 'Alice'}

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

      it 'does not compensate nor fulfill contributors for a second distribution', (done) ->
        viewIssue 'Apples'
        click '.js-build-distribution'

        andThen ->
          expectNoElement '.js-contributions li', {contains: 'Artist'}
          expectNoElement 'input[type=number]'

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

    it 'uses the new feature compensation in a distribution', (done) ->
      viewIssues()
      click '.js-create'
      fillIn 'input[name="title"]', 'Cantaloupe is capricious'
      click 'button:contains("Done")'

      waitForModels ['issue']

      click '.js-edit'

      fillIn '.js-new input[name="title"]', 'Sometimes so good'

      fillIn 'input[type="search"]', 'artist'
      click 'li:contains("Artist") .fa-plus'

      click 'i.fa-check:first'

      click '.js-save'

      waitForModels ['feature', 'issue']

      viewIssue 'Cantaloupe'
      click '.js-build-distribution'

      andThen ->
        expect(find('input[type="number"]').val()).to.equal('50')

        done()
