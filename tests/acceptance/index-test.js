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
      expect(find('li:contains("Issues")')).to.have.length(1);
      done();
    });
  });
});
