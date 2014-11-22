/* global global */
import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Edit an issue', function () {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      global.store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        global.store.createRecord('issue', {title: 'Cranberries are contemptible'}).save().then(function(issue) {
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

    click('a:contains("Cranberries are contemptible")');
    click('button:contains("Edit")');
    fillIn('input[name="title"]', 'Cranberries are charming');
    click('button:contains("Done")');

    visit('/');

    andThen(function() {
      expect(find('li:contains("Cranberries are charming")')).to.have.length(1);
      done();
    });
  });
});
