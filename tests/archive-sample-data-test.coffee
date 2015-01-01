`import Ember from 'ember'`
`import startApp from './helpers/start-app'`

`import PouchTestHelper from './helpers/pouch-test-helper'`

application = startApp()

if application.populateSampleDatabase
  describe 'Archive sample data', ->
    beforeEach (done) ->
      @timeout 0

      PouchTestHelper.buildStore(application, 'http://127.0.0.1:5984/awdb-sample').then ->
        Ember.run ->
          done()

    it 'constructs archival data', (done) ->
      @timeout 0

      createEntity = (attributes) ->
        viewEntities()
        click '.js-create'
        fillIn 'input[name=name]', attributes.name
        fillIn 'textarea[name=address]', attributes.address
        click "label:contains('#{attributes.classification}') input"

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created entity #{attributes.name}"

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
        name: 'Caterpillar'
        address: "A branch"
        classification: 'International'

      createEntity
        name: 'Giftee'
        address: '42 Emerson Ave.\nWinnipeg, MB  R2F 9P9\nCanada'
        classification: 'Canada'

      createEntity
        name: 'Revenant'
        address: 'The International Network'
        classification: 'International'


      createEntitySubscription = (attributes) ->
        viewEntity attributes.name
        click "input[name=#{attributes.count}]"
        fillIn 'input[name=cost]', attributes.cost if attributes.cost?
        click '.js-subscribe'

        waitForAllModels()

        andThen -> "Subscribed #{attributes.name}"

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

      createEntitySubscription
        name: 'Caterpillar'
        count: 6

      createEntitySubscription
        name: 'Revenant'
        count: 3


      createRetailer = (attributes) ->
        viewRetailers()
        click '.js-create'
        fillIn 'input[name=name]', attributes.name
        fillIn 'textarea[name=address]', attributes.address

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created retailer #{attributes.name}"

      createRetailer
        name: 'The Paddlewheel'
        address: '101 Colony St.'

      createRetailer
        name: 'Mondragón'
        address: '91 Albert St.'

      createRetailer
        name: 'The Big Box store'
        address: 'Saint James'


      createRetailSubscription = (attributes) ->
        viewRetailer attributes.name
        fillIn 'input[name=cost]', attributes.cost
        fillIn 'input[name=copies]', attributes.copies
        click '.js-subscribe'

        waitForAllModels()

        andThen -> console.log "Subscribed #{attributes.name}"

      createRetailSubscription
        name: 'The Paddlewheel'
        cost: 20
        copies: 10

      createRetailSubscription
        name: 'Mondragón'
        cost: 10
        copies: 30


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

        andThen -> "Created issue #{attributes.title}"

      createIssue
        title: 'Apples'
        features: [
          {title: 'They are great', contributors: ['Writer']},
          {title: 'Not so great', contributors: ['Scylla', 'Charybdis']}
        ]

      createIssue
        title: 'Bananas'
        features: [
          {title: 'A piece', contributors: ['Abstract painter']}
        ]

      createIssue
        title: 'Coconuts'

      createIssue
        title: 'Durians'

      createIssue
        title: 'Elderberries'
        features: [
          {title: 'Work in progress', contributors: ['Write']}
        ]


      distributeIssue = (attributes) ->
        viewIssue attributes.title
        click '.js-build-distribution'

        if attributes.giftees
          attributes.giftees.forEach (giftee) ->
            fillIn 'input[type=search]', giftee
            click "li:contains(#{giftee}) .fa-plus"

        click '.js-distribute'

        waitForAllModels()

        andThen -> "Distributed issue #{attributes.title}"

      distributeIssue
        title: 'Apples'
        giftees: ["Giftee"]

      # Cancel a retail subscription

      viewRetailer 'Mondragón'
      click '.js-unsubscribe'

      waitForAllModels()

      distributeIssue
        title: 'Bananas'

      # Change a name and address

      viewEntity 'Caterpillar'
      click '.js-edit'
      fillIn 'input[name=name]', 'Butterfly'
      fillIn 'textarea[name=address]', 'I’ll be in the air'
      click '.js-save'

      waitForModels ['entity']

      distributeIssue
        title: 'Coconuts'

      distributeIssue
        title: 'Durians'

      # Re-subscribe a former subscriber

      createEntitySubscription
        name: 'Revenant'
        count: 3

      andThen ->
        done()
