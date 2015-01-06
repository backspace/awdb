import Ember from 'ember';

// Taken from https://coderwall.com/p/ryo_3w/add-the-pluralize-helper-in-ember-handlebars-templates

export function pluralSuffix(number, options) {
    var phraseMatch = ( options.hash.phrase || '[|s]' ).match( /(.*?)\[(.*?)\|(.*?)\]/ );
    Ember.assert( 'The optional "phrase" hash for {{plural-suffix}} should be formatted as <phrase to pluralize>[<singular ending>|<plural ending>]', phraseMatch );
    var word = phraseMatch[ 1 ],
        singular = word + phraseMatch[ 2 ],
        plural = word + phraseMatch[ 3 ];
    return number === 1 ? singular : plural;
}

export default Ember.Handlebars.makeBoundHelper(pluralSuffix);
