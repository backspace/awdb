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
    needs: ['helper:fa-icon']
  },
  function() {
    var subscription = Ember.Object.create({isNew: true});

    it('renders', function() {
      // creates the component instance
      var component = this.subject({subscription: subscription});
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
        var component = this.subject({subscription: subscription});
        var $component = this.render();

        expectElement('button[disabled]');
      });

      describe('when the subscription is complete', function() {
        beforeEach(function() {
          subscription.setProperties({copies: 3, cost: 3});
        });

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

      describe('when the subscription is persisted', function() {
        beforeEach(function() {
          subscription.setProperties({isNew: false, copies: 5, cost: 40});
        });

        it('shows the disabled version of the form', function() {
          var component = this.subject({subscription: subscription});
          var $component = this.render();

          expectElement('input[name=cost][disabled]');
          expectElement('input[name=copies][disabled]');

          expect(find('input[name=cost]').val()).to.equal('40');
          expect(find('input[name=copies]').val()).to.equal('5');
        });

        it('relays the end action', function(done) {
          var component = this.subject({subscription: subscription});
          var $component = this.render();

          var target = {
            externalAction: function() {
              expect(true).to.be.ok;
              done();
            }
          };

          component.set('end', 'externalAction');
          component.set('targetObject', target);

          click('button');
        });
      });
    });
  }
);

