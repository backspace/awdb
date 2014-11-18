import DS from 'ember-data';

var Issue = DS.Model.extend({
  title: DS.attr("string"),
});

Issue.reopenClass({
  FIXTURES: [
    {id: 1, title: "Apples"},
    {id: 2, title: "Bananas"}
  ]
});

export default Issue;
