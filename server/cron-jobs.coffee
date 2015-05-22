SyncedCron.add
  name: 'Send notifications about new messages in study groups daily:',
  schedule: (parser) ->
    #parser is a later.parse object: http://bunkat.github.io/later/parsers.html#overview
    return parser.text('at 6:00 AM');
  job: ->
    Logger.log 'Sending notifications about new messages in study groups (daily)'
    StudyGroup.sendUnreadCommentsEmailNotifications('daily')
    Logger.log 'Sending notifications about new messages in study groups (daily) SUCCESS'

SyncedCron.add
  name: 'Send notifications about new messages in study groups weekly:',
  schedule: (parser) ->
    #parser is a later.parse object: http://bunkat.github.io/later/parsers.html#overview
    return parser.text('at 6:00 AM on Monday');
  job: ->
    Logger.log 'Sending notifications about new messages in study groups (weekly)'
    StudyGroup.sendUnreadCommentsEmailNotifications('weekly')
    Logger.log 'Sending notifications about new messages in study groups (weekly) SUCCESS'

SyncedCron.add
  name: 'Send notifications about new messages in study groups monthly:',
  schedule: (parser) ->
    #parser is a later.parse object: http://bunkat.github.io/later/parsers.html#overview
    return parser.text('on the last day of the month');
  job: ->
    Logger.log 'Sending notifications about new messages in study groups (monthly)'
    StudyGroup.sendUnreadCommentsEmailNotifications('monthly')
    Logger.log 'Sending notifications about new messages in study groups (monthly) SUCCESS'

SyncedCron.start()
