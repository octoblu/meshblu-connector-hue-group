_              = require 'lodash'
HueUtil        = require 'hue-util'
{EventEmitter} = require 'events'
tinycolor      = require 'tinycolor2'
debug          = require('debug')('meshblu-connector-hue-group:hue-manager')
_              = require 'lodash'

class HueManager extends EventEmitter
  connect: ({ @options, @apikey, desiredState }, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @apikey ?= {}
    @options ?= {}
    {apiUsername, ipAddress, @groupNumber} = @options
    {username} = @apikey
    apiUsername ?= 'newdeveloper'
    @apikey.devicetype = apiUsername
    @hue = new HueUtil apiUsername, ipAddress, username, @_onUsernameChange
    @stateInterval = setInterval @_updateState, 30000
    @changeGroup desiredState, callback

  close: (callback) =>
    clearInterval @stateInterval
    delete @stateInterval
    callback()

  _onUsernameChange: (username) =>
    return if username == @apikey.username
    @apikey.username = username
    @_emit 'change:username', {@apikey}

  _updateState: (update={}, callback=_.noop) =>
    @getGroup (error, group) =>
      return callback() if error?
      update = _.merge update, group
      @_emit 'update', update
      callback()

  getGroup: (callback) =>
    @hue.getGroup @groupNumber, (error, group) =>
      return callback error if error?
      { lights, state } = group
      { bri, sat, hue, alert, effect } = group.action

      bri = (bri / 254) * 100
      hue = (hue / 254) * 100
      sat = (sat / 254) * 100

      color = "hsl(" + hue + "%," + sat + "%," + bri + "%)"

      return callback null, {
        color: tinycolor(color).toHex8String()
        alert: alert
        effect: effect
        on: group.action.on
        lights: lights
        state: state
      }

  changeGroup: (data, callback) =>
    return callback() if _.isEmpty data
    {
      color
      transitionTime
      alert
      effect
    } = data

    @hue.changeGroup @groupNumber, { color, transitionTime, alert, effect, on: data.on }, (error) =>
      return callback error if error?
      @_updateState desiredState: null, callback

module.exports = HueManager
