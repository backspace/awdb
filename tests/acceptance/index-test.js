import Ember from 'ember';
import startApp from '../helpers/start-app';

var App;

describe('Acceptance: Index lists models', function() {
  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  it('lists the types of models', function(done) {
    visit('/');

    andThen(function() {
      expectElement('a', {contains: 'Issues'});
      expectElement('a', {contains: 'People'});
      done();
    });
  });
});
