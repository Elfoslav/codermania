class @Logger
  Logs = new Mongo.Collection('logs')
  @log: (msg, data) ->
    if msg
      console.log msg, data || ''
      Logs.insert
        message: msg
        date: new Date()