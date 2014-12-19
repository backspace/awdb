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

  this.resource('people');
  this.resource('person', { path: 'people/:person_id' });

  this.route('distribution', { path: 'distributions/:distribution_id' });

  this.route('settings');
});

export default Router;
