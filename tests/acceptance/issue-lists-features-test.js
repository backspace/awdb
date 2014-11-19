/* jshint expr:true */
/* global global */
import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var App;

describe('Acceptance: Issue lists features', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      global.store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        global.store.createRecord('issue', {title: 'All about apples'}).save().then(function(issue) {
          var feature = global.store.createRecord('feature', {title: 'Apples are tasty'});
          issue.get('features').addObject(feature);

          feature.save().then(function() {
            done();
          });
        });
      });
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    PouchTestHelper.teardown(done);
  });

  it('lists the features in an issue', function(done) {
    visit('/');

    click('a:contains("All about apples")');

    andThen(function() {
      expect(find('li:contains("Apples are tasty")')).to.have.length(1);

      done();
    });
  });
});
