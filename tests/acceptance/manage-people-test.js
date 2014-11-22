/* global global */
import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var App;

describe('Acceptance: Manage people', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      global.store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        Ember.RSVP.Promise.all([
          global.store.createRecord('person', {name: "Alice"}).save(),
          global.store.createRecord('person', {name: "Bob"}).save()
        ]).then(function() {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    PouchTestHelper.teardown(done);
  });

  it('lists the people', function(done) {
    visit('/');
    click('a:contains("People")');

    andThen(function() {
      expect(find('li:contains("Alice")')).to.have.length(1);
      expect(find('li:contains("Bob")')).to.have.length(1);

      expect(find('li')).to.have.length(2);

      done();
    });
  });
});
