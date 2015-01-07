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
    @timeout 3000
    viewIssue 'Full of features'

    click '.js-edit'

    fillIn '.js-new input[name="title"]', 'Like this one'

    fillIn 'input[type="search"]', 'alice'
    click 'li:contains("Alice") .js-add-entity'

    fillIn 'input[type="search"]', 'ob'
    click 'li:contains("Bob") .js-add-entity'

    click '.js-save-feature'

    click '.js-save'

    waitForModels ['issue', 'feature', 'contribution']

    viewIssue 'Full of features'

    andThen ->
      expectElement 'li', {contains: 'Like this one'}
      expectElement 'li:contains(Like)', {contains: 'Alice'}
      expectElement 'li:contains(Like)', {contains: 'Bob'}

      done()

  it 'supports creating two features at once', (done) ->
    viewIssue 'Full of features'

    click '.js-edit'

    fillIn '.js-new input[name=title]:last', 'One feature'

    fillIn 'input[type=search]', 'alice'
    click 'li:contains(Alice) .js-add-entity'

    click '.js-save-feature:last'

    fillIn '.js-new input[name=title]:last', 'Two features'

    fillIn 'input[type=search]', 'bob'
    click 'li:contains(Bob) .js-add-entity'

    click '.js-save-feature:last'

    click '.js-save'

    waitForModels ['issue', 'feature', 'contribution']

    viewIssue 'Full of features'

    andThen ->
      expectElement 'li', {contains: 'One'}
      expectElement 'li:contains(One)', {contains: 'Alice'}

      expectElement 'li', {contains: 'Two'}
      expectElement 'li:contains(Two)', {contains: 'Bob'}

      done()

  it 'supports creating a new entity via a contribution', (done) ->
    # TODO why is this so slow?
    @timeout 5000

    viewIssue 'Full of features'

    click '.js-edit'

    fillIn '.js-new input[name=title]', 'Welcome'
    fillIn 'input[type=search]', 'Francine'

    click 'li:contains("Francine") .js-create-contributor'

    waitForModels ['entity']

    click '.js-save-feature:last'

    click '.js-save'

    waitForModels ['feature', 'entity', 'contribution']

    viewIssue 'Full of features'

    andThen ->
      expectElement 'li:contains(Welcome)', {contains: 'Francine'}

    viewEntities()

    andThen ->
      expectElement 'li', {contains: 'Francine'}

      done()
