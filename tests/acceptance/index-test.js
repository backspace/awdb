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
      expect(find('a:contains("Issues")')).to.have.length(1);
      expect(find('a:contains("People")')).to.have.length(1);
      done();
    });
  });
});
