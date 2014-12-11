var db;

export default {
  buildStore: function(app, name) {
    return PouchDB.destroy(name).then(function(a, b) {
      return (new PouchDB(name)).then(function(newDB, b) {
        app.__container__.lookup("adapter:application").db = newDB;
        db = newDB;
        return app.__container__.lookup('store:main');
      });
    });
  },

  logDB: function() {
    db.allDocs({include_docs: true}, function(err, docs) {
      console.log(JSON.stringify(docs, null, 4));
    });
  }
};
