import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Create issue', function() {
  beforeEach(function(done) {
    App = startApp();

    PouchTestHelper.buildStore(App, this.currentTest.title).then(function() {
      done();
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    Ember.run(done);
  });

  it('lets the user create a new issue', function(done) {
    viewIssues();

    click('button:contains("New issue")');
    fillIn('input[name="title"]', 'Bananas are better');
    click('button:contains("Done")');

    viewIssues();

    andThen(function() {
      expectElement('li', {contains: 'Bananas are better'});
      done();
    });
  });
});
