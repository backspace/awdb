`import Ember from 'ember'`

MailingLabelsComponent = Ember.Component.extend
  insertPDF: Ember.on 'didInsertElement', ->
    # TODO does this help?
    return if Ember.testing

    @$().html "<iframe></iframe>"
    @$('iframe').width(350).height(453)

    doc = new PDFDocument
    stream = doc.pipe(blobStream())

    @get('addressables').forEach (addressable, index) ->
      doc.text("#{addressable.get('name')}\n#{addressable.get('address')}")
      doc.text("\n")

    doc.end()

    stream.on 'finish', =>
      @$('iframe').attr('src', stream.toBlobURL('application/pdf'))

`export default MailingLabelsComponent`
