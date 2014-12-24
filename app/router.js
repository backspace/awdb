import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('issues', function() {
    this.resource('issue', { path: ':issue_id' }, function() {
      this.route('distribute');
    });
  });

  this.resource('entities');
  this.resource('entity', { path: 'entities/:entity_id' });

  this.resource('retailers', function() {
    this.resource('retailer', {path: ':retailer_id'});
  });

  this.route('distribution', { path: 'distributions/:distribution_id' });

  this.resource('transactions');

  this.route('settings');
});

export default Router;
