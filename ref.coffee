  {
    UNIT_PARAMETERS: {
      warrior: {
        health: 40,
        damage: 8,
        attackCooldown: 1.5,
        attackRange: 5,
        speed: 12,
        cost: 5
      },

      knight: {
        health: 70,
        damage: 4,
        attackCooldown: 1,
        attackRange: 5,
        speed: 8,
        cost: 5
      },

      thief: {
        health: 20,
        damage: 10,
        attackCooldown: 0.5,
        attackRange: 4,
        speed: 16,
        cost: 5
      },
      wizard: {
        health: 10,
        damage: 20,
        attackCooldown: 4,
        attackRange: 30,
        speed: 10,
        cost: 5
      },
      archer: {
        health: 20,
        damage: 6,
        attackCooldown: 0.5,
        attackRange: 20,
        speed: 14,
        cost: 10
      },
      thrower: {
        health: 25,
        damage: 7,
        attackCooldown: 0.7,
        attackRange: 10,
        speed: 15,
        cost: 5
      },
      buffer: {
        health: 10,
        damage: 2,
        attackCooldown: 0.5,
        attackRange: 20,
        speed: 8,
        cost: 5
      },
      warlock: {
        health: 10,
        damage: 2,
        attackCooldown: 0.5,
        attackRange: 20,
        speed: 8,
        cost: 5
      },
      peasant: {
        health: 10,
        damage: 1,
        attackCooldown: 0.5,
        attackRange: 5,
        speed: 10,
        cost: 11
      },

      soldier:{
        health: 20,
        damage: 20,
        attackCooldown: 0.5,
        attackRange: 5,
        speed: 10
      },
      
      bigOgre:{
        health: 100,
        damage: 50, 
        attackCooldown: 0.5,
        attackRange: 5,
        speed: 5
      },
      
      KR:{
        health: 40,
        damage: 40, 
        attackCooldown: 0.5,
        attackRange: 5,
        speed: 7
        
      }
      Zagurk:{
        health: 50,
        damage: 40, 
        attackCooldown: 0.5,
        attackRange: 5,
        speed: 2
        
        
      }
    }

    WAVE_INFO: {

      wave_0: {
        name: "wave_0",
        time: 5, #Time at which it is spawned
        already_spawned: 0, #Wether it has spawned or not
        unit_types: ["soldier"],
        no_total_units: 6
      },
      
      wave_1: {
        name: "wave_1",
        time: 7, #Time at which it is spawned
        already_spawned: 0, #Wether it has spawned or not
        unit_types: ["soldier"],
        no_total_units: 5
      },
      
      wave_2: {
        name: "wave_2",
        time: 7, #Time at which it is spawned
        already_spawned: 0, #Wether it has spawned or not
        unit_types: ["bigOgre"],
        no_total_units: 2
      },
      
      wave_3: {
        name: "wave_3",
        time: 10, #Time at which it is spawned
        already_spawned: 0, #Wether it has spawned or not
        unit_types: ["KR"],
        no_total_units: 2
      },
      
      wave_4: {
        name: "wave_4",
        time: 13, #Time at which it is spawned
        already_spawned: 0, #Wether it has spawned or not
        unit_types: ["Zagurk"],
        no_total_units: 1
      }
      
      
    }

    WAVES: 5
    ROUNDS_TO_WIN: 1
    MAX_ROUND_TIME: 19
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
      enemyCount = 0;
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
      # @hero.isAttackable = false
      # @hero.health = 2
      # @hero.maxHealth = 2
      # @hero2.isAttackable = false
      # @hero2.health = 2
      # @hero2.maxHealth = 2
      
    
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
      
     
      @redHeart = @world.getThangByID("Heart Seed")
      @blueHeart = @world.getThangByID("Heart Seed 1")
      
      
      @ref = @world.getThangByID("ref")
      # @ref.say("REF")

      
      


      @round = 1
      @redWin = 0
      @blueWin = 0
      @uiTrackedProperties = ["redWin"]
      @addTrackedProperties ["uiTrackedProperties", "array"]
      @keepTrackedProperty "uiTrackedProperties"
      @ref.say("ROUND #{@round}. RED: #{@redWin} - BLUE: #{@blueWin}")
      
    getPosNeutralXY: (n) ->
      rectID = "pos-cpu-#{n}"
      rect = @world.getThangByID(rectID)
      
      return rect.pos
      
    onFirstFrame: ->
      for th in @world.thangs when th.health? and not th.isProgrammable
        th.setExists(false)
      @prepareRound()
      console.log "We get for the left: ", @getPosNeutralXY(1).x , @getPosNeutralXY(1).y
      
      @hear = (speaker,message,data) ->
        #if speaker is @hero2
            #console.log "We found hero2's voice message"
        #if speaker is @hero
           # console.log "We found hero1's voice messagge"
        
        
        message_arr = message.split(",")
        desired_unit_type = message_arr[0]
        desired_pos = message_arr[1]
        console.log "Desired unit is: ", desired_unit_type
        
        desired_unit_params = @UNIT_PARAMETERS[desired_unit_type]
        
        if speaker is @hero
          if @world.getSystem('Inventory').teamGold.humans.gold < desired_unit_params.cost
            console.log "Don't have sufficent funds to purchase unit"
          else
            console.log "We can make the unit. Doing now" 
            new_unit = @createNewTower(desired_unit_type, "red", desired_pos)
            console.log "NEEWWWW UNNNNIIIIIIT HERE"
        
        if speaker is @hero2
          if @world.getSystem('Inventory').teamGold.ogres.gold < desired_unit_params.cost
            console.log "Don't have sufficent funds to purchase unit"
          else
            console.log "We can make the unit. Doing now" 
            new_unit = @createNewTower(desired_unit_type, "blue", desired_pos)
            console.log "NEEWWWW UNNNNIIIIIIT HERE"
          
            
        
      
    chooseAction: ->
      if @roundStarted
        @AIMobSpawn()
        @checkWinner()
        @checkFog()
    
    
    getPosXY: (color, n) ->
      rectID = "pos-#{color}-#{n}"
      rect = @world.getThangByID(rectID)
      i = @spawnPositionCounters[rectID]
      @spawnPositionCounters[rectID] += 1
      shift = @IN_RECT_SHIFT[i % @IN_RECT_SHIFT.length].copy()
      if color is "blue"
        shift.x *= -1
      return rect.pos.copy().add(shift)

    
    AIMobSpawn: () ->
      for i in [0..@WAVES-1]
        wave_string = "wave_"+i
        console.log "Wario gets",wave_string
        wave = @WAVE_INFO[wave_string]
        console.log "WAAAARIO gets",wave.name,"World age = ",@world.age, "Wave.time = ", wave.time
        
        if (@world.age)>wave.time and wave.already_spawned == 0
      #    console.log("Creating our wave")
          for j in [0..wave.no_total_units]
            @createAIUnit(wave.unit_types[0],1) #Change to iterate through all units dependant TO DO
            @createAIUnit(wave.unit_types[0],2) 
          wave.already_spawned = 1


    setupUnit: (unit, unitType, color) ->
      params = @UNIT_PARAMETERS[unitType]
      unit.maxHealth = params.health
      unit.health = params.health
      unit.keepTrackedProperty("maxHealth")
      unit.keepTrackedProperty("health")
      unit.attackDamage = params.damage
      unit.keepTrackedProperty("attackDamage")
      unit.attackRange = params.attackRange
      console.log "Unit attack range: ", unit.attackRange
      unit.keepTrackedProperty("attackRange")
      unit.maxSpeed = params.speed
      unit.keepTrackedProperty("maxSpeed")
      unit.isAttackable = false #Important - Stops towers being attacked

      if color is "red"
        @world.getSystem('Inventory').teamGold.humans.gold -= params.cost
      if color is "blue"
        @world.getSystem('Inventory').teamGold.ogres.gold -= params.cost
      
      if unit.actions.attack?.cooldown
        unit.actions.attack.cooldown = params.attackCooldown
      unit.commander = @
      unit.type = unitType 
      unit.color = color


    setupAIUnit: (unit, unitType) ->
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

      unit.type = unitType 
      
    createNewTower: (unitType,color,posNumber) ->
      unit = @createUnit(unitType,color,posNumber)
      @unitsInGame.push(unit)
    
    createUnit: (unitType, color, posNumber) ->
      if not @UNIT_PARAMETERS[unitType]
        unitType = "peasant"
      #TODO checking posN
      # nColor = if color is "red" then 0 else 1 # TO CHANGE ????
      pos = @getPosXY(color, posNumber)
      fullType = "#{unitType}-#{color}"
      #@unitCounter[fullType] ?= 0
      #@buildables[fullType].ids = ["#{fullType}-#{@unitCounter[fullType]}"]
      #@unitCounter[fullType]++
      unit = @instabuild("#{unitType}-#{color}", pos.x, pos.y, "#{unitType}-#{color}")
      @setupUnit(unit, unitType, color)

      console.log "Unit is created with dmg: ",unit.attackDamage
      return unit

    createAIUnit: (unitType, posNumber) ->
      if not @UNIT_PARAMETERS[unitType]
        unitType = "peasant"
      pos = @getPosNeutralXY(posNumber) #Will be 1 or 2 i.e. left or right

      #~~~~Unsure whats happening here~~~~~~
      #fullType = "#{unitType}-#{color}"
      #@unitCounter[fullType] ?= 0
      #@buildables[fullType].ids = ["#{fullType}-#{@unitCounter[fullType]}"]
      #@unitCounter[fullType]++


      unit = @instabuild("cpu-#{unitType}", pos.x, pos.y)
      @setupAIUnit(unit, unitType)
      if posNumber == 1
        unit.attack(@redHeart)
      else
        unit.attack(@blueHeart)
      return unit

    prepareRound: ->

      #Setup the units properly in preparation of the level reset
      @world.getSystem('Inventory').teamGold.ogres.gold = 200
      @world.getSystem('Inventory').teamGold.humans.gold = 200

      @redHeart.health = @redHeart.maxHealth
      @blueHeart.health = @blueHeart.maxHealth
    
  
      @hero.health = @redHeart.maxHealth
      @hero.maxHealth = @redHeart.maxHealth
      @hero.keepTrackedProperty("health")
      @hero.keepTrackedProperty("maxHealth")
      @hero2.health = @blueHeart.maxHealth
      @hero2.maxHealth = @blueHeart.maxHealth
      @hero2.keepTrackedProperty("health")
      @hero2.keepTrackedProperty("maxHealth")
      @redHeart.setExists(true)
      @blueHeart.setExists(true)
   
      
      



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
     

      for unit in @world.thangs
        if unit.ai and unit.colour == "red"
          unit.attack(@blueHeart)
        if unit.ai and unit.colour == "blue"
          unit.attack(@redHeart)


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
      #else if @world.age > @roundStartTime + @MAX_ROUND_TIME - HAVE REMOVED FOR NOW, WE CAN BRING BACK
      #  @startFog()
      
        
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
    
    checkWinner: () -> #Editing to have win condition based on Heart health
      return if not @roundStarted
      aliveRed = @redHeart.health >= 0
      aliveBlue = @blueHeart.health >= 0
      
      
      
          
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
      
      @hero.health = @redHeart.health
      @hero.keepTrackedProperty("health")
      @hero2.health = @blueHeart.health
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




      #Full game determination - Keep
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