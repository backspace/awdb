`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

App = null

feature = null
alice = null

describe "Acceptance: Edit issue feature", ->
  beforeEach (done) ->
    App = startApp()

    andThen =>
      PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
        Ember.run ->
          issue = store.createRecord('issue', {title: 'Featureful'})

          issue.save().then ->
            feature = store.createRecord('feature', {title: 'Oops', issue: issue})

            feature.save().then ->
              issue.get('features').pushObject(feature)
              issue.save().then ->
                alice = store.createRecord('entity', {name: 'Alice'})
                alice.save().then ->
                  done()

  afterEach (done) ->
    endAcceptanceTest(done)

  describe 'when the feature name is changed', ->
    beforeEach (done) ->
      viewIssue 'Featureful'

      click '.js-edit'

      click 'li:contains("Oops") .js-edit-feature'
      fillIn 'li.js-persisted input[name="title"]', 'Corrected'

      click 'li.js-persisted .js-save-feature'

      click '.js-save'

      waitForModels ['issue', 'feature']

      andThen ->
        done()

    it 'shows the updated feature name', (done) ->
      andThen ->
        expectElement 'li', {contains: 'Corrected'}

        done()

  describe 'when a contributor is added', ->
    beforeEach (done) ->
      viewIssue 'Featureful'

      click '.js-edit'

      click 'li:contains("Oops") .js-edit-feature'

      fillIn 'input[type="search"]', 'alice'
      click 'li:contains("Alice") .js-add-entity'

      click 'li.js-persisted .js-save-feature'

      click '.js-save'

      waitForModels ['issue', 'feature', 'contribution']

      andThen ->
        done()

    it 'shows the new contributor', (done) ->
      viewIssue 'Featureful'

      andThen ->
        expectElement 'li:contains(Oops)', {contains: 'Alice'}

        done()

    describe 'and then removed', ->
      beforeEach (done) ->
        click '.js-edit'

        click 'li:contains("Oops") .js-edit-feature'
        click 'li:contains("Alice") .js-remove-contribution'

        click 'li.js-persisted .js-save-feature'

        click '.js-save'

        waitForModels ['issue', 'feature']

        andThen ->
          done()

      it 'no longer shows the contributor', (done) ->
        viewIssue 'Featureful'

        andThen ->
          expectNoElement 'li', {contains: 'Oops: Alice'}

          done()
