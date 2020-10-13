{
  UNIT_PARAMETERS: {
    warrior: {
      health: 40,
      damage: 8,
      attackCooldown: 1.5,
      attackRange: 5,
      speed: 12
    },

    knight: {
      health: 70,
      damage: 4,
      attackCooldown: 1,
      attackRange: 5,
      speed: 8
    },

    thief: {
      health: 20,
      damage: 10,
      attackCooldown: 0.5,
      attackRange: 4,
      speed: 16
    },
    wizard: {
      health: 10,
      damage: 20,
      attackCooldown: 4,
      attackRange: 30,
      speed: 10
    },
    archer: {
      health: 20,
      damage: 3,
      attackCooldown: 0.5,
      attackRange: 20,
      speed: 14
    },
    thrower: {
      health: 25,
      damage: 7,
      attackCooldown: 0.7,
      attackRange: 10,
      speed: 15
    },

    buffer: {
      health: 10,
      damage: 2,
      attackCooldown: 0.5,
      attackRange: 20,
      speed: 8
    },
    warlock: {
      health: 10,
      damage: 2,
      attackCooldown: 0.5,
      attackRange: 20,
      speed: 8
    },
    peasant: {
      health: 10,
      damage: 1,
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 10
    }
  }
  ROUNDS_TO_WIN: 2
  MAX_ROUND_TIME: 10
  CLOUD_SPEED: 10
  POISON_RATIO: 0.3
  ALLOWED_UNIT_EVENT_NAMES: ["spawn"]
  MAX_UNITS: 9
  N_ROUNDS: 3
  MAX_ROUNDS: 5
  IN_RECT_SHIFT: [
    Vector(3, 0), Vector(3, 3), Vector(3, -3),
    Vector(0, 0), Vector(0, 3), Vector(0, -3),
    Vector(-3, 0), Vector(-3, 3), Vector(-3, -3)
    ]

  setupGlobal: (hero, color) ->
    game = {
      on: @gameOn.bind(@, hero, color)
      randInt: @world.rand.rand2,
      setActionFor: @setActionFor.bind(@, hero, color),
      log: console.log
      }
    Object.defineProperty(game, 'roundTime', {
      get: () => @gameTime(),
      set: (x) => return 0
    })
    aether = @world.userCodeMap[hero.id]?.plan
    esperEngine = aether?.esperEngine
    if esperEngine
      esperEngine.options.foreignObjectMode = 'smart'
      esperEngine.options.bookmarkInvocationMode = "loop"
      esperEngine.addGlobal?('game', game)
      # esperEngine.addGlobal?('game2', @game2)

  setupGame: ->
    @actionHelpers = {
      "red": {}
      "blue": {}
      }
    @gameHandlers = {
      "red": {}
      "blue": {}
      }
    @setupGlobal(@hero, "red")
    @setupGlobal(@hero2, "blue")
    @clouds = []
    @hero.isAttackable = false
    @hero.health = 2
    @hero.maxHealth = 2
    @hero2.isAttackable = false
    @hero2.health = 2
    @hero2.maxHealth = 2


  setSpawnPositions: ->

    @spawnPositions = []
    @spawnPositionCounters = {}
    @redSpawnPositions = []
    @blueSpawnPositions = []
    for i in [0..5]
      th = @world.getThangByID("pos-red-" + i)
      th.index = i
      @redSpawnPositions.push(th)
    for i in [0..5]
      th = @world.getThangByID("pos-blue-" + i)
      th.index = i
      @blueSpawnPositions.push(th)
    @spawnPositions = @redSpawnPositions.concat(@blueSpawnPositions)


  setUpLevel: ->
    @setupGame()
    @setSpawnPositions()
    @unitCounter = {}
    @skele1 = @world.getThangByID("Skulldugger")
    @skele2 = @world.getThangByID("Bonesworth")
    @ref = @world.getThangByID("ref")
    # @ref.say("REF")
    @round = 1
    @redWin = 0
    @blueWin = 0
    @uiTrackedProperties = ["redWin"]
    @addTrackedProperties ["uiTrackedProperties", "array"]
    @keepTrackedProperty "uiTrackedProperties"
    @ref.say("ROUND #{@round}. RED: #{@redWin} - BLUE: #{@blueWin}")

  onFirstFrame: ->
    for th in @world.thangs when th.health? and not th.isProgrammable
      th.setExists(false)
    @prepareRound()

  chooseAction: ->
    if @roundStarted
      @checkWinner()
      @checkFog()

  #checkVictory: ->

  getPosXY: (color, n) ->
    rectID = "pos-#{color}-#{n}"
    rect = @world.getThangByID(rectID)
    i = @spawnPositionCounters[rectID]
    @spawnPositionCounters[rectID] += 1
    shift = @IN_RECT_SHIFT[i % @IN_RECT_SHIFT.length].copy()
    if color is "blue"
      shift.x *= -1
    return rect.pos.copy().add(shift)

  setupUnit: (unit, unitType, color) ->
    params = @UNIT_PARAMETERS[unitType]
    unit.maxHealth = params.health
    unit.health = params.health
    unit.keepTrackedProperty("maxHealth")
    unit.keepTrackedProperty("health")
    unit.attackDamage = params.damage
    unit.keepTrackedProperty("attackDamage")
    unit.attackRange = params.attackRange
    unit.keepTrackedProperty("attackRange")
    unit.maxSpeed = params.speed
    unit.keepTrackedProperty("maxSpeed")
    if unit.actions.attack?.cooldown
      unit.actions.attack.cooldown = params.attackCooldown
    unit.commander = @
    unit.type = unitType
    unit.color = color
    # if @actionHelpers?[color]?[unitType]
    #   for event in @ALLOWED_UNIT_EVENT_NAMES
    #     handler = @actionHelpers?[color][unitType][event]
    #     if handler and _.isFunction(handler)
    #       unit.off(event)
    #       unit.on(event, handler)

  createUnit: (unitType, color, posNumber) ->
    if not @UNIT_PARAMETERS[unitType]
      unitType = "peasant"
    #TODO checking posN
    # nColor = if color is "red" then 0 else 1 # TO CHANGE ????
    pos = @getPosXY(color, posNumber)
    fullType = "#{unitType}-#{color}"
    @unitCounter[fullType] ?= 0
    @buildables[fullType].ids = ["#{fullType}-#{@unitCounter[fullType]}"]
    @unitCounter[fullType]++
    unit = @instabuild("#{unitType}-#{color}", pos.x, pos.y, "#{unitType}-#{color}")
    @setupUnit(unit, unitType, color)
    return unit

  prepareRound: ->
    @hero.health = @MAX_UNITS
    @hero.maxHealth = @MAX_UNITS
    @hero.keepTrackedProperty("health")
    @hero.keepTrackedProperty("maxHealth")
    @hero2.health = @MAX_UNITS
    @hero2.maxHealth = @MAX_UNITS
    @hero2.keepTrackedProperty("health")
    @hero2.keepTrackedProperty("maxHealth")


    for th in @spawnPositions
      th.setExists(true)
      th.say?(th.index)
      th.alpha = 0.5
      th.keepTrackedProperty("alpha")
      @spawnPositionCounters[th.id] = 0
    @unitsInGame = []
    @gameStates = {
      red: {
        availableUnits: ["knight", "warrior", "thief", "archer", "wizard", "thrower", "buffer", "warlock", "peasant"],
        myUnits: [],
        enemyUnits: [],
        round: @round,
        myPositions:[[], [], [], [], [], []],
        enemyPositions:[[], [], [], [], [], []],
      },
      blue: {
        availableUnits: ["knight", "warrior", "thief", "archer", "wizard", "thrower", "buffer", "warlock", "peasant"],
        myUnits: [],
        enemyUnits: [],
        round: @round,
        myPositions:[[], [], [], [], [], []],
        enemyPositions:[[], [], [], [], [], []],
      }
    }
    try
      @gameHandlers["red"]?["start"]?(_.cloneDeep(@gameStates.red))
      # @gameHandlers["red"]?["prepare"]?(_.cloneDeep(@gameStates.red))
    catch error
      @hero.handleProgrammingError error, 'plan'
    try
      @gameHandlers["blue"]?["start"]?(_.cloneDeep(@gameStates.blue))
      # @gameHandlers["blue"]?["prepare"]?(_.cloneDeep(@gameStates.blue))
    catch error
      @hero2.handleProgrammingError error, 'plan'
    redChooseHandler = @gameHandlers["red"]["choose"] or () => "peasant"
    redPlaceHandler = @gameHandlers["red"]["place"] or () => 0
    blueChooseHandler = @gameHandlers["blue"]["choose"] or () => "peasant"
    bluePlaceHandler = @gameHandlers["blue"]["place"] or () => 0
    for i in [0...@MAX_UNITS]
      @processTeam("red", "blue", redChooseHandler, redPlaceHandler)
      @processTeam("blue", "red", blueChooseHandler, bluePlaceHandler)
    @ref.setExists(true)
    @ref.say("ROUND #{@round}. RED: #{@redWin} - BLUE: #{@blueWin}")
    @setTimeout((() => @ref.say(3)), 1)
    @setTimeout((() => @ref.say(2)), 2)
    @setTimeout((() => @ref.say(1)), 3)
    @setTimeout((() => @ref.say("GO! GO! GO!")), 4)
    @setTimeout(@clearRects.bind(@), 1)
    @setTimeout(@startRound.bind(@), 4)

  clearField: ->
    @unitCounter = {}
    for u in @unitsInGame
      u.setExists(false)
    @unitsInGame = []
    @prepareRound()

  processTeam: (color, opColor, chooseHandler, placeHandler) ->
    try
      unitType = chooseHandler(_.cloneDeep(@gameStates[color]))
    catch error
      (if color is 'red' then @hero else @hero2).handleProgrammingError error, 'plan'
    # TODO UNIT CHECKING
    if not unitType or not @UNIT_PARAMETERS[unitType]
      unitType = "peasant"
    @gameStates[color].myUnits.push(unitType)
    @gameStates[opColor].enemyUnits.push(unitType)

    try
      rectPosN = placeHandler(_.cloneDeep(@gameStates[color]))
    catch error
      (if color is 'red' then @hero else @hero2).handleProgrammingError error, 'plan'
    # TODO POS CHECKING
    if isNaN(rectPosN)
      rectPosN = 0
    if rectPosN < 0 or rectPosN > 5
      rectPosN = 0
    @gameStates[color].myPositions[rectPosN].push(unitType)
    @gameStates[opColor].enemyPositions[rectPosN].push(unitType)

    @unitsInGame.push(@createUnit(unitType, color, rectPosN))

  clearRects: ->
    for s in @spawnPositions
      s.alpha = 0
      s.clearSpeech()
      s.keepTrackedProperty("alpha")

  gameTime: ->
    if not @roundStarted
      return 0
    return @world.age - @roundStartTime

  startRound: () ->
    @roundStarted = true
    @roundStartTime = @world.age
    @ref.setExists(false)
    @skele1.setExists(true)
    @skele2.setExists(true)
    for unit in @unitsInGame when unit
      unit.startsPeaceful = false
      unit.commander = null

      # unit.trigger?("spawn")
      fn = @actionHelpers[unit.color]?[unit.type]?["spawn"]
      if fn and _.isFunction(fn)
        if unit.color is "red"
          unit.commander = @hero
        if unit.color is "blue"
          unit.commander = @hero2
        unit.didTriggerSpawnEvent = true
        unit.on("spawn", fn)

  checkFog: ->
    return if not @roundStarted
    if @poisonFog
      poisonDist = (@world.age - @poisonStartedTime) * @CLOUD_SPEED
      @poisonLeft = Math.min(poisonDist, 40)
      @poisonRight = Math.max(80 - poisonDist, 40)
      for unit in @unitsInGame when unit.exists and unit.health > 0
        if unit.pos.x <= @poisonLeft or unit.pos.x >= @poisonRight
          randomness = 1 + @world.rand.randf() / 5 - 0.1  # from 0.9 to 1.1
          unit.health -= unit.maxHealth * (@POISON_RATIO * @world.dt * randomness)
      for th in @clouds when th.exists and th.left
        th.pos.x = @poisonLeft + th.shift
        th.keepTrackedProperty("pos")
      for th in @clouds when th.exists and th.right
        th.pos.x = @poisonRight + th.shift
        th.keepTrackedProperty("pos")
    else if @world.age > @roundStartTime + @MAX_ROUND_TIME
      @startFog()


  startFog: ->
    @poisonFog = true
    @poisonLeft = 0
    @poisonRight = 80
    @clouds = []
    @rightClouds = []
    @poisonStartedTime = @world.age
    for y in [4..68] by 8
      for x in [-4..-36] by -8
        cloud = @instabuild("poison-cloud", x, y)
        # cloud.moveXY(40 + x, y)
        cloud.shift = x
        cloud.left = true
        cloud.maxSpeed = @CLOUD_SPEED
        @clouds.push(cloud)
      for x in [84..116] by 8
        cloud = @instabuild("poison-cloud", x, y)
        cloud.shift = x - 80
        cloud.right = true
        cloud.maxSpeed = @CLOUD_SPEED
        @clouds.push(cloud)

  checkWinner: () ->
    return if not @roundStarted
    aliveRed = (th for th in @unitsInGame when th.team is "humans" and th.health > 0).length
    aliveBlue = (th for th in @unitsInGame when th.team is "ogres" and th.health > 0).length
    for th in @unitsInGame when th.health > 0
      th.aliveTime = @world.age
    if not aliveRed or not aliveBlue
      @roundStarted = false


    if not aliveRed and not aliveBlue
      deadUnits = (th for th in @world.thangs when th.exists and th.aliveTime)
      lastUnits = []
      maxTime = 0
      for unit in deadUnits
        if unit.aliveTime > maxTime
          lastUnits = [unit]
          maxTime = unit.aliveTime
        else if unit.aliveTime is maxTime
          lastUnits.push(unit)
      lucky = @world.rand.choice(lastUnits)
      lucky.health = 1
      lucky.dead = false
      lucky.keepTrackedProperty("health")
      lucky.setAction("idle")
      if lucky.color is "red"
        aliveRed += 1
      else
        aliveBlue += 1

    @hero.health = aliveRed
    @hero.keepTrackedProperty("health")
    @hero2.health = aliveBlue
    @hero2.keepTrackedProperty("health")


    if not aliveRed
      @ref.say("ROUND BLUE WIN!")
      @blueWin += 1
    else if not aliveBlue
      @ref.say("ROUND RED WIN!")
      @redWin += 1
    if not aliveRed or not aliveBlue
      @roundStarted = false
      @round += 1
      @setTimeout(@clearField.bind(@), 3)
    # if @round > @N_ROUNDS
    #   # TIE BREAKING
    #   @world.endWorld(3, 3)
    if @redWin >= @ROUNDS_TO_WIN
      @ref.setExists(true)
      @world.setGoalState("red-win", "success")
      @setTimeout((() => @ref.say("GAME WIN RED! R:#{@redWin}-B:#{@blueWin}")), 1)
    if @blueWin >= @ROUNDS_TO_WIN
      @ref.setExists(true)
      @world.setGoalState("blue-win", "success")
      @setTimeout((() => @ref.say("GAME WIN BLUE! R:#{@redWin}-B:#{@blueWin}")), 1)
    if not @roundStarted
      for th in @clouds
        th.setExists(false)
      @clouds = []
      @poisonFog = false

  randomChooseHandler: (state) ->
    units = Object.keys(@UNIT_PARAMETERS)
    return @world.rand.choice(units)

  fixedPlaceHandler: (state) ->
    return 0

  randomPlaceHandler: (state) ->
    return @world.rand.rand2(0, 6)

  # USER
  gameOn: (hero, color, eventName, handler) ->
    # TODO ALLOWED eventName checking
    # TODO CHECK handler
    # console.log(hero.id, color, eventName, handler?)
    @gameHandlers[color] ?= {}
    @gameHandlers[color][eventName] = handler

  setActionFor: (hero, color, type, event, fn) ->
    # TODO event type checking
    @actionHelpers[color][type] ?= {}
    # @actionHelpers[color][type][event] ?= []
    @actionHelpers[color][type][event] = fn
    # for unit in @world.thangs when unit.type is type and unit.exists
    #   if not unit.on
    #     console.warn("#{type} need hasEvent")
    #     continue
    #   unit.off(event)
    #   unit.on(event, fn)

  # FAKE PLAYER 2
  hero2onChoose: (state) ->
    return @world.rand.choice(["archer", "warrior", "wizard"])

  hero2onPlace: (state) ->
    return @world.rand.rand2(0, 6)
}
