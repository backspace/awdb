`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

application = null

describe "Acceptance: Track printings", ->
  beforeEach (done) ->
    application = startApp()

    andThen =>
      PouchTestHelper.buildStore(application, @currentTest.title).then (store) ->
        Ember.run ->
          Ember.RSVP.hash(
            issue: store.createRecord('issue', {title: 'Printworthy'}).save()
            printer: store.createRecord('entity', {name: 'Printer', address: 'Printertopia'}).save()
          ).then (records) ->
            done()

  afterEach (done) ->
    endAcceptanceTest(done)

  describe "when a printing is entered", ->
    beforeEach (done) ->
      viewIssue 'Printworthy'

      click '.js-build-printing'

      fillIn 'input[name=count]', 30
      fillIn 'input[name=cost]', 300
      fillIn 'input[type=search]', 'Print'

      click 'li:contains(Printer) .js-add-entity'

      click '.js-save'

      waitForModels ['issue', 'printing']

      andThen ->
        done()

    it "is listed for the issue", (done) ->
      viewIssue "Printworthy"

      andThen ->
        expectElement '.printings li', {contains: '30'}
        expectElement '.printings li', {contains: 'Printer'}

        done()

    it "the stock is increased", (done) ->
      viewIssue "Printworthy"

      andThen ->
        expectElement '.stock', {contains: '30 copies'}
        done()

    it "a transaction is generated", (done) ->
      viewTransactions()

      andThen ->
        expectElement 'tr:contains(Printer) td', {contains: "-$300"}

        done()

    describe "and a copy is mailed", ->
      beforeEach (done) ->
        click '.js-build-mailout'
        fillIn 'input[type=search]', 'Print'
        click 'li:contains(Printer) .js-add-entity'

        click '.js-save-mailout'

        waitForModels ['issue', 'mailout']

        andThen ->
          done()

      it "decreases the stock", (done) ->
        viewIssue "Printworthy"

        andThen ->
          expectElement '.stock', {contains: '29 copies'}
          done()
