`import Ember from 'ember'`

MailingLabelsComponent = Ember.Component.extend
  insertPDF: Ember.on 'didInsertElement', ->
    # TODO does this help?
    return if Ember.testing

    @$().html "<iframe></iframe>"
    @$('iframe').width(350).height(453)

    doc = new jsPDF()

    labelHeight = 30

    @get('addressables').forEach (addressable, index) ->
      doc.text 20, (index + 1)*labelHeight + 1, "#{addressable.get('name')}\n#{addressable.get('address')}"

    @$('iframe').attr('src', doc.output('datauristring'))

`export default MailingLabelsComponent`
