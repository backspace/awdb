`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

`import PouchTestHelper from '../../helpers/pouch-test-helper'`

App = null
records = null

describe "Acceptance: Create issue feature", ->
  beforeEach (done) ->
    App = startApp()

    PouchTestHelper.buildStore(App, @currentTest.title).then (store) ->
      Ember.run ->
        Ember.RSVP.hash(
          issue: store.createRecord('issue', {title: 'Full of features'}).save(),
          alice: store.createRecord('entity', {name: 'Alice'}).save(),
          bob: store.createRecord('entity', {name: 'Bob'}).save()
        ).then (result) ->
          records = result
          done()

  afterEach (done) ->
    Ember.run(App, 'destroy')
    Ember.run(done)

  it 'shows the new feature', (done) ->
    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Full of features")'

    fillIn 'input[name="title"]', 'Like this one'
    fillIn 'select[name="contributor"]:last', records.alice.id
    fillIn 'select[name="contributor"]:last', records.bob.id
    click 'i.fa-check'

    visit '/'
    click 'a:contains("Issues")'
    click 'a:contains("Full of features")'

    andThen ->
      expectElement 'li', {contains: 'Like this one: Alice, Bob'}

      done()
