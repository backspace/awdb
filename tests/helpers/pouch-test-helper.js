var db;

export default {
  setup: function(app, name) {
    db = this.setDB(app, name);
    return app.__container__.lookup('store:main');
  },

  teardown: function(callback) {
    db.destroy(function(err) {
      if (err) return callback(err);
      callback();
    });
  },

  setDB: function(app, name) {
    var db = new PouchDB(name);
    app.__container__.lookup("adapter:application").db = db;
    return db;
  },

  logDB: function() {
    db.allDocs({include_docs: true}, function(err, docs) {
      console.log(docs);
    });
  }
};
