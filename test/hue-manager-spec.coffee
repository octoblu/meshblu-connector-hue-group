HueManager = require '../src/hue-manager'

describe 'HueManager', ->
  beforeEach ->
    @sut = new HueManager
    @sut._updateState = sinon.stub().yields null
    @sut.verify = sinon.stub().yields null

  afterEach (done) ->
    @sut.close done

  describe '->connect', ->
    beforeEach (done) ->
      @sut.connect {}, done

    it 'should create a hue connection', ->
      expect(@sut.hue).to.exist

    it 'should update apikey', ->
      apikey =
        devicetype: 'newdeveloper'
      expect(@sut.apikey).to.deep.equal apikey

  context 'with an active client', ->
    beforeEach (done) ->
      options =
        groupNumber: 4
      @sut.connect {options}, (error) =>
        {@hue} = @sut
        done error

    describe '->changeGroup', ->
      beforeEach (done) ->
        @hue.changeGroup = sinon.stub().yields null
        data =
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeGroup data, done

      it 'should call changeGroup', ->
        options =
           on: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeGroup).to.have.been.calledWith 4, options

  context 'on state change', ->
    beforeEach (done) ->
      options =
        groupNumber: 4
      @sut.connect {options}, (error) =>
        {@hue} = @sut
        done error

    describe '->changeGroup', ->
      beforeEach (done) ->
        @hue.changeGroup = sinon.stub().yields null
        data =
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeGroup data, done

      it 'should call changeGroup', ->
        options =
           on: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeGroup).to.have.been.calledWith 4, options
