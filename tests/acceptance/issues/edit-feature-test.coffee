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
    waitForModels ['entity', 'feature']

    andThen ->
      Ember.run(App, 'destroy')
      Ember.run(done)

  describe 'when the feature name is changed', ->
    beforeEach (done) ->
      viewIssue 'Featureful'

      click 'li:contains("Oops") .js-target'
      fillIn 'li.js-persisted input[name="title"]', 'Corrected'

      click 'li.js-persisted i.fa-check'

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
      click 'li:contains("Oops") .js-target'

      fillIn 'input[type="search"]', 'alice'
      click 'li:contains("Alice") .fa-plus'

      click 'li.js-persisted i.fa-check'

      waitForModels ['issue', 'feature']

      andThen ->
        done()

    it 'shows the new contributor', (done) ->
      viewIssue 'Featureful'

      andThen ->
        expectElement 'li', {contains: 'Oops: Alice'}

        done()

    describe 'and then removed', ->
      beforeEach (done) ->
        click 'li:contains("Oops") .js-target'
        click 'li:contains("Alice") .fa-trash'

        click 'li.js-persisted i.fa-check'

        waitForModels ['issue', 'feature']

        andThen ->
          done()

      it 'no longer shows the contributor', (done) ->
        viewIssue 'Featureful'

        andThen ->
          expectNoElement 'li', {contains: 'Oops: Alice'}

          done()
