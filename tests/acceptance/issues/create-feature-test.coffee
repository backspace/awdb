`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

App = null
store = null

describe "Acceptance: Create issue feature", ->
  beforeEach (done) ->
    App = startApp()

    currentTest = @currentTest

    andThen ->
      store = PouchTestHelper.setup(App, currentTest.title)

      Ember.run ->
        store.createRecord('issue', {title: 'Full of features'}).save().then ->
          done()

  afterEach (done) ->
    Ember.run(App, 'destroy')
    PouchTestHelper.teardown(done)

  it 'shows the new feature', (done) ->
    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Full of features")'

    fillIn 'input[name="title"]', 'Like this one'
    click 'i.fa-check'

    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Full of features")'

    andThen ->
      expect(find('li:contains("Like this one")')).to.have.length 1

      done()
