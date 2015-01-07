`import Entity from './models/entity'`
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

  @transition(
    @betweenModels({instanceOf: Entity}),
    @use('shortFade')
  )

`export default transitions`
