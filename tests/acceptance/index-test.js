/* jshint expr:true */
import Ember from 'ember';
import startApp from '../helpers/start-app';

var App;

describe('Acceptance: Index', function() {
  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  it('can visit /', function() {
    visit('/');

    andThen(function() {
      expect(currentPath()).to.equal('index');

      Ember.run(function() {
        expect(find('h2:contains("Welcome")')).to.have.length(1);
      });
    });
  });
});
