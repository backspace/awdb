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
    done:
      text: "Let’s look at the subscribers page."
    visitEntities:
      text: "Subscribers are grouped by whether they have an active subscription, were formerly subscribed, or have never subscribed."
      before: (router) ->
        router.transitionTo '/entities'
      revert: (router) ->
        router.transitionTo '/'
    talkAboutButterfly:
      selector: 'li:contains(Butterfly)'
      text: "This is Butterfly"

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

  mapStopSelector: (stop) ->
    if stop?.selector
      $(stop.selector).addClass "joyride-#{stop.key}"
      @$("li[data-joyride-key=#{stop.key}]").attr 'data-class', "joyride-#{stop.key}"

  actions:
    startTour: ->
      firstTime = true

      stops = @get 'stopsArray'
      component = @
      router = component.container.lookup('router:main')

      goingForward = true
      joyride = Foundation.libs.joyride

      go_prev = joyride.go_prev
      joyride.go_prev = ->
        goingForward = false
        go_prev.apply(joyride)

      go_next = joyride.go_next
      joyride.go_next = ->
        goingForward = true
        go_next.apply(joyride)

      $(document).foundation 'joyride', 'start',
        pre_ride_callback: ->
          # TODO this is an unfortunate hack to compensate for the modal background disappearing upon first display
          if firstTime
            component.mapStopSelector(stops[0])
            firstTime = false
            $(document).foundation('joyride', 'hide').foundation('joyride', 'start')

        post_step_callback: (stopNumber) ->
          stop = stops[stopNumber]
          nextStop = stops[stopNumber + if goingForward then 1 else -1]

          if !goingForward
            stop.revert?(router)

          if nextStop
            component.mapStopSelector(nextStop)

            if goingForward
              nextStop.before?(router)

`export default GuidedTour`
