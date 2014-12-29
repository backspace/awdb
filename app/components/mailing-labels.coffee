`import Ember from 'ember'`

`import PDFDocument from 'npm:pdfkit'`
`import blobStream from 'npm:blob-stream'`

MailingLabelsComponent = Ember.Component.extend
  buildingPDF: false

  fetchFont: Ember.on 'didInsertElement', ->
    return if Ember.testing

    @set 'buildingPDF', true

    # Technique for AJAX loading a font from here:
    # https://github.com/devongovett/pdfkit/issues/340#issuecomment-66371477
    xhr = new XMLHttpRequest()
    xhr.onload = =>
      @set 'font', xhr.response
      @insertPDF()

    xhr.responseType = 'arraybuffer'
    xhr.open('GET', '/assets/fonts/ArialUnicode.ttf', true)
    xhr.send()

  insertPDF: ->
    @$().html "<iframe></iframe>"
    @$('iframe').width(350).height(453)

    font = @get 'font'

    doc = new PDFDocument
    stream = doc.pipe(blobStream())

    @get('addressables').forEach (addressable, index) ->
      doc.font(font).text("#{addressable.get('name')}\n#{addressable.get('address')}")
      doc.text("\n")

    doc.end()

    stream.on 'finish', =>
      @$('iframe').attr('src', stream.toBlobURL('application/pdf'))

`export default MailingLabelsComponent`
