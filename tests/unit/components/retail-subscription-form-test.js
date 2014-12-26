/* jshint expr:true */
import {
  describeComponent,
  it
} from 'ember-mocha';

import Ember from 'ember';
import startApp from '../../helpers/start-app';

describeComponent(
  'retail-subscription-form',
  'RetailSubscriptionFormComponent',
  {
    // specify the other units that are required for this test
    // needs: ['component:foo', 'helper:bar']
  },
  function() {
    it('renders', function() {
      // creates the component instance
      var component = this.subject();
      expect(component._state).to.equal('preRender');

      // renders the component on the page
      this.render();
      expect(component._state).to.equal('inDOM');
    });

    describe('interacting', function() {
      beforeEach(function() {
        startApp();
      });

      it('prevents saving when the subscription is incomplete', function() {
        var component = this.subject();
        var $component = this.render();

        expectElement('button[disabled]');
      });

      describe('when the subscription is complete', function() {
        var subscription = Ember.Object.create({copies: 3, cost: 3});

        it('relays the save action', function(done) {
          var component = this.subject({subscription: subscription});
          var $component = this.render();

          var target = {
            externalAction: function() {
              expect(true).to.be.ok;
              done();
            }
          };

          component.set('save', 'externalAction');
          component.set('targetObject', target);

          click('button');
        });
      });
    });
  }
);
