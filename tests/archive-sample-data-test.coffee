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

      # Define helper methods

      createEntity = (attributes) ->
        viewEntities()
        click '.js-create'
        fillIn 'input[name=name]', attributes.name
        fillIn 'textarea[name=address]', attributes.address
        click "label:contains('#{attributes.classification}') input"

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created entity #{attributes.name}"

      createEntitySubscription = (attributes) ->
        viewEntity attributes.name
        click "input[name=#{attributes.count}]"
        fillIn 'input[name=cost]', attributes.cost if attributes.cost?
        click '.js-subscribe'

        waitForAllModels()

        andThen -> console.log "Subscribed #{attributes.name}"

      createRetailer = (attributes) ->
        viewRetailers()
        click '.js-create'
        fillIn 'input[name=name]', attributes.name
        fillIn 'textarea[name=address]', attributes.address

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created retailer #{attributes.name}"

      createRetailSubscription = (attributes) ->
        viewRetailer attributes.name
        fillIn 'input[name=copies]', attributes.copies
        click '.js-subscribe'

        waitForAllModels()

        andThen -> console.log "Subscribed #{attributes.name}"

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
              click "li:contains(#{contributor}):first .js-add-entity"

            click '.js-save-feature'

          click '.js-save'

          waitForModels ['feature', 'issue']

        waitForAllModels()

        andThen -> console.log "Created issue #{attributes.title}"

      createPrinting = (attributes) ->
        viewIssue attributes.title

        click '.js-build-printing'

        fillIn 'input[name=count]', attributes.count
        fillIn 'input[name=cost]', attributes.cost

        andThen ->
          if find('.js-delete-printer').is('*')
            click '.js-delete-printer'

        fillIn 'input[type=search]', attributes.printer
        click '.js-add-entity'

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created printing for issue #{attributes.title}"

      createReturn = (attributes) ->
        viewRetailer attributes.retailer

        click '.js-build-return'

        fillIn 'input[name=returned]', attributes.returned
        fillIn 'input[name=sold]', attributes.sold

        andThen ->
          issueID = find("select option:contains(#{attributes.issue})").attr('value')
          fillIn "select", issueID

        click '.js-save'

        waitForAllModels()

        andThen -> console.log "Created return of issue #{attributes.issue} for retailer #{attributes.retailer}"

      mailIssue = (attributes) ->
        viewIssue attributes.title
        click '.js-build-mailout'

        if attributes.giftees
          attributes.giftees.forEach (giftee) ->
            fillIn 'input[type=search]', giftee
            click "li:contains(#{giftee}) .js-add-entity"

        if attributes.extras
          for name, cost of attributes.extras
            fillIn 'input[type=search]', name
            click "li:contains(#{name}) .js-add-entity"

            fillIn "li:contains(#{name}) input[type=number]", cost if cost?

        click '.js-save-mailout'

        waitForAllModels()

        andThen -> console.log "Mailed issue #{attributes.title}"

      # First issue

      createEntity
        name: 'Writer'
        address: "91 Albert St.\nWinnipeg, MB  R0E 0H0\nCanada"
        classification: 'Canada'

      createEntity
        name: 'Scylla'
        address: "Firuzağa\nIstanbul\nTurkey"
        classification: 'International'

      createEntity
        name: 'Charybdis'
        address: "Tarlabaşı\nIstanbul\nTurkey"
        classification: 'International'

      createIssue
        title: 'Apples'
        features: [
          {title: 'They are great', contributors: ['Writer']},
          {title: 'Not so great', contributors: ['Scylla', 'Charybdis']}
        ]

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
        name: 'Hater'
        address: "100 Ingrate Ave.\nLockport, MB  R3K 1P4\nCanada"
        classification: 'Canada'

      createEntity
        name: 'Bad printer'
        address: 'Mediocrity Ave.'
        classification: 'Canada'

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

      createRetailer
        name: 'The Paddlewheel'
        address: '101 Colony St.'

      createRetailer
        name: 'Mondragón'
        address: '91 Albert St.'

      createRetailer
        name: 'The Big Box store'
        address: 'Saint James'

      createRetailSubscription
        name: 'The Paddlewheel'
        copies: 10

      createRetailSubscription
        name: 'Mondragón'
        copies: 30

      createPrinting
        title: 'Apples'
        count: 50
        cost: 500
        printer: 'Bad printer'

      mailIssue
        title: 'Apples'
        giftees: ["Giftee"]

      createPrinting
        title: 'Apples'
        count: 10
        cost: 250
        printer: 'Bad printer'

      createReturn
        retailer: 'The Paddlewheel'
        issue: 'Apples'
        returned: 2
        sold: 8

      createReturn
        retailer: 'Mondragón'
        issue: 'Apples'
        returned: 1
        sold: 29

      # Cancel a retail subscription

      viewRetailer 'Mondragón'
      click '.js-unsubscribe'

      waitForAllModels()


      # Second issue

      createEntity
        name: 'Abstract painter'
        address: 'Syntagma Square\nAthens\nGreece'
        classification: 'International'

      createIssue
        title: 'Bananas'
        features: [
          {title: 'A piece', contributors: ['Abstract painter']}
        ]

      createPrinting
        title: 'Bananas'
        count: 20
        cost: 200
        printer: 'Bad printer'

      mailIssue
        title: 'Bananas'

      createReturn
        retailer: 'The Paddlewheel'
        issue: 'Bananas'
        returned: 4
        sold: 6

      # Change a name and address

      viewEntity 'Caterpillar'
      click '.js-edit'
      fillIn 'input[name=name]', 'Butterfly'
      fillIn 'textarea[name=address]', 'I’ll be in the air'
      click '.js-save'

      waitForModels ['entity']


      # Third issue

      createEntity
        name: 'Great printer'
        address: 'Excellence Ave.'
        classification: 'Canada'

      createIssue
        title: 'Coconuts'

      createPrinting
        title: 'Coconuts'
        count: 30
        cost: 350
        printer: 'Great printer'

      mailIssue
        title: 'Coconuts'

      createReturn
        retailer: 'The Paddlewheel'
        issue: 'Coconuts'
        returned: 2
        sold: 8


      # Mail back issues

      createEntity
        name: 'Latecomer'
        address: '100 Bandwagon Way'
        classification: 'Canada'

      mailIssue
        title: 'Apples'
        extras:
          Latecomer: 25

      mailIssue
        title: 'Bananas'
        extras:
          Latecomer: null

      mailIssue
        title: 'Coconuts'
        extras:
          Latecomer: null

      createRetailer
        name: 'Popup'
        address: 'The Exchange'

      # Add subscriptions

      createEntitySubscription
        name: 'Latecomer'
        count: 6

      createRetailSubscription
        name: 'Popup'
        copies: 40


      # Fourth issue

      createIssue
        title: 'Durians'

      createPrinting
        title: 'Durians'
        count: 55
        cost: 600
        printer: 'Great printer'

      mailIssue
        title: 'Durians'

      createReturn
        retailer: 'The Paddlewheel'
        issue: 'Durians'
        returned: 5
        sold: 5


      # Fifth issue

      createIssue
        title: 'Elderberries'
        features: [
          {title: 'Work in progress', contributors: ['Writer']}
        ]

      createPrinting
        title: 'Elderberries'
        count: 60
        cost: 650
        printer: 'Great printer'

      # Re-subscribe a former subscriber

      createEntitySubscription
        name: 'Revenant'
        count: 3

      andThen ->
        done()
