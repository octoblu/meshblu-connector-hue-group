{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue-group:index')
HueManager      = require './hue-manager'
_               = require 'lodash'

class Connector extends EventEmitter
  constructor: ->
    @hue = new HueManager
    @hue.on 'update', (data) =>
      @emit 'update', data
    @hue.on 'change:username', ({apikey}) =>
      @emit 'update', {apikey}

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    @hue.close callback

  onConfig: (device={}, callback=->) =>
    { options, apikey, desiredState } = device
    debug 'on config', options
    @hue.close (error) =>
      return callback error if error?
      @hue.connect {options, apikey, desiredState}, (error) =>
        return callback error if error?
        @connected = true
        callback()

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
