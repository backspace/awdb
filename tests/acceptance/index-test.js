/* jshint expr:true */
import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var App;

describe('Acceptance: Index', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      global.store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        Ember.RSVP.Promise.all([
          store.createRecord('issue', {title: 'Apples'}).save(),
          store.createRecord('issue', {title: 'Bananas'}).save()
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

  it('lists issues', function(done) {
    visit('/');

    andThen(function() {
      expect(currentPath()).to.equal('index');

      expect(find('li:contains("Apples")')).to.have.length(1);
      expect(find('li:contains("Bananas")')).to.have.length(1);

      expect(find('li')).to.have.length(2);

      done();
    });
  });
});
