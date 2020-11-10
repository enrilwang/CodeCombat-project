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


def summonArchers(pos):
    hero.say("archer," + pos)
    hero.say("archer," + pos)
    hero.say("archer," + pos)

def summonBuffer(pos):
    hero.say("buffer," + pos)

summonArchers(0)
summonArchers(3)

buffers = 0
while True:
    if hero.gold > 70 and buffers < 2:
        if buffers == 0:
            summonBuffer(0)
        else:
            summonBuffer(3)
        buffers += 1
    elif buffers == 2:
        summonArchers(0)
