# Set register 8 to a value to check for later on. Uses the same hook as Ro's "Play Different Item Receieve Sound When Receiving Shock, Star, or Bullet."

# Inject @:
# PAL   : 8079814C
# NTSC-U: 8078F140
# NTSC-J: 807977B8
# NTSC-K: 8078650C

# Play original item receive sound
li r4, 0xE3

# Check if the item ID in register 28 is less than or equal to the Blue Shell and set register 8 if true.
cmpwi r28, 7
ble end
li r8, 1

end:                             # End of function.
