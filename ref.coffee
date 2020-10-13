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
    }
  }
  ROUNDS_TO_WIN: 1
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
    # @hero.isAttackable = false
    # @hero.health = 2
    # @hero.maxHealth = 2
    # @hero2.isAttackable = false
    # @hero2.health = 2
    # @hero2.maxHealth = 2
<<<<<<< HEAD


=======
    
  
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
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
<<<<<<< HEAD


    @setupGame()
    @setSpawnPositions()
    @unitCounter = {}

=======
    
    
    @setupGame()
    @setSpawnPositions()
    @unitCounter = {}
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
    @skele1 = @world.getThangByID("Bonesworth")
    @skele2 = @world.getThangByID("Skulldugger")
    @redHeart = @world.getThangByID("Heart Seed")
    @blueHeart = @world.getThangByID("Heart Seed 1")
    @generator1=@world.getThangByID("Generator")
    @generator2=@world.getThangByID("Generator 1")
<<<<<<< HEAD
  	@hero = @world.getThangByID("Knight")
  	#@hero2 = @world.getThangByID("Knight")
=======

>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
    @generator1.spawnType="skeleton"
    @generator2.spawnType="skeleton"
   # @generator1.isAttackable = false
    #@generator2.isAttackable = false

    @generator1.spawnDelay = 1
    @generator2.spawnDelay = 1
<<<<<<< HEAD


    @ref = @world.getThangByID("ref")
    # @ref.say("REF")



=======
    
    
    @ref = @world.getThangByID("ref")
    # @ref.say("REF")

    
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e


    @round = 1
    @redWin = 0
    @blueWin = 0
    @uiTrackedProperties = ["redWin"]
    @addTrackedProperties ["uiTrackedProperties", "array"]
    @keepTrackedProperty "uiTrackedProperties"
    @ref.say("ROUND #{@round}. RED: #{@redWin} - BLUE: #{@blueWin}")
<<<<<<< HEAD
#######From Wakka Arena
  unitArray:
    "soldier":
      name:"soldier-m"
      cost:20
      count:1
      team:"humans"
      key:"soldier"
    "archer":
      name:"archer-m"
      cost:25
      count:1
      team:"humans"
      key:"archer"
    "thrower":
      name:"thrower"
      cost:9
      count:2
      team:"ogres"
      key:"thrower"
    "scout":
      name:"scout-m"
      cost:18
      count:1
      team:"ogres"
      key:"scout"

  roomArray:
    "upperLeft":
      pos: x:22, y:66
      team:"ogres"
      contains:[
        "thrower"
        "thrower"
        "thrower"
        "thrower"
      ]
      doors:[
        "a"
        "b"
      ]
    "upperMiddle":
      pos: x:46, y:66
      team:"ogres"
      contains:[
        "brawler"
      ]
      doors:[
        "c"
      ]
    "upperRight":
      pos: x:82, y:66
      team:"ogres"
      contains:[
        "scout-m"
        "scout-m"
        "scout-m"
      ]
      doors:[
        "d"
      ]
    "lowerLeft":
      pos: x:22, y:18
      team:"humans"
      contains:[
        "soldier-m"
        "soldier-m"
        "soldier-m"
        "soldier-m"
      ]
      doors:[
        "g"
      ]
    "lowerMiddle":
      pos: x:58, y:18
      team:"humans"
      contains:[
        "paladin"
      ]
      doors:[
        "h"
      ]
    "lowerRight":
      pos: x:82, y:18
      team:"humans"
      contains:[
        "archer-m"
        "archer-m"
      ]
      doors:[
        "i"
        "j"
      ]

  minionChooseAction: ->
    isTrapped = true
    if @knownDoors?
      for door in @knownDoors
        if door.health <= 0
          isTrapped = false
    else
      isTrapped = false
    if not isTrapped
      enemies = @findEnemies()
      enemies = _.difference enemies, @findByType("door")
      enemies = _.union enemies, @findByType(@enemyHero.type);
      if @enemyHero.team is 'humans'
        enemies = _.difference enemies, @findByType('witch-hero');
      else if @enemyHero.team is 'ogres'
        enemies = _.difference enemies, @findByType('captain');
      if(enemies.length > 0)
        @attack @findNearest(enemies);
      else
        if @action isnt 'move'
          curLoc = x:Math.min(Math.max(Math.round(14 * (@pos.x - @map.bLeft.x) / @map.size.x), 0), 14), y: Math.min(Math.max(Math.round(12 * (@pos.y - @map.bLeft.y) / @map.size.y), 0), 12)
          cI = curLoc.x + curLoc.y * 15

          enemyDir = x:@enemyHero.pos.x - @pos.x, y:@enemyHero.pos.y - @pos.y
          if enemyDir.x != 0
            enemyDir.x /= Math.abs(enemyDir.x)
          if enemyDir.y != 0
            enemyDir.y /= Math.abs(enemyDir.y)

          validSpots = []
          if curLoc.x - 1 >= 0 and (@map.array[cI - 1] == 0 or (@map.array[cI] == 3 and (@map.array[cI-1] == 2 or ((@knownDoors? and _.findIndex(@knownDoors, (elem) ->
            return elem.id == @map.array[cI-1] and elem.health <= 0
          , @) isnt -1) or (!@knownDoors?)))) or ((@map.array[cI-1] == 8 and @cDoor1.health <= 0) or (@map.array[cI-1] == 9 and @cDoor2.health <= 0))) and @lastDirection?.x isnt 1
            validSpots.push {index: cI - 1, dir: {x:-1, y:0}, pos: {x:@map.bLeft.x + 6 * (curLoc.x - 1), y:@map.bLeft.y + 6 * curLoc.y}}
          if curLoc.x + 1 < 15 and (@map.array[cI + 1] == 0 or (@map.array[cI] == 3 and (@map.array[cI+1] == 2 or ((@knownDoors? and _.findIndex(@knownDoors, (elem) ->
            return elem.id == @map.array[cI+1] and elem.health <= 0
          , @) isnt -1) or (!@knownDoors?)))) or ((@map.array[cI+1] == 8 and @cDoor1.health <= 0) or (@map.array[cI+1] == 9 and @cDoor2.health <= 0))) and @lastDirection?.x isnt -1
            validSpots.push {index: cI + 1, dir: {x:1, y:0}, pos: {x:@map.bLeft.x + 6 * (curLoc.x + 1), y:@map.bLeft.y + 6 * curLoc.y}}
          if curLoc.y - 1 >= 0 and (@map.array[cI - 15] == 0 or (@map.array[cI] == 3 and @map.array[cI-15] == 2) or ((@map.array[cI-15] == 8 and @cDoor1.health <= 0) or (@map.array[cI-15] == 9 and @cDoor2.health <= 0))) and @lastDirection?.y isnt 1
            validSpots.push {index: cI - 15, dir: {x:0, y:-1}, pos: {x:@map.bLeft.x + 6 * curLoc.x, y:@map.bLeft.y + 6 * (curLoc.y - 1)}}
          if curLoc.y + 1 < 13 and (@map.array[cI + 15] == 0 or (@map.array[cI] == 3 and @map.array[cI+15] == 2) or ((@map.array[cI+15] == 8 and @cDoor1.health <= 0) or (@map.array[cI+15] == 9 and @cDoor2.health <= 0))) and @lastDirection?.y isnt -1
            validSpots.push {index: cI + 15, dir: {x:0, y:1}, pos: {x:@map.bLeft.x + 6 * curLoc.x, y:@map.bLeft.y + 6 * (curLoc.y + 1)}}

          primeCandidates = []
          for element in validSpots
            if element.dir.x == enemyDir.x
              primeCandidates.push element
            if element.dir.y == enemyDir.y
              primeCandidates.push element

          if primeCandidates.length > 0
            num = Math.floor(Math.random() * primeCandidates.length)
            @move primeCandidates[num].pos
            @lastDirection = primeCandidates[num].dir
          else if validSpots.length > 0
            num = Math.floor(Math.random() * validSpots.length)
            @move validSpots[num].pos
            @startedMoving = @world.age
            @lastDirection = validSpots[num].dir
          else
            @lastDirection = null

        if @action is 'move'
          if (@targetPos? and @distanceTo(@targetPos) <= 2.5) or not @targetPos?
            @setAction 'idle'
            @setTargetPos null

  createMob: (mob, loc, team) ->
    mob = @instabuild mob, loc.x - 2 + Math.random() * 4, loc.y - 2 + Math.random() * 4
    if team is "humans"
      mob.enemyHero = @hero2
    else if team is "ogres"
      mob.enemyHero = @hero
    mob.chooseAction = @minionChooseAction
    mob.map = @map
    mob.cDoor1 = @world.getThangByID "f"
    mob.cDoor2 = @world.getThangByID "e"
    @rebuildBody mob
    mob
######################################################
=======
    
    
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
  onFirstFrame: ->
  #################################Added from WAKKA Arena
  	@hasSpawnedSkeletons = false
    @init @hero
    @init @hero2
    #Placement code per room
    for roomName, room of @roomArray
      for mobName in room.contains
        mob = @createMob mobName, room.pos, room.team
        mob.knownDoors = []
        for doorName in room.doors
          mob.knownDoors.push @world.getThangByID doorName
    #Update hearing code.
    @hear = (speaker, message, data) ->
      #Check if speaker is either hero.
      if speaker is @hero or speaker is @hero2
        return if speaker.action isnt 'say'  # Automatic message, not one the player intentionally said
        return if message in ['Vroom!', @icontext.vroom]
        #Check to see if message is in the unit array, and that the unit is of the speaker's team
        if @unitArray[message]
          if @unitArray[message].team is speaker.team
            #Check if the user has enough
            if @unitArray[message].cost * @unitArray[message].count <= speaker.gold
              #For mass-spawn units, repeat for count.
              for [0...@unitArray[message].count]
                  #Remove the gold from the team's coffers
                  @inventorySystem.subtractGoldForTeam speaker.team, @unitArray[message].cost
                  mob = @createMob @unitArray[message].name, speaker.pos, speaker.team
            else
              speaker.sayMessage = @icontext.afford + " \""+message+"\"!"
          else
            #Speaker is on the wrong team and can't summon a rival unit!
            #Toss an error to the speaker.
            error =  @icontext.attemp + " `\"" + message + "\"`."
            hint = @icontext.team1 + " *" + speaker.team.substr(0, speaker.team.length - 1) + "* " + @icontext.team2 + " *" + @unitArray[message].team.substr(0, @unitArray[message].team.length - 1) + "*."
            aether = speaker.getAetherForMethod("plan")
            problem = aether.createUserCodeProblem type: 'runtime', error: {name: "TryingToSpawnEnemy", message: error, hint: hint, toString: -> message}
            speaker.addAetherProblemForMethod problem, "plan"
        else
          #Unit doesn't exist in the unit array!
          #Toss an error to the speaker.
          error = @icontext.unknown + " `\"" + message + "\"`."

          a = _.at(_.pluck(_.sortBy(@unitArray, (_element) ->
            return @stringScore(message,_element.key, 0.25)
          ,@),"key").reverse(),0)

          hint = @icontext.mean + ": `\"" + a + "\"`?"
          aether = speaker.getAetherForMethod("plan")
          problem = aether.createUserCodeProblem type: 'runtime', error: {name: "UnitDoesntExist", message: error, hint: hint, toString: -> message}
          speaker.addAetherProblemForMethod problem, "plan"
#########################################################################
    for th in @world.thangs when th.health? and not th.isProgrammable
      th.setExists(false)
    @prepareRound()
###########################################Added from WAKKA Arena
  init: (who) ->
    #who.actions.say.cooldown = 0.1
    @rebuildBody who, 2.5
    who.findsPaths = false
    @brakeOnSay who
    who.voiceRangeSquared = 9001 * 9001
    who.oldCollect = who.performCollect
    icontext = @icontext
    who.performCollect = (collectable) ->
  	if collectable.id is "Haste Potion"
  	  @effects = (e for e in @effects when e.name isnt 'haste')
  	  effects = [
  		{name: 'haste', duration: 9001, reverts: true, factor: 2, targetProperty: 'maxSpeed'}
  		{name: 'haste', duration: 9001, reverts: true, factor: 2, targetProperty: 'actionTimeFactor'}
  	  ]
  	  @addEffect effect, @ for effect in effects
  	  @sayWithoutBlocking? icontext.vroom
  	  @oldCollect collectable
  	else
  	  @oldCollect collectable

  rebuildBody: (who, size=1) ->
    who.destroyBody()
    who.width = size
    who.height = size
    who.createBodyDef()
    who.createBody()
  brakeOnSay: (who) ->
    say = who.say
    who.say = (message, data, _excess) ->
  	who.brake()
  	say(message, data, _excess)
  ##########################################
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
<<<<<<< HEAD
    unit.isAttackable = false #Important

=======
    unit.isAttackable = false #Important 
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
    if color is "red"
      @world.getSystem('Inventory').teamGold.humans.gold -= params.cost
    if color is "blue"
      @world.getSystem('Inventory').teamGold.ogres.gold -= params.cost
<<<<<<< HEAD

=======
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
    if unit.actions.attack?.cooldown
      unit.actions.attack.cooldown = params.attackCooldown
    unit.commander = @
    unit.type = unitType 
    unit.color = color
<<<<<<< HEAD



=======
    
    
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
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

    #Setup the units properly in preparation of the level reset
    @world.getSystem('Inventory').teamGold.ogres.gold = 100
    @world.getSystem('Inventory').teamGold.humans.gold = 100

    @redHeart.health = @redHeart.maxHealth
    @blueHeart.health = @blueHeart.maxHealth
    @skele1.pos.x = 20
    @skele1.pos.y = 54
    @skele2.pos.x = 60
    @skele2.pos.y = 54
    @skele1.health = @skele1.maxHealth
    @skele2.health = @skele2.maxHealth
    # @generator1.pos.x = 20
    # @generator1.pos.y = 52
    # @generator2.pos.x = 60
    # @generator2.pos.y = 52
    # @generator1.health = @generator1.maxHealth
    # @generator2.health = @generator2.maxHealth

<<<<<<< HEAD

=======
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e


    # @hero.health = @redHeart.maxHealth
    # @hero.maxHealth = @redHeart.maxHealth
    # @hero.keepTrackedProperty("health")
    # @hero.keepTrackedProperty("maxHealth")
    # @hero2.health = @blueHeart.maxHealth
    # @hero2.maxHealth = @blueHeart.maxHealth
    # @hero2.keepTrackedProperty("health")
    # @hero2.keepTrackedProperty("maxHealth")
    @redHeart.setExists(true)
    @blueHeart.setExists(true)
<<<<<<< HEAD



=======
 
    
    
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e



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

    @skele1.attack(@redHeart)
    @skele2.attack(@blueHeart)

<<<<<<< HEAD


=======
    
  
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
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
<<<<<<< HEAD

=======
   
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
    @skele1.attack(@redHeart)
    @skele2.attack(@blueHeart)

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
<<<<<<< HEAD


=======
    
      
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
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
<<<<<<< HEAD

=======
  
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
  checkWinner: () -> #Editing to have win condition based on Heart health
    return if not @roundStarted
    aliveRed = @redHeart.health
    aliveBlue = @blueHeart.health
<<<<<<< HEAD




=======
    
    
    
        
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
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
<<<<<<< HEAD
}

=======
}
>>>>>>> 4cad07528cad1b8ba1ff3c5538f7ed47df02769e
