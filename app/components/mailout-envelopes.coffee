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
    @$('iframe').width(453).height(350)

    font = @get 'font'

    doc = new PDFDocument
      layout: 'landscape'
    stream = doc.pipe(blobStream())

    addressables = @get('addressables')
    lastAddressable = addressables.get('lastObject')

    returnAddress = @get('returnAddress')

    addressables.forEach (addressable) ->
      doc.font(font).text("#{addressable.get('name')}\n#{addressable.get('address')}", 350, 250)
        .text(returnAddress, 50, 50)

      doc.addPage() unless addressable == lastAddressable

    doc.end()

    stream.on 'finish', =>
      @$('iframe').attr('src', stream.toBlobURL('application/pdf'))

`export default MailingLabelsComponent`
