Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@hue} = @sut
    @hue.connect = sinon.stub().yields null
    @sut.start {}, done

  afterEach (done) ->
    @sut.close done

  it 'should call connect', ->
    expect(@hue.connect).to.have.been.called

  describe 'on change:username', ->
    beforeEach ->
      @sut.emit = sinon.stub()
      apikey =
        some: 'thing'

      @hue.emit 'change:username', {apikey}

    it 'should emit update', ->
      apikey =
        some: 'thing'
      expect(@sut.emit).to.have.been.calledWith 'update', {apikey}

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)
