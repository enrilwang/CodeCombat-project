{
  UNIT_PARAMETERS: { #Dictionary storing attributes for all units - Includes friendly and enemy units
    #units information below
    warrior: { 
      health: 40,
      damage: 8,
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 12,
      cost: 25
    },

    knight: {
      health: 70,
      damage: 10,
      attackCooldown: 1,
      attackRange: 5,
      speed: 8,
      cost: 15
    },

    thief: {
      health: 20,
      damage: 10,
      attackCooldown: 0.5,
      attackRange: 4,
      speed: 16,
      cost: 30
    },
    wizard: {
      health: 10,
      damage: 20,
      attackCooldown: 2,
      attackRange: 30,
      speed: 10,
      cost: 20
    },
    archer: {
      health: 20,
      damage: 10,
      attackCooldown: 0.5,
      attackRange: 20,
      speed: 14,
      cost: 20
    },
    thrower: {
      health: 25,
      damage: 7,
      attackCooldown: 0.7,
      attackRange: 10,
      speed: 15,
      cost: 25
    },
    buffer: {
      health: 10,
      damage: 30,
      attackCooldown: 0.5,
      attackRange: 20,
      speed: 8,
      cost: 30
    },
    warlock: {
      health: 10,
      damage: 50,
      attackCooldown: 2,
      attackRange: 20,
      speed: 8,
      cost: 40
    },
    peasant: {
      health: 10,
      damage: 1,
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 10,
      cost: 0
    },
    #below is the enemies information
    soldier:{
      health: 20,
      damage: 20,
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 10,
      cost:10
    },
    
    bigOgre:{
      health: 100,
      damage: 50, 
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 5
      cost: 100
    },
    
    KR:{
      health: 50,
      damage: 40, 
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 7
      
    },
    Upfish:{
      health: 50,
      damage: 40, 
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 7
      cost:7
      
    },
    Zagurk:{
      health: 500,
      damage: 100, 
      attackCooldown: 0.5,
      attackRange: 5,
      speed: 4
      cost:6
    },
  
    
    Holkam:{
      health: 200,
      damage: 120, 
      attackCooldown: 0.5,
      attackRange: 6,
      speed: 4
      cost:5
    },
    Bortrok:{
      health: 400,
      damage: 130, 
      attackCooldown: 0.5,
      attackRange: 4,
      speed: 4
      cost:6
    
    }
  }

  WAVE_INFO: {      #Dictionary storing information for each wave of AI units being spawned
    #below is the wave information
    wave_0: {
      name: "wave_0",
      time: 5, #Time at which it is spawned
      already_spawned: 0, #Wether it has spawned or not
      unit_types: ["soldier"],
      no_total_units: 4
    },
    
    wave_1: {
      name: "wave_1",
      time: 8, 
      already_spawned: 0, 
      unit_types: ["soldier"],
      no_total_units: 4
    },
    
    wave_2: {
      name: "wave_2",
      time: 10, 
      already_spawned: 0, 
      unit_types: ["bigOgre"],
      no_total_units: 2
    },
    
    wave_3: {
      name: "wave_3",
      time: 15, 
      already_spawned: 0, 
      unit_types: ["Upfish"],
      no_total_units: 1
    },
    
    wave_4: {
      name: "wave_4",
      time: 18, 
      already_spawned: 0, 
      unit_types: ["Zagurk"],
      no_total_units: 0
    },
    
    wave_5: {
      name: "wave_5",
      time: 21, 
      already_spawned: 0, 
      unit_types: ["Holkam"],
      no_total_units: 1
    },
    
    wave_6: {
      name: "wave_6",
      time: 25, 
      already_spawned: 0, 
      unit_types: ["Bortrok"],
      no_total_units: 0
    }
    
    
  }
  
  ORIGINAL_LAST_WAVE: 27
  END_TIME: 85 #The end time of the game
  LAST_WAVE_TIME: 27 #When is the last wave spawned in 
  WAVES: 7      #No. waves assigned - Must be changed if adding waves 
  ROUNDS_TO_WIN: 1    #No. times a player must win 
  ALLOWED_UNIT_EVENT_NAMES: ["spawn"]
  MAX_UNITS: 9 #the max unit AI team can have
  
  IN_RECT_SHIFT: [      #Accessing different corners/positions within the spawning squares
    Vector(3, 0), Vector(3, 3), Vector(3, -3),
    Vector(0, 0), Vector(0, 3), Vector(0, -3),
    Vector(-3, 0), Vector(-3, 3), Vector(-3, -3)
    ]
  
  setupGlobal: (hero, color) ->     #EsperEngine (JS Compiler) setup
    game = {
      on: @gameOn.bind(@, hero, color)
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

  setupGame: -> #Further compiler setup + some changes to gameplay
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
    # @clouds = []
    
    #make the hero cannot be attcked
    @hero.isAttackable = false
    @hero2.isAttackable = false

    
  
  setSpawnPositions: -> #Establish array in which we store the spawn sqaures for each player 
    
    @spawnPositions = []
    @spawnPositionCounters = {}
    @redSpawnPositions = []
    @blueSpawnPositions = []
    for i in [0..5]   #Gets the squares by ID 
      th = @world.getThangByID("pos-red-" + i)
      th.index = i
      @redSpawnPositions.push(th)
    for i in [0..5]
      th = @world.getThangByID("pos-blue-" + i)
      th.index = i
      @blueSpawnPositions.push(th)
    @spawnPositions = @redSpawnPositions.concat(@blueSpawnPositions)  #Contains all spawn squares
    
  
  setUpLevel: ->  #Initialiser of the level 
    
    @setupGame() 
    @setSpawnPositions()
    @unitCounter = {}
    @leftNeutral = []
    @rightNeutral = []
   
    @redHeart = @world.getThangByID("Heart Seed")   #The players' bases
    @blueHeart = @world.getThangByID("Heart Seed 1")
    @ref = @world.getThangByID("ref")
    # @potion = @world.getThangByID("Health Medium Potion")
    # @potion2 = @world.getThangByID("Health Medium Potion 1")
    
    @round = 1
    @redWin = 0
    @blueWin = 0
    @uiTrackedProperties = ["redWin"] 
    @addTrackedProperties ["uiTrackedProperties", "array"]
    @keepTrackedProperty "uiTrackedProperties"
    @ref.say("RED: #{@redWin} - BLUE: #{@blueWin}") 
    
 
    
  onFirstFrame: -> #run at the starter
    for th in @world.thangs when th.health? and not th.isProgrammable   
      th.setExists(false) 
    @prepareRound()
    
    
    @hear = (speaker,message,data) -> #Overriding the built-in hear function
      message_arr = message.split(",")
      desired_unit_type = message_arr[0]
      desired_pos = message_arr[1]
      desired_unit_params = @UNIT_PARAMETERS[desired_unit_type]
      
      if speaker is @hero   #Checking which hero said the message (i.e. red or blue) 
        if @world.getSystem('Inventory').teamGold.humans.gold < desired_unit_params.cost    #Checking if player has sufficent funds available
        else
          new_unit = @createNewTower(desired_unit_type, "red", desired_pos)
      if speaker is @hero2
        if @world.getSystem('Inventory').teamGold.ogres.gold < desired_unit_params.cost
        else
          new_unit = @createNewTower(desired_unit_type, "blue", desired_pos)
          
  
  checkWinner: () -> #Checks if a player has died at any given point in the game 
    return if not @roundStarted
    aliveRed = @redHeart.health > 0
    aliveBlue = @blueHeart.health > 0
        
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

    #Full game determination - Keep
    if @redWin >= @ROUNDS_TO_WIN
      @ref.setExists(true)
      @world.setGoalState("red-win", "success")
      @setTimeout((() => @ref.say("GAME WIN RED! R:#{@redWin}-B:#{@blueWin}")), 1)
    if @blueWin >= @ROUNDS_TO_WIN
      @ref.setExists(true)
      @world.setGoalState("blue-win", "success")
      @setTimeout((() => @ref.say("GAME WIN BLUE! R:#{@redWin}-B:#{@blueWin}")), 1)
      
      
    #check draw, 85seconds after, which team has more golds, who will win
    if @world.age >= @END_TIME #Time to check if all units are dead
     
      if @world.getSystem('Inventory').teamGold.humans.gold > @world.getSystem('Inventory').teamGold.ogres.gold
        @ref.setExists(true)
        @world.setGoalState("red-win", "success")
        # @setTimeout(() => @ref.say("GAME WIN BLUE!}"))
      else if @world.getSystem('Inventory').teamGold.humans.gold <= @world.getSystem('Inventory').teamGold.ogres.gold
        @ref.setExists(true)
        @world.setGoalState("blue-win", "success")
        # @setTimeout(() => @ref.say("GAME WIN BLUE!"))
 
        
        
        
  chooseAction: ->  #Triggers every frame
  
    if @roundStarted
      @AIMobSpawn()   #Iterates through mob spawn routine
      @checkWinner()  #Checks if there exists a winner i.e. a player has died 
      @checkGoldPlus()  #Gives gold for death of units
      @resetWaves() #Checks if the wave pattern needs to be refreshed
       #spawn potions for hero to use
      
  
  
  getPosXY: (color, n) -> #Returns the (x,y) coordinate of the relevant team's n spawn square
    rectID = "pos-#{color}-#{n}"
    rect = @world.getThangByID(rectID)
    i = @spawnPositionCounters[rectID]
    @spawnPositionCounters[rectID] += 1
    shift = @IN_RECT_SHIFT[i % @IN_RECT_SHIFT.length].copy()
    if color is "blue"
      shift.x *= -1
    return rect.pos.copy().add(shift)

  getPosNeutralXY: (n) ->   #Similar to the above function but operates for the neutral enemy spawn squares (2 of them exist) 
    rectID = "pos-cpu-#{n}"
    rect = @world.getThangByID(rectID)
    
    return rect.pos
    
  
  resetWaves: () ->
    
     #If all waves spawned
        #Set "already_spawned" attribute for each wave to 0
        #Increase the spawn time (Which is - when we want) by (LAST_WAVE_TIME) 
        #Increase the number of units 
        
      ##We set the pattern of unit types that occurs
      ##Number of units increases with time 
      
    if @world.age > @LAST_WAVE_TIME #
      for i in [0..@WAVES-1]
        wave_string = "wave_"+i
        console.log "WAAAARIO gets",wave_string,"World age = ",@world.age, 
        wave = @WAVE_INFO[wave_string]
        @WAVE_INFO[wave_string].no_total_units += 1
        @WAVE_INFO[wave_string].time += @ORIGINAL_LAST_WAVE
        @WAVE_INFO[wave_string].already_spawned = 0 
        #console.log "Post adjustment! Wave time",@WAVE_INFO[wave_string].time, "No. units", @WAVE_INFO[wave_string].no_total_units, "Already?: " , @WAVE_INFO[wave_string].already_spawned
      @LAST_WAVE_TIME += @ORIGINAL_LAST_WAVE
      
      
  
  AIMobSpawn: () ->   #Routine handling the constant spawning of enemies
  
    for i in [0..@WAVES-1]      #For each wave 
      wave_string = "wave_"+i
      wave = @WAVE_INFO[wave_string]

      if (@world.age)>wave.time and wave.already_spawned == 0  #Check if time to spawn the wave
        for j in [0..wave.no_total_units]
          unit = @createAIUnit(wave.unit_types[0],1) #Change to iterate through all units dependant TO DO
          @leftNeutral.push unit    #Stored for later access of enemy units
          unit1 = @createAIUnit(wave.unit_types[0],2) 
          @rightNeutral.push unit1
        wave.already_spawned = 1
        
      
      
        
            
   checkGoldPlus: () ->   #Provides the player with gold each time the unit dies 
    for unit in @leftNeutral
      if unit.health <= 0
        @world.getSystem('Inventory').teamGold.humans.gold += 10   #a died unit give 10 golds
        @leftNeutral = (x for x in @leftNeutral when x != unit)

    for unit in @rightNeutral
      if unit.health <= 0
        @world.getSystem('Inventory').teamGold.ogres.gold += 10
        @rightNeutral = (x for x in @rightNeutral when x != unit)          


  setupUnit: (unit, unitType, color) ->   # Sets up towers
    #give the units property
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
    unit.isAttackable = false #Important - Stops towers being attacked
    
    # reduce the team gold
    if color is "red"
      @world.getSystem('Inventory').teamGold.humans.gold -= params.cost   
    if color is "blue"
      @world.getSystem('Inventory').teamGold.ogres.gold -= params.cost
    
    if unit.actions.attack?.cooldown
      unit.actions.attack.cooldown = params.attackCooldown
      
    unit.commander = @
    unit.type = unitType 
    unit.color = color


  setupAIUnit: (unit, unitType) ->    #Simiar to above but has no colour 
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
    
  createNewTower: (unitType,color,posNumber) -> #Creates friendly unit 
    unit = @createUnit(unitType,color,posNumber)

    unit.startsPeaceful = false
    unit.commander = null
      

    fn = @actionHelpers[unit.color]?[unit.type]?["spawn"]
    if fn and _.isFunction(fn)
      if unit.color is "red"
        unit.commander = @hero
      if unit.color is "blue"
        unit.commander = @hero2
      unit.didTriggerSpawnEvent = true
      unit.on("spawn", fn)

    @unitsInGame.push(unit)   #Access for later
    
  
  createUnit: (unitType, color, posNumber) ->  # Create the new unti
    if not @UNIT_PARAMETERS[unitType]
      unitType = "peasant"
    
    pos = @getPosXY(color, posNumber)
    fullType = "#{unitType}-#{color}"
   
    unit = @instabuild("#{unitType}-#{color}", pos.x, pos.y, "#{unitType}-#{color}")    #Actual creation of the unit
    @setupUnit(unit, unitType, color)   #Above - Sets characteristics and stats for the units as set in dictionary 

  
    return unit

  createAIUnit: (unitType, posNumber) ->    #Similar to the above but for AI
    if not @UNIT_PARAMETERS[unitType]
      unitType = "peasant"
    pos = @getPosNeutralXY(posNumber) #Will be 1 or 2 i.e. left or right


    unit = @instabuild("cpu-#{unitType}", pos.x, pos.y)
    @setupAIUnit(unit, unitType)
    unit.aiSide = posNumber
    if posNumber == 1 #Attack command issued on spawning
      unit.attack(@redHeart)
    else
      unit.attack(@blueHeart)
    return unit
  #
  # createPotion: (pos) ->
  #   @build "health-potion"
  #   Potion = @performBuild()
  #   Potion.team = 'neutral'
  #   Potion.pos.x = pos.x
  #   Potion.pos.y = pos.y
  #   #Potion.collectableProperties[0][0][1] = 200
  #   return Potion
  
  # spawnPotion: ()->
  #   spawnTime = Math.round(@world.age * 10) / 10
  #   if spawnTime % 10.0 == 0 # spawn potion every 30 sec interval
  #     if @potionRight.exists == false
  #       @potionRight = @createPotion({"x": 66, "y": 15})
  #     if @potionLeft.exists == false
  #       @potionLeft = @createPotion({"x": 15, "y": 15})
    
  prepareRound: ->    #Basic attributes/reset at the end of each around

    #Setup the units properly in preparation of the level reset
    @world.getSystem('Inventory').teamGold.ogres.gold = 200 #for ogres team the original gold
    @world.getSystem('Inventory').teamGold.humans.gold = 200   #for humans team the original gold

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
    # @potionRight = @createPotion({"x": 66, "y": 15})
    # @potionLeft = @createPotion({"x": 15, "y": 15})
    
    for th in @spawnPositions
      th.setExists(true)
      th.say?(th.index)
      th.alpha = 0.5
      th.keepTrackedProperty("alpha")
      @spawnPositionCounters[th.id] = 0
      
    @unitsInGame = []
    @gameStates = {
      red: {
        availableUnits: ["knight", "warrior", "thief", "archer", "wizard", "thrower", "buffer", "warlock", "peasant"], #Spawnable units
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
    @ref.say("HEART GUARDIAN!!!")
    
    @setTimeout((() => @ref.say(3)), 1)
    @setTimeout((() => @ref.say(2)), 2)
    @setTimeout((() => @ref.say(1)), 3)
    @setTimeout((() => @ref.say("RED VS BLUE! GO!!")), 4)
    @setTimeout((() => @ref.say("GO! GO! GO!")), 5)
    @setTimeout(@clearRects.bind(@), 1)
    @setTimeout(@startRound.bind(@), 5)

    
  
  clearField: ->    #Remove everything from the field
    @unitCounter = {}
    for u in @unitsInGame
      u.setExists(false)
    @unitsInGame = []
    @prepareRound()
      
  processTeam: (color, opColor, chooseHandler, placeHandler) ->     #Somewhat unclear to us -> Sets up player programming/source code
    #automatically spawn unit with AI
    try
      unitType = chooseHandler(_.cloneDeep(@gameStates[color]))
    catch error
      (if color is 'red' then @hero else @hero2).handleProgrammingError error, 'plan'
    # TODO UNIT CHECKING
    if not unitType or not @UNIT_PARAMETERS[unitType]
      unitType = "peasant"
    if unitType != "peasant"
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

    for unit in @unitsInGame when unit    #Sets commander/aggro for each unit at the start of the round
      unit.startsPeaceful = false
      unit.commander = null
      
      fn = @actionHelpers[unit.color]?[unit.type]?["spawn"]
      if fn and _.isFunction(fn)
        if unit.color is "red"
          unit.commander = @hero
        if unit.color is "blue"
          unit.commander = @hero2
        unit.didTriggerSpawnEvent = true
        unit.on("spawn", fn)

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
   
    
  # FAKE PLAYER 2
  hero2onChoose: (state) ->
    return @world.rand.choice(["archer", "warrior", "wizard"])
  
  hero2onPlace: (state) ->
    return @world.rand.rand2(0, 6)
}