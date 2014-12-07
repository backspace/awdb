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
      expect(find('li:contains("Alice")')).to.have.length(1);
      expect(find('li:contains("Bob")')).to.have.length(1);

      expect(find('li')).to.have.length(2);

      done();
    });
  });

  it("shows a person's details", function(done) {
    visit('/');
    click('a:contains("People")');
    click('a:contains("Alice")');

    andThen(function() {
      expect(find('h3:contains("Alice")')).to.have.length(1);
      expect(find('p:contains("123 Main St.")')).to.have.length(1);

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
      expect(find('li:contains("Corrie")')).to.have.length(1);
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
      expect(find('li:contains("Bib")')).to.have.length(1);
      done();
    });
  });
});
