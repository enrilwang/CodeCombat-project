# Welcome to Heart Guardians!! Perpare for combat!

# If you have enough gold, you can say the type and the position of a unit you would like to summon!
# You can use: hero.say("unit,position") to summor a unit on the specfic position.

# Units and cost:
# warrior: 30 gold
# knight: 25 gold
# thief: 30 gold
# wizard: 40 gold
# archer: 30 gold
# thrower: 20 gold
# buffer: 70 gold
# warlock: 100 gold

# You can use: hero.buildXY("item",xPos,yPos) to build an item at that coordinate point.

# Items and cost
# palisade: 5 gold
# fire-trap: 50 gold


def summonArchers(n, pos):
    archers = 0
    while True:
        if  hero.gold >= 30 and archers < n:
            hero.say("archer,"+pos)
            archers += 1
        if archers == n:
            return

def setupWarlock():
    while True:
        if  hero.gold >= 100:
            hero.say("warlock,5")
            return

def setupBuffer(pos):
    while True:
        if  hero.gold >= 70:
            hero.say("buffer," + pos)
            return

def addMore(n, pos):
    summonArchers(3, pos)
    setupBuffer(pos)
    summonArchers(n - 4, pos)

def initialSummon():
    summonArchers(3, 0)
    summonArchers(3, 3)

def completeSummon():
    setupWarlock()
    addMore(6, 0)
    addMore(6, 3)
    addMore(9, 1)
    addMore(9, 4)
    addMore(9, 2)
    addMore(8, 5)

initialSummon()
completeSummon()
