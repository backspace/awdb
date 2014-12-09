import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var App;
var store;

describe('Acceptance: Manage people', function() {
  beforeEach(function(done) {
    App = startApp();

    var currentTest = this.currentTest;

    andThen(function() {
      store = PouchTestHelper.setup(App, currentTest.title);

      Ember.run(function() {
        Ember.RSVP.Promise.all([
          store.createRecord('person', {name: "Alice", address: '123 Main St.'}).save(),
          store.createRecord('person', {name: "Bob"}).save()
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

  it('lists the people', function(done) {
    visit('/');
    click('a:contains("People")');

    andThen(function() {
      expectElement('li', {contains: 'Alice'});
      expectElement('li', {contains: 'Bob'});

      expectElement('li', 2);

      done();
    });
  });

  it("shows a person's details", function(done) {
    visit('/');
    click('a:contains("People")');
    click('a:contains("Alice")');

    andThen(function() {
      expectElement('h3', {contains: 'Alice'});
      expectElement('p', {contains: '123 Main St.'});

      done();
    });
  });

  it("lets the user create a person", function(done) {
    visit('/');
    click('a:contains("People")');

    click('button:contains("New")');
    fillIn('input[name="name"]', 'Corrie');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("People")');

    andThen(function() {
      expectElement('li', {contains: 'Corrie'});
      done();
    });
  });

  it("lets the user edit a person", function(done) {
    visit('/');
    click('a:contains("People")');
    click('a:contains("Bob")');
    click('button:contains("Edit")');

    fillIn('input[name="name"]', 'Bib');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("People")');

    andThen(function() {
      expectElement('li', {contains: 'Bib'});
      done();
    });
  });
});
