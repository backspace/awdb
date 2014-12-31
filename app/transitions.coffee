`import Issue from './models/issue'`

transitions = ->
  @transition(
    @toRoute('entities', 'retailers', 'issues', 'transactions', 'settings'),
    @use('shortFade')
  )

  @transition(
    @betweenModels({instanceOf: Issue}),
    @use('shortFade')
  )

`export default transitions`
