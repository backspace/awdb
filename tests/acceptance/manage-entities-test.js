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
          store.createRecord('entity', {name: "Zzzana's World of Pleasure", classification: 'institution'}).save(),
          store.createRecord('entity', {name: "Mondragón", isRetailer: true}).save()
        ]).then(function() {
          done();
        });
      });
    });
  });

  afterEach(function(done) {
    endAcceptanceTest(done);
  });

  it('lists the entities', function(done) {
    viewEntities();

    andThen(function() {
      expectElement('li', {contains: 'Alice'});
      expectElement('li', {contains: 'Bob'});
      expectElement('li', {contains: "Zzzana's World of Pleasure"});

      expectElement('li:not(.heading)', 3);

      done();
    });
  });

  it('does not list retailers', function(done) {
    viewEntities();

    andThen(function() {
      expectNoElement('li', {contains: 'Mondragón'});

      done();
    });
  });

  it('differentiates types of entities', function(done) {
    viewEntities();

    andThen(function() {
      expectElement('li .fa-li.fa-user', 2);
      expectElement('li .fa-li.fa-institution');

      done();
    });
  });

  it("shows an entity's details", function(done) {
    viewEntity("Alice");

    andThen(function() {
      expectElement('h3', {contains: 'Alice'});
      expectElement('p', {contains: '123 Main St.'});

      done();
    });
  });

  it("lets the user create an entity", function(done) {
    viewEntities();

    click('button:contains("New")');
    fillIn('input[name="name"]', 'Corrie');
    click('button:contains("Done")');

    viewEntities();

    andThen(function() {
      expectElement('li', {contains: 'Corrie'});
      done();
    });
  });

  it("lets the user edit an entity", function(done) {
    viewEntity("Bob");
    click('button:contains("Edit")');

    fillIn('input[name="name"]', 'Bib');
    click('button:contains("Done")');

    viewEntities();

    andThen(function() {
      expectElement('li', {contains: 'Bib'});
      done();
    });
  });
});
