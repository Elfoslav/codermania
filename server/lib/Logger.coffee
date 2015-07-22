class @Logger
  Logs = new Mongo.Collection('logs')
  @log: (msg, type, origin) ->
    check msg, String
    check type, String
    check origin, Match.Optional String
    if msg
      console.log msg, type || ''
      Logs.insert
        message: msg
        type: type
        origin: origin
        timestamp: Date.now()
        date: new Date()
    if type is 'error'
      Email.send
        from: 'logger@codermania.com'
        to: 'tomas@codermania.com'
        subject: 'An error occured on CoderMania'
        html: "Error: \"#{msg}\" has occured in #{origin}"