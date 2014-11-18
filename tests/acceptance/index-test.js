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

  it('lists issues', function() {
    visit('/');

    andThen(function() {
      expect(currentPath()).to.equal('index');

      Ember.run(function() {
        expect(find('li:contains("Apples")')).to.have.length(1);
        expect(find('li:contains("Bananas")')).to.have.length(1);
      });
    });
  });
});
