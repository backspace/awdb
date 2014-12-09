import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Create issue', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      PouchTestHelper.setup(App, currentTest.title);
      done();
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    PouchTestHelper.teardown(done);
  });

  it('lets the user create a new issue', function(done) {
    visit('/');
    click('a:contains("Issues")');

    click('button:contains("New issue")');
    fillIn('input[name="title"]', 'Bananas are better');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("Issues")');

    andThen(function() {
      expectElement('li', {contains: 'Bananas are better'});
      done();
    });
  });
});
