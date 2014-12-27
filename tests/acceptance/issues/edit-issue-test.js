import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Edit an issue', function () {
  beforeEach(function(done) {
    App = startApp();

    PouchTestHelper.buildStore(App, this.currentTest.title).then(function(store) {
      Ember.run(function() {
        store.createRecord('issue', {title: 'Cranberries are contemptible'}).save().then(function(issue) {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    endAcceptanceTest(done);
  });

  it('saves an edited issue', function(done) {
    viewIssues();

    click('a:contains("Cranberries are contemptible")');
    click('button:contains("Edit")');
    fillIn('input[name="title"]', 'Cranberries are charming');
    click('button:contains("Done")');

    viewIssues();

    andThen(function() {
      expectElement('li', {contains: 'Cranberries are charming'});
      done();
    });
  });
});
