`import Ember from 'ember'`
`import startApp from './helpers/start-app'`

`import PouchTestHelper from './helpers/pouch-test-helper'`

application = null

describe.skip 'Archive test data', ->
  beforeEach (done) ->
    application = startApp()

    PouchTestHelper.buildStore(application, 'http://127.0.0.1:5984/awdb-archive').then ->
      Ember.run ->
        done()

  it 'constructs archival data', (done) ->
    @timeout 0

    createEntity = (attributes) ->
      viewEntities()
      click '.js-create'
      fillIn 'input[name=name]', attributes.name
      fillIn 'textarea[name=address]', attributes.address
      click "label:contains('#{attributes.classification}')"

      click '.js-save'

      waitForAllModels()

    createEntity
      name: 'Writer'
      address: "91 Albert St.\nWinnipeg, MB  R0E 0H0\nCanada"
      classification: 'Canada'

    createEntity
      name: 'Abstract painter'
      address: 'Syntagma Square\nAthens\nGreece'
      classification: 'International'

    createEntity
      name: 'Scylla'
      address: "Firuzağa\nIstanbul\nTurkey"
      classification: 'International'

    createEntity
      name: 'Charybdis'
      address: "Tarlabaşı\nIstanbul\nTurkey"
      classification: 'International'

    createEntity
      name: 'Subscriber'
      address: "123 Christopher St.\nNew York, NY  21212\nUSA"
      classification: 'USA'

    createEntity
      name: 'Former subscriber'
      address: "Talbot & Watt\nWinnipeg"
      classification: 'Canada'

    createEntity
      name: 'Special subscriber'
      address: "Villa Maria"
      classification: 'Canada'

    createEntity
      name: 'Hater'
      address: "100 Ingrate Ave.\nLockport, MB  R3K 1P4\nCanada"
      classification: 'Canada'

    createEntity
      name: 'The Institute'
      address: "The Hague"
      classification: 'Institution'

    createEntity
      name: 'Giftee'
      address: '42 Emerson Ave.\nWinnipeg, MB  R2F 9P9\nCanada'
      classification: 'Canada'


    createEntitySubscription = (attributes) ->
      viewEntity attributes.name
      click "input[name=#{attributes.count}]"
      fillIn 'input[name=cost]', attributes.cost if attributes.cost?
      click '.js-subscribe'

      waitForAllModels()

    createEntitySubscription
      name: 'Subscriber'
      count: 6

    createEntitySubscription
      name: 'Former subscriber'
      count: 3

    createEntitySubscription
      name: 'Special subscriber'
      count: 3
      cost: 10

    createEntitySubscription
      name: 'The Institute'
      count: 6
      cost: 10000



    createIssue = (attributes) ->
      viewIssues()
      click '.js-create'
      fillIn 'input[name=title]', attributes.title

      click '.js-save'

      waitForAllModels()

      viewIssue attributes.title

      if attributes.features
        attributes.features.forEach (feature) ->
          fillIn 'input[name=title]:last', feature.title

          feature.contributors.forEach (contributor) ->
            fillIn 'input[type=search]', contributor
            click "li:contains(#{contributor}) .fa-plus"

          click '.js-save'

          waitForModels ['feature']

      waitForAllModels()

    createIssue
      title: 'Apples'
      features: [
        {title: 'They are great', contributors: ['Writer']},
        {title: 'Not so great', contributors: ['Scylla', 'Charybdis']}
      ]

    createIssue
      title: 'Bananas'
      features: [
        {title: 'A piece', contributors: ['Bananas']}
      ]

    createIssue
      title: 'Coconuts'

    createIssue
      title: 'Durians'


    distributeIssue = (attributes) ->
      viewIssue attributes.title
      click '.js-build-distribution'

      if attributes.giftees
        attributes.giftees.forEach (giftee) ->
          fillIn 'input[type=search]', giftee
          click "li:contains(#{giftee}) .fa-plus"

      click '.js-distribute'

      waitForAllModels()

    distributeIssue
      title: 'Apples'
      giftees: ["Giftee"]

    distributeIssue
      title: 'Bananas'

    distributeIssue
      title: 'Coconuts'

    distributeIssue
      title: 'Durians'

    andThen ->
      done()
