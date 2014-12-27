/* jshint expr:true */
import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;
var entities;

describe('Acceptance: Issue lists features', function() {
  beforeEach(function(done) {
    App = startApp();

    PouchTestHelper.buildStore(App, this.currentTest.title).then(function(store) {
      Ember.run(function() {
        Ember.RSVP.hash({
          alice: store.createRecord('entity', {name: 'Alice'}).save(),
          bob: store.createRecord('entity', {name: 'Bob'}).save()
        }).then(function(result) {
          entities = result;
          var issue = store.createRecord('issue', {title: 'All about apples'});

          issue.save().then(function() {
            var feature = store.createRecord('feature', {title: 'Apples are tasty', issue: issue});

            feature.save().then(function() {
              issue.get('features').addObject(feature);

              issue.save().then(function() {
                Ember.RSVP.all([
                  store.createRecord('contribution', {feature: feature, entity: entities.alice}).save(),
                  store.createRecord('contribution', {feature: feature, entity: entities.bob}).save()
                ]).then(function(contributions) {
                  feature.get('contributions').pushObjects(contributions);
                  feature.save().then(function() {
                    done();
                  });
                });
              });
            });
          });
        });
      });
    });
  });

  afterEach(function(done) {
    endAcceptanceTest(done);
  });

  it('lists the features in an issue', function(done) {
    viewIssue('All about apples');

    andThen(function() {
      expectElement('li', {contains: 'Apples are tasty: Alice, Bob'});

      done();
    });
  });
});
