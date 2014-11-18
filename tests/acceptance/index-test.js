/* jshint expr:true */
import Ember from 'ember';
import startApp from '../helpers/start-app';

var App;

describe('Acceptance: Index', function() {
  beforeEach(function() {
    global.db = new PouchDB('awdb');

    App = startApp();

    Ember.run(function() {
      var store = App.__container__.lookup('store:main');
      store.createRecord('issue', {title: "Apples"});
      store.createRecord('issue', {title: "Bananas"});
    });
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
    global.db.destroy();
  });

  it('lists issues', function() {
    visit('/');

    andThen(function() {
      expect(currentPath()).to.equal('index');

      Ember.run(function() {
        expect(find('li:contains("Apples")')).to.have.length(1);
        expect(find('li:contains("Bananas")')).to.have.length(1);

        expect(find('li')).to.have.length(2);
      });

      wait();
    });
  });
});
