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
    endAcceptanceTest(done)

  it 'shows the new feature', (done) ->
    viewIssue 'Full of features'

    fillIn 'input[name="title"]', 'Like this one'

    fillIn 'input[type="search"]', 'alice'
    click 'li:contains("Alice") .fa-plus'

    fillIn 'input[type="search"]', 'ob'
    click 'li:contains("Bob") .fa-plus'

    click 'i.fa-check'

    viewIssue 'Full of features'

    andThen ->
      expectElement 'li', {contains: 'Like this one'}
      expectElement 'li:contains(Like)', {contains: 'Alice'}
      expectElement 'li:contains(Like)', {contains: 'Bob'}

      done()

  it 'supports creating a new entity via a contribution', (done) ->
    viewIssue 'Full of features'

    fillIn 'input[name=title]', 'Welcome'
    fillIn 'input[type=search]', 'Francine'
    click 'li:contains("Francine") .fa-plus'

    click 'i.fa-check'

    waitForModels ['feature', 'entity']

    viewIssue 'Full of features'

    andThen ->
      expectElement 'li:contains(Welcome)', {contains: 'Francine'}

    viewEntities()

    andThen ->
      expectElement 'li', {contains: 'Francine'}

      done()
