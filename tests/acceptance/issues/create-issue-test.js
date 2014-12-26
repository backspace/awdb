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

    andThen(function() {
      expect(find('input[type="number"]').val()).to.equal('1');
    });

    fillIn('input[name="title"]', 'Bananas are better');
    click('button:contains("Done")');

    viewIssues();

    andThen(function() {
      expectElement('li', {contains: 'Bananas are better'});
      done();
    });
  });

  describe('when an issue already exists', function() {
    var existingIssueNumber = 3;

    beforeEach(function(done) {
      viewIssues();
      click('button:contains("New issue")');
      fillIn('input[name=number]', existingIssueNumber);
      click('button:contains("Done")');

      andThen(function() {
        done();
      });
    });

    it('auto-fills the next issue number', function(done) {
      viewIssues();
      click('button:contains("New issue")');

      andThen(function() {
        expect(find('input[type=number]').val()).to.equal(existingIssueNumber + 1 + '');
        done();
      });
    });
  });
});
