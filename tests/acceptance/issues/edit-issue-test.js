import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;
var store;

describe('Acceptance: Edit an issue', function () {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        store.createRecord('issue', {title: 'Cranberries are contemptible'}).save().then(function(issue) {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    PouchTestHelper.teardown(done);
  });

  it('saves an edited issue', function(done) {
    visit('/');
    click('a:contains("Issues")');

    click('a:contains("Cranberries are contemptible")');
    click('button:contains("Edit")');
    fillIn('input[name="title"]', 'Cranberries are charming');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("Issues")');

    andThen(function() {
      expectElement('li', {contains: 'Cranberries are charming'});
      done();
    });
  });
});
