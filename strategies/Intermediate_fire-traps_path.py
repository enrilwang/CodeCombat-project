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

x, y = 50, 50
distance = 20
while True:
    if hero.gold > 60:
        hero.buildXY("palisade", x, y)
        hero.buildXY("palisade", x, y - 2)
        hero.buildXY("fire-trap", 60, y - 4)
        x, y = x + distance, y - 10
        distance = -distance
        if y < 20:
            y = 50
