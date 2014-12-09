/* jshint expr:true */
import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;
var store;

describe('Acceptance: Issue lists features', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        Ember.RSVP.hash({
          alice: store.createRecord('person', {name: 'Alice'}).save(),
          bob: store.createRecord('person', {name: 'Bob'}).save()
        }).then(function(people) {
          var issue = store.createRecord('issue', {title: 'All about apples'});

          issue.save().then(function() {
            var feature = store.createRecord('feature', {title: 'Apples are tasty', issue: issue});
            feature.get('contributors').pushObjects([people.alice, people.bob]);

            feature.save().then(function() {
              issue.get('features').addObject(feature);

              issue.save().then(function() {
                done();
              });
            });
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
    click('a:contains("Issues")');

    click('a:contains("All about apples")');

    andThen(function() {
      expectElement('li', {contains: 'Apples are tasty: Alice, Bob'});

      done();
    });
  });
});
