`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

App = null
store = null

feature = null
alice = null

describe "Acceptance: Edit issue feature", ->
  beforeEach (done) ->
    App = startApp()

    andThen =>
      store = PouchTestHelper.setup(App, @currentTest.title)

      Ember.run ->
        issue = store.createRecord('issue', {title: 'Featureful'})

        issue.save().then ->
          feature = store.createRecord('feature', {title: 'Oops', issue: issue})

          feature.save().then ->
            issue.get('features').pushObject(feature)
            issue.save().then ->
              alice = store.createRecord('person', {name: 'Alice'})
              alice.save().then ->
                done()

  afterEach (done) ->
    Ember.run(App, 'destroy')
    PouchTestHelper.teardown(done)

  it 'updates the feature', (done) ->
    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Featureful")'

    click 'li:contains("Oops") .js-target'
    fillIn 'li.js-persisted input[name="title"]', 'Corrected'
    fillIn 'li.js-persisted select', alice.id
    click 'li.js-persisted i.fa-check'

    # TODO figure out how to refresh rather than this hack to ensure the change is persisted
    andThen ->
      click 'li:contains("Corrected: Alice") .js-target'
      fillIn 'li.js-persisted input[name="title"]', 'Recorrected'
      click 'li.js-persisted i.fa-undo'

      visit '/'
      click 'a:contains("Issues")'
      click 'a:contains("Featureful")'

      andThen ->
        expect(find('li:contains("Corrected: Alice")')).to.have.length 1

        done()