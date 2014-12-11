/* jshint expr:true */
import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Issue list', function() {
  beforeEach(function(done) {
    App = startApp();

    PouchTestHelper.buildStore(App, this.currentTest.title).then(function(store) {
      Ember.run(function() {
        Ember.RSVP.Promise.all([
          store.createRecord('issue', {title: 'Figs', number: 6}).save(),
          store.createRecord('issue', {title: 'Eggplants', number: 5}).save(),
          store.createRecord('issue', {title: 'Durians', number: 4}).save(),
          store.createRecord('issue', {title: 'Coconuts', number: 3}).save(),
          store.createRecord('issue', {title: 'Bananas', number: 2}).save(),
          store.createRecord('issue', {title: 'Apples', number: 1}).save()
        ]).then(function() {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    Ember.run(done);
  });

  it('lists issues', function(done) {
    visit('/');
    click('a:contains("Issues")');

    andThen(function() {
      expectElement('li', {contains: 'Apples'});
      expectElement('li', {contains: 'Bananas'});
      expectElement('li', {contains: 'Coconuts'});
      expectElement('li', {contains: 'Durians'});
      expectElement('li', {contains: 'Eggplants'});
      expectElement('li', {contains: 'Figs'});

      expectElement('li:contains("Apples") + li:contains("Bananas") + li:contains("Coconuts") + li:contains("Durians") + li:contains("Eggplants") + li:contains("Figs")');

      expectElement('li', 6);

      done();
    });
  });
});
