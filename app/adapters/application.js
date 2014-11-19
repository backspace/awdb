import config from '../config/environment';

export default EmberPouch.Adapter.extend({
  db: new PouchDB(config.APP.databaseName)
});
