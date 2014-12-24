import Ember from 'ember';
import startApp from '../helpers/start-app';

import PouchTestHelper from '../helpers/pouch-test-helper';

var App;

describe('Acceptance: Manage entities', function() {
  beforeEach(function(done) {
    App = startApp();

    PouchTestHelper.buildStore(App, this.currentTest.title).then(function(store) {
      Ember.run(function() {
        Ember.RSVP.Promise.all([
          store.createRecord('entity', {name: "Alice", address: '123 Main St.'}).save(),
          store.createRecord('entity', {name: "Bob"}).save(),
          store.createRecord('entity', {name: "Zzzana's World of Pleasure", classification: 'institution'})
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

  it('lists the entities', function(done) {
    visit('/');
    click('a:contains("Entities")');

    andThen(function() {
      expectElement('li', {contains: 'Alice'});
      expectElement('li', {contains: 'Bob'});
      expectElement('li', {contains: "Zzzana's World of Pleasure"});

      expectElement('li', 3);

      done();
    });
  });

  it('differentiates types of entities', function(done) {
    visit('/');
    click('a:contains("Entities")');

    andThen(function() {
      expectElement('li .fa-li.fa-user', 2);
      expectElement('li .fa-li.fa-institution');

      done();
    });
  });

  it("shows an entity's details", function(done) {
    visit('/');
    click('a:contains("Entities")');
    click('a:contains("Alice")');

    andThen(function() {
      expectElement('h3', {contains: 'Alice'});
      expectElement('p', {contains: '123 Main St.'});

      done();
    });
  });

  it("lets the user create an entity", function(done) {
    visit('/');
    click('a:contains("Entities")');

    click('button:contains("New")');
    fillIn('input[name="name"]', 'Corrie');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("Entities")');

    andThen(function() {
      expectElement('li', {contains: 'Corrie'});
      done();
    });
  });

  it("lets the user edit an entity", function(done) {
    visit('/');
    click('a:contains("Entities")');
    click('a:contains("Bob")');
    click('button:contains("Edit")');

    fillIn('input[name="name"]', 'Bib');
    click('button:contains("Done")');

    visit('/');
    click('a:contains("Entities")');

    andThen(function() {
      expectElement('li', {contains: 'Bib'});
      done();
    });
  });
});
