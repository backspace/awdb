// Taken from https://gist.github.com/rsutphin/3252dfd221157d557a0b

import Ember from 'ember';
/*globals EmberPouch*/

export default EmberPouch.Serializer.extend({
  /**
   * Copied from JSONSerializer to enable default serialization of the hasMany
   * side of manyToOne relationships. It is not clear to me why this is not the
   * default â€” it seems to make it impossible to ever load the many from the one â€”
   * but there is plentiful evidence that it's not going to be changed:
   *
   * - https://github.com/emberjs/data/commit/7f752ad15eb9b9454e3da3f4e0b8c487cdc70ff0#comments
   * - https://github.com/emberjs/data/issues/2068
   * - https://github.com/emberjs/data/pull/1678
   *
   * The supported solution is to use a custom serializer for each model and
   * explicitly indicate which hasMany relationships should be embedded as IDs.
   * No thank you.
   */
  serializeHasMany: function(record, json, relationship) {
    var key = relationship.key;

    if (this._canSerialize(key)) {
      var payloadKey;

      // if provided, use the mapping provided by `attrs` in
      // the serializer
      payloadKey = this._getMappedKey(key);
      if (payloadKey === key && this.keyForRelationship) {
        payloadKey = this.keyForRelationship(key, "hasMany");
      }

      var relationshipType = record.constructor.determineRelationshipType(relationship);

      if (relationshipType === 'manyToNone' || relationshipType === 'manyToMany' || relationshipType === 'manyToOne') {
        json[payloadKey] = Ember.get(record, key).mapBy('id');
        // TODO support for polymorphic manyToNone and manyToMany relationships
      }
    }
  }
});
