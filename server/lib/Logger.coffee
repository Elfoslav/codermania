class @Logger
  Logs = new Mongo.Collection('logs')
  @log: (msg, type) ->
    check msg, String
    check type, String
    if msg
      console.log msg, type || ''
      Logs.insert
        message: msg
        type: type
        date: new Date()