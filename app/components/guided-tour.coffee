`import Ember from 'ember'`

GuidedTour = Ember.Component.extend
  stops: Ember.Object.create
    navEntities:
      selector: '.fa-users'
      text: "Here you can work with subscribers."
    navRetailers:
      selector: '.fa-shopping-cart'
      text: "This is where you find retailers."
    navIssues:
      selector: '.fa-book'
      text: "You manage issues in here."
    navTransactions:
      selector: '.fa-dollar'
      text: "This is where transactions are listed."
    navSettings:
      selector: '.fa-gear'
      text: "You can adjust settings here."

  stopsArray: Ember.computed 'stops', ->
    stops = @get('stops')

    stopKeys = Ember.keys(stops)

    firstKey = stopKeys.get('firstObject')
    lastKey = stopKeys.get('lastObject')

    stopKeys.map (key) ->
      stop = Ember.Object.create(stops.get(key))

      stop.set 'key', key

      stop.set 'options', 'prev_button: false' if firstKey == key
      stop.set 'options', 'next_button: false' if lastKey == key

      stop

  attachIDs: Ember.on 'didInsertElement', ->
    stops = @get 'stopsArray'
    stops.forEach (stop) =>
      $(stop.selector).addClass "joyride-#{stop.key}"
      @$("li[data-joyride-key=#{stop.key}]").attr 'data-class', "joyride-#{stop.key}"

  actions:
    startTour: ->
      firstTime = true

      $(document).foundation 'joyride', 'start',
        pre_ride_callback: ->
          # TODO this is an unfortunate hack to compensate for the modal background disappearing upon first display
          if firstTime
            firstTime = false
            $(document).foundation('joyride', 'hide').foundation('joyride', 'start')

`export default GuidedTour`
