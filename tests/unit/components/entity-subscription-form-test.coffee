`import {describeComponent} from 'ember-mocha'`

`import Ember from 'ember'`
`import startApp from '../../helpers/start-app'`

# TODO am I really just testing observers?

describeComponent 'entity-subscription-form', 'EntitySubscriptionFormComponent', {needs: ['helper:fa-icon', 'component:radio-button']},
  ->
    settings = null
    entity = null
    subscription = null

    beforeEach ->
      settings = Ember.Object.create
        costForSubscription: ->
          100

      entity = Ember.Object.create()
      subscription = Ember.Object.create()

      @container.register 'settings:main', settings,
        instantiate: false

    it 'gets the subscription cost from settings', ->
      component = @subject({entity: entity, subscription: subscription})
      $component = @render()

      expect($component.find('input[name=cost]').val(), 'cost should be 100').to.equal('100')

    it 'defaults to 3 issues', ->
      component = @subject({entity: entity, subscription: subscription})
      $component = @render()

      expect($component.find('input[name=3]').is(':checked'), '3 should be selected').to.be.ok

    it 'is ready to create by default', ->
      component = @subject({entity: entity, subscription: subscription})
      $component = @render()

      expect($component.find('button:not([disabled])').is('*'), 'button should not be disabled').to.be.ok

    it 'relays the save action', (done) ->
      component = @subject({entity: entity, subscription: subscription})
      $component = @render()

      target =
        action: ->
          expect(true).to.be.ok
          done()

      component.set 'save', 'action'
      component.set 'targetObject', target

      $component.find('button').trigger 'click'

    describe 'when the cost field is empty', ->
      component = null
      $component = null

      beforeEach ->
        component = @subject({entity: entity, subscription: subscription})
        $component = @render()

        $component.find('input[name=cost]').val('').trigger('change')

      it 'the button is disabled', (done) ->
        Ember.run.later ->
          expect($component.find('button[disabled]').is('*'), 'button should be disabled').to.be.ok
          done()

    describe 'when the subscription already has a count of 6', ->
      beforeEach ->
        subscription.set 'count', '6'

      it 'selects 6 issues', ->
        component = @subject({entity: entity, subscription: subscription})
        $component = @render()

        expect($component.find('input[name=6]').is(':checked'), '6 should be selected').to.be.ok

    describe 'when the cost is more expensive in Canada', ->
      beforeEach ->
        settings.costForSubscription = (count, classification) ->
          if classification == 'canada'
            999
          else
            10
      describe 'and the entity is international', ->
        $component = null

        beforeEach ->
          entity.set 'classification', 'international'
          component = @subject({entity: entity, subscription: subscription})
          $component = @render()

        it 'gets the lower cost', ->
          expect($component.find('input[name=cost]').val(), 'cost should be 10').to.equal('10')

        describe 'but then changes to Canada', ->
          beforeEach ->
            Ember.run ->
              entity.set 'classification', 'canada'

          it 'gets the higher cost', ->
            expect($component.find('input[name=cost]').val(), 'cost should be 999').to.equal('999')
