import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('issues', function() {
    this.route('new');
    this.resource('issue', { path: ':issue_id' }, function() {
      this.route('distribute');
      this.route('distribution', { path: 'distributions/:distribution_id' });

      this.route('printings', { path: 'printings' }, function() {
        this.route('new');
      });
    });
  });

  this.resource('entities', function() {
    this.route('new');
    this.resource('entity', { path: ':entity_id' });
  });

  this.resource('retailers', function() {
    this.route('new');
    this.resource('retailer', {path: ':retailer_id'});
  });

  this.resource('transactions', function() {
    this.resource('transaction', { path: ':transaction_id'});
  });

  this.route('settings');
});

export default Router;
