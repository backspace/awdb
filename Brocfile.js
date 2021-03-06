/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({
  'ember-cli-foundation-sass': {
    'foundationJs': ['joyride']
  }
});

// Use `app.import` to add additional libraries to the generated
// output files.
//
// If you need to use different assets in different
// environments, specify an object as the first parameter. That
// object's keys should be the environment name and the values
// should be the asset to use in that environment.
//
// If the library that you are including contains AMD or ES6
// modules that you would like to import into your application
// please specify an object with the list of modules as keys
// along with the exports of each module as its value.

app.import('bower_components/es5-shim/es5-shim.js');
app.import('bower_components/es6-shim/es6-shim.js');

app.import('bower_components/pouchdb/dist/pouchdb.js');
app.import('bower_components/relational-pouch/dist/pouchdb.relational-pouch.js');
app.import('bower_components/ember-pouch/dist/globals/main.js');

app.import('bower_components/d3/d3.min.js');
app.import('bower_components/c3/c3.css');
app.import('bower_components/c3/c3.min.js');
app.import('bower_components/ember-c3/build/lib.js');

app.import('bower_components/align-column/jquery.align-column.js');

module.exports = app.toTree();
