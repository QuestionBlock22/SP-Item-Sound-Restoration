# Use the startInfo trick to play the special item sound.

# Inject @
# PAL   : 80717770
# NTSC-U: 8070fccc
# NTSC-J: 80716ddc
# NTSC-K: 80705b18

# Based on the code "Play the Unused Trick Sound on Rainbow Road's Slot."

# .set region, '' # Fill with P, E, J, or K to assemble for a particular region.
.if (region == 'P' || region == 'p')
	.set soundArchiveBase, 0x809c2898
	.set SoundArchivePlayer_detail_GetFileAddress, 0x800a1560
	.set SoundStartable_detail_StartSound, 0x800a3e80
.elseif (region == 'E' || region == 'e')
	.set soundArchiveBase, 0x809cdc58
	.set SoundArchivePlayer_detail_GetFileAddress, 0x800a14c0
	.set SoundStartable_detail_StartSound, 0x800a3de0
.elseif (region == 'J' || region == 'j')
	.set soundArchiveBase, 0x809c18f8
	.set SoundArchivePlayer_detail_GetFileAddress, 0x800a1480
	.set SoundStartable_detail_StartSound, 0x800a3da0
.elseif (region == 'K' || region == 'k')
	.set soundArchiveBase, 0x809b0ed8
	.set SoundArchivePlayer_detail_GetFileAddress, 0x800a15c0
	.set SoundStartable_detail_StartSound, 0x800a3ee0
.else
	.err
.endif

.macro stackPush
	stwu sp, -0x40 (sp)
	stw r31, 0x3c (sp)
	mr r31, r5
	stw r30, 0x38 (sp)
	mr r30, r4
	stw r29, 0x34 (sp)
	mr r29, r3
.endm

.macro popStack
	lwz r31, 0x3c (sp)
	lwz r30, 0x38 (sp)
	lwz r29, 0x34 (sp)
	addi sp, sp, 0x40
.endm

.set SE_RC_ITEM_DECIDE, 0xE3

# void UIControl::PlayItemDecideSpecial(&handle, soundId, *startInfo, *soundArchivePlayer, isSpecialItem)

stackPush

# Check register 8 and register 5.
cmpwi r5, SE_RC_ITEM_DECIDE
bne end
cmpwi r8, 1
bne end
li r0, 0
stw r0, 0x20 (sp)							# Start setting up startInfo. startInfo exclusively uses the stack pointer.
bl storeLabelName

labelName:
        .asciz "item_decide_special"
	.align 2

storeLabelName:
mflr r3
stw r3, 0x24 (sp)							# Set the sequence start location.
ori r0, r0, 0x10							# ENABLE_SEQ_SOUND_INFO (snd_soundstartable.hpp)
stw r0, 0x8 (sp)

# Get the data offset for the BRSEQ file.
lis r12, soundArchiveBase@h
li r4, 0x188								# File ID #392 in "revo_kart.brsar"
lwz r7, soundArchiveBase@l (r12)
lwz r3, 0x5bc (r7)
lis r11, SoundArchivePlayer_detail_GetFileAddress@h
ori r11, r11, SoundArchivePlayer_detail_GetFileAddress@l
mtctr r11
bctrl
stw r3, 0x20 (sp)
mr r3, r29
mr r4, r30
mr r5, r31
addi r6, sp, 0x8							# Get the address to startInfo from the stack pointer as the final function parameter.

end:
lis r12, SoundStartable_detail_StartSound@h
ori r12, r12, SoundStartable_detail_StartSound@l
mtctr r12
bctrl									# Original instruction set

popStack
