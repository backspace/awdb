/* jshint expr:true */
/* global global */
import Ember from 'ember';
import startApp from '../../helpers/start-app';

import PouchTestHelper from '../../helpers/pouch-test-helper';

var App;

describe('Acceptance: Issue list', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      global.store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        Ember.RSVP.Promise.all([
          global.store.createRecord('issue', {title: 'Figs', number: 6}).save(),
          global.store.createRecord('issue', {title: 'Eggplants', number: 5}).save(),
          global.store.createRecord('issue', {title: 'Durians', number: 4}).save(),
          global.store.createRecord('issue', {title: 'Coconuts', number: 3}).save(),
          global.store.createRecord('issue', {title: 'Bananas', number: 2}).save(),
          global.store.createRecord('issue', {title: 'Apples', number: 1}).save()
        ]).then(function() {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    Ember.run(App, 'destroy');
    PouchTestHelper.teardown(done);
  });

  it('lists issues', function(done) {
    visit('/');
    click('a:contains("Issues")');

    andThen(function() {
      expect(find('li:contains("Apples")')).to.have.length(1);
      expect(find('li:contains("Bananas")')).to.have.length(1);
      expect(find('li:contains("Coconuts")')).to.have.length(1);
      expect(find('li:contains("Durians")')).to.have.length(1);
      expect(find('li:contains("Eggplants")')).to.have.length(1);
      expect(find('li:contains("Figs")')).to.have.length(1);

      expect(find('li:contains("Apples") + li:contains("Bananas") + li:contains("Coconuts") + li:contains("Durians") + li:contains("Eggplants") + li:contains("Figs")')).to.have.length(1);

      expect(find('li')).to.have.length(6);

      done();
    });
  });
});
