# Play Different Item Receive Sound When Receiving Special Items [Ro, QB22]

# Modified to play the sound for more than just the Shock, Star, or Bullet Bill. Essentially restoring the special item sound from Mario Kart DS and Mario Kart Double Dash!!.

# Write to:
# PAL   : 8079814C
# NTSC-U: 8078F140
# NTSC-J: 807977B8
# NTSC-K: 8078650C

.set region, '' # Fill with P, E, J, or K in the quotes to assemble for a particular region.

.if (region == 'P' || region == 'p') # PAL/Europe
    .set raceStatePtr, 0x809c28d8
.elseif (region == 'E' || region == 'e') # NTSC-U/North America
    .set raceStatePtr, 0x809c7098
.elseif (region == 'J' || region == 'j') # NTSC-J/Japan
    .set raceStatePtr, 0x809c3878
.elseif (region == 'K' || region == 'k') # NTSC-K/Korea
    .set raceStatePtr, 0x809b4298
.else
    .err
.endif

# Play original item receive sound
li r4, 0xE3

# Check if in any state other than the racing state, end the code if true. (Replay Fix)
lis r11, raceStatePtr@h
lwz r11, -raceStatePtr@l (r11)
lwz r0, 0x0b74 (r11)
cmpwi r0, 0
bne end

# Check if the item ID in register 28 is less than or equal to the Blue Shell and end if true.
cmpwi r28, 7
ble end

# Play the special item sound (index 1EA in modified revo_kart.brsar).
li r4, 0x1EA

end:                             # End of function.