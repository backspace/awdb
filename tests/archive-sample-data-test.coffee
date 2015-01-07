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

      createEntity
        name: 'Latecomer'
        address: '100 Bandwagon Way'
        classification: 'Canada'

      createEntity
        name: 'Bad printer'
        address: 'Mediocrity Ave.'
        classification: 'Canada'

      createEntity
        name: 'Great printer'
        address: 'Excellence Ave.'
        classification: 'Canada'


      createEntitySubscription = (attributes) ->
        viewEntity attributes.name
        click "input[name=#{attributes.count}]"
        fillIn 'input[name=cost]', attributes.cost if attributes.cost?
        click '.js-subscribe'

        waitForAllModels()

        andThen -> console.log "Subscribed #{attributes.name}"

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

      createRetailer
        name: 'Popup'
        address: 'The Exchange'


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
          click '.js-edit'

          attributes.features.forEach (feature) ->
            fillIn 'input[name=title]:last', feature.title

            feature.contributors.forEach (contributor) ->
              fillIn 'input[type=search]', contributor
              click "li:contains(#{contributor}):first .fa-plus:first"

            click '.js-save-feature'

          click '.js-save'

          waitForModels ['feature', 'issue']

        waitForAllModels()

        andThen -> console.log "Created issue #{attributes.title}"

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


      createPrinting = (attributes) ->
        viewIssue attributes.title

        click '.js-build-printing'

        fillIn 'input[name=count]', attributes.count
        fillIn 'input[name=cost]', attributes.cost
        fillIn 'input[type=search]', attributes.printer
        click '.js-add-entity'

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created printing for issue #{attributes.title}"

      createPrinting
        title: 'Apples'
        count: 50
        cost: 500
        printer: 'Bad printer'

      createPrinting
        title: 'Apples'
        count: 10
        cost: 250
        printer: 'Bad printer'

      createPrinting
        title: 'Bananas'
        count: 40
        cost: 300
        printer: 'Bad printer'

      createPrinting
        title: 'Coconuts'
        count: 50
        cost: 550
        printer: 'Great printer'

      createPrinting
        title: 'Durians'
        count: 55
        cost: 550
        printer: 'Great printer'

      createPrinting
        title: 'Elderberries'
        count: 70
        cost: 600
        printer: 'Great printer'


      mailIssue = (attributes) ->
        viewIssue attributes.title
        click '.js-build-mailout'

        if attributes.giftees
          attributes.giftees.forEach (giftee) ->
            fillIn 'input[type=search]', giftee
            click "li:contains(#{giftee}) .fa-plus"

        click '.js-save-mailout'

        waitForAllModels()

        andThen -> console.log "Mailed issue #{attributes.title}"

      mailIssue
        title: 'Apples'
        giftees: ["Giftee"]

      # Cancel a retail subscription

      viewRetailer 'Mondragón'
      click '.js-unsubscribe'

      waitForAllModels()

      mailIssue
        title: 'Bananas'

      # Change a name and address

      viewEntity 'Caterpillar'
      click '.js-edit'
      fillIn 'input[name=name]', 'Butterfly'
      fillIn 'textarea[name=address]', 'I’ll be in the air'
      click '.js-save'

      waitForModels ['entity']

      mailIssue
        title: 'Coconuts'

      # Add subscriptions

      createEntitySubscription
        name: 'Latecomer'
        count: 6

      createRetailSubscription
        name: 'Popup'
        cost: 10
        copies: 40

      mailIssue
        title: 'Durians'

      # Re-subscribe a former subscriber

      createEntitySubscription
        name: 'Revenant'
        count: 3

      andThen ->
        done()
