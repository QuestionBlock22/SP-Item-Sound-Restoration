# Play Different Item Receive Sound When Receiving Special Items [Ro, QB22]

# Modified to play the sound for more than just the Shock, Star, or Bullet Bill. Essentially restoring the special item sound from Mario Kart DS and Mario Kart Double Dash!!.

# Write to:
# PAL   : 8079814C
# NTSC-U: 8078F140
# NTSC-J: 807977B8
# NTSC-K: 8078650C

.set region, '' # Fill with P, E, J, or K in the quotes to assemble for a particular region.

.if (region == 'P' || region == 'p') # PAL/Europe
    .set raceInfoBase, 0x28d0    # Raceinfo::spInstance (Upper-half conveniently loaded in register 3. Full value is 809bd730 when subtracted.)
    .set raceDataBase, 0x28d8     # Racedata::spInstance (See above for upper-half.)

.elseif (region == 'E' || region == 'e') # NTSC-U/North America
    .set raceInfoBase, 0x7090
    .set raceDataBase, 0x7098

.elseif (region == 'J' || region == 'j') # NTSC-J/Japan
    .set raceInfoBase, 0x3870
    .set raceDataBase, 0x3878

.elseif (region == 'K' || region == 'k') # NTSC-K/Korea
    .set raceInfoBase, 0x4290
    .set raceDataBase, 0x4298

.else
    .err
.endif

# Play original item receive sound
li r4, 0xE3

# Check if the race is finished.
lwz r11, -raceInfoBase (r3)
lwz r0, 0x028 (r11)              # raceinfo->state
cmpwi r0, 4
beq end

# Make sure the game type is the racing state.
lwz r11, -raceDataBase (r3)
lwz r0, 0x0b74 (r11)             # racedata->racesscenario->settings->gametype
cmpwi r0, 0
bne end

# Check if the item ID in register 28 is less than or equal to the Blue Shell and end if true.
cmpwi r28, 7
ble end

# Play the special item sound (index 1EA in modified revo_kart.brsar).
li r4, 0x1EA

end:                             # End of function.
