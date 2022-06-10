;;--------------------------------------------------------------------
;; sjasmplus setup
;;--------------------------------------------------------------------

	; Allow Next paging and instructions
	DEVICE ZXSPECTRUMNEXT
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

	; Generate a map file for use with Cspect
	CSPECTMAP "build/test.map"


;;--------------------------------------------------------------------
;; program
;;--------------------------------------------------------------------

L2_START_16K_BANK = 9
L2_START_8K_BANK = L2_START_16K_BANK * 2
L2_END_8K_BANK = L2_START_8K_BANK + 6

	; Main program will start at $8000
	ORG $8000
Start:
	; Run the program
	CALL InitializeLayer2
	CALL InitializeCopper		; only need one...
	; CALL InitializeCopperDMA	; ...or the other
	CALL MainLoop

	; Return from main routine (will never occur in our case)
	RET

InitializeLayer2:
	; Enable Layer 2
	LD BC, $123B
	LD A, 2
	OUT (C), A

	; Setup starting Layer2 16K bank and swap corresponding 8K memory bank into screen memory $C000 where L2 will read from
	NEXTREG $12, L2_START_16K_BANK

	; We'll fill in each of 6 8K banks, bank by bank, starting with the first one
	LD A, L2_START_8K_BANK

.nextBank:
	; Swap current bank into slot 6 (memory $C000-$DFFF)
	NEXTREG $56, A

	; Prepare starting address and fill in 0 to the first byte. We'll copy this value over the rest of the memory.
	LD HL, $C000
	LD (HL), 0

	; We'll use DMA to copy the first byte (we just set to 0) over remaining 8K. DMA setup will be: port A = $C000 and will remain fixed throughout the transfer, port B starts at $C001 and will be incremented after each transfer, length = 8K-1
	LD HL, .dmaProgram	; HL = pointer to DMA program
	LD B, .dmaProgramLength	; B = size of the code
	LD C, $6B		; C = $6B (DMA port)
	OTIR			; upload and run DMA program

	; Continue with next bank, until we fill all
	INC A
	CP A, L2_END_8K_BANK+1
	JP NZ, .nextBank
	RET

.dmaProgram:
	DB %10000011		; WR6 - Disable DMA
	DB %01111101		; WR0 - append length + port A address, A->B
	DW $C000		; WR0 par 1&2 - port A start address
	DW 8*1024-1		; WR0 par 3&4 - transfer length
	DB %00100100		; WR1 - A fixed, A=memory
	DB %00010000		; WR2 - B incrementing, B=memory
	DB %10101101		; WR4 - continuous, append port B address
	DW $C001		; WR4 par 1&2 - port B address
	DB %10000010		; WR5 - stop on end of block, CE only
	DB %11001111		; WR6 - load addresses into DMA counters
	DB %10000111		; WR6 - enable DMA
.dmaProgramLength = $-.dmaProgram


; Demonstrates how to initialize Copper using NEXTREG $63 directly
InitializeCopper:
	; Stop copper and set data upload index to 0
	NEXTREG $61, %00000000
	NEXTREG $62, %00000000

	; Copy our copper list into copper memory
	LD HL, CopperList	; HL now points to start of copper list
	LD DE, CopperListSize	; DE = size of our copper list in bytes

	; Prepare counters for a fast 16-bit loop
	LD B, E			; We need B for DJNZ
	DEC DE			; This ensures INC D below will only be incremented if DE>255
	INC D			; We will DEC D to exit loop below, so we need to INC it here
.nextByte:
	; Note: we use $63 register which only sends the instruction to Copper memory after both bytes are written (after 2 NEXTREG $63 calls). We could also use $60 which writes bytes immediately, however this can lead to Copper executing instruction when after only single byte is written. $63 prevents that. This is not an issue in our case because we explicitly stop the Copper before uploading the program, but something to keep in mind. Also see how we use $60 in MainLoop!
	LD A, (HL)		; Load current byte to A
	NEXTREG $63, A		; Copy it to copper memory (this will auto-increment to next memory position)

	; Prepare for next byte
	INC HL			; Increment HL to next byte

	; Repeat or exit
	DJNZ .nextByte		; Repeat (max 256 times)
	DEC D			; Check if we need to repeat DJNZ loop again
	JP NZ, .nextByte	; Yes? Repeat then... :)

	; Finally start copper using mode %11
	NEXTREG $61, %00000000
	NEXTREG $62, %11000000

	RET

; Demonstrates how to initialize Copper using DMA
InitializeCopperDMA:
	; We simply set the parameters and let execution continue inside the reusable `InitializeCopperListDMA` routine.
	LD HL, CopperList
	LD BC, CopperListSize

; This is generic reusable routine for uploading Copper list to DMA. It takes two parameters (both are destroyed):
; - HL = address of the Copper list in memory
; - BC = size of Copper list in bytes
InitializeCopperListDMA:
	; Stop copper and set data upload index to 0
	NEXTREG $61, %00000000
	NEXTREG $62, %00000000

	; Copy parameters into DMA code
	LD (.dmaSource), HL
	LD (.dmaLength), BC

	; We want to upload to NEXTREG $63, select it with $243B port
	LD A, $63
	LD BC, $243B
	OUT (C), A

	; Upload DMA instructions to DMA memory
	LD HL, .dmaProgram	; HL = pointer to DMA program
	LD B, .dmaProgramLength	; B = size of the code
	LD C, $6B		; C = $6B (DMA port)
	OTIR			; upload DMA program

	; Finally start copper using mode %11
	NEXTREG $61, %00000000
	NEXTREG $62, %11000000
	RET

.dmaProgram:
	DB %10000011		; WR6 - Disable DMA
	DB %01111101		; WR0 - append length + port A address, A->B
.dmaSource:
	DW 0			; WR0 par 1&2 - port A start address
.dmaLength:
	DW 0			; WR0 par 3&4 - transfer length
	DB %00010100		; WR1 - A incr., A=memory
	DB %00101000		; WR2 - B fixed, B=I/O
	DB %10101101		; WR4 - continuous, append port B address
	DW $253B		; WR4 par 1&2 - port B address
	DB %10000010		; WR5 - stop on end of block, CE only
	DB %11001111		; WR6 - load addresses into DMA counters
	DB %10000111		; WR6 - enable DMA
.dmaProgramLength = $-.dmaProgram


MainLoop:
MIN_Y = 10	; minimum Y coordinate for animation
MAX_Y = 93	; maximum Y coordinate for animation

	; First move down the screen (aka make red area shorter)
	LD A, MIN_Y			; Prepare starting coordinate
.downTheScreen:
	CALL WaitAWhile			; A litte delay...
	CALL UpdateCopperRedWait	; Update copper red wait command with new one from A
	CALL UpdateCopperWindowLeftPos	; Update Layer 2 left position

	INC A				; Increment A
	CP MAX_Y			; Did we reach the maximum coordinate?
	JP NZ, .downTheScreen		; No? Repeat. Otherwise continue

	; Now move back upwards (aka make red area taller)
.upTheScreen:
	CALL WaitAWhile			; A litte delay...
	CALL UpdateCopperRedWait	; Update copper red wait comnmand with new one from A
	CALL UpdateCopperWindowLeftPos	; Update Layer 2 left position

	DEC A				; Decrement A
	CP MIN_Y			; Did we reach the minimum coordinate?
	JP NZ, .upTheScreen		; No? Repeat. Otherwise continue

	; Repeat the whole loop again, and again, and again, and... you get the point ;)
	JP MainLoop

UpdateCopperRedWait:
	; The gist of this routine is to offset current Copper PC to WAIT command that subsequently changes background colour to red. Then write updated Y coordinate from A register.

	; First prepare Copper PC to our command. This is simplified code that only works as long as the offset from the start of the list is less than 256!
	; Note we only need to update the Y position in LSB of the red wait instruction. As our label points to the MSB byte, we need to add 1.
	NEXTREG $61, CopperListRedWait	; LSB contains the bits 7-0 of the Copper instruction offset
	NEXTREG $62, %11'000'000	; 11=start from 0 & repeat, the rest are 0 because we never have offsets > 255

	; Now we need to write the byte that contain new WAIT Y coordinate. Again we simplify the code by relying on the fact that we never change Y above 255.
	; Note: since we only write 1 byte, we can't use $63 register. $63 expects both bytes of an instruction to be set, it only writes afterwards. But $60 writes each byte immediately.
	NEXTREG $60, A			; A contains new Y coordinate

	RET

UpdateCopperWindowLeftPos:
	; This works exactly the same as `UpdateCopperRedWait`, except we update the byte specifying Layer 2 Window left position.

	; First prepare Copper PC to our command. This is simplified code that only works as long as the offset from the start of the list is less than 256!
	; Note we only need to update the Y position in LSB of the red wait instruction. As our label points to the MSB byte, we need to add 1.
	NEXTREG $61, CopperListWindowLeftMove; LSB contains the bits 7-0 of the Copper instruction offset
	NEXTREG $62, %11'000'000	; 11=start from 0 & repeat, the rest are 0 because we never have offsets > 255

	; Now we need to write the byte that contain new position from A.
	; Note: since we only write 1 byte, we can't use $63 register. $63 expects both bytes of an instruction to be set, it only writes afterwards. But $60 writes each byte immediately.
	NEXTREG $60, A			; A contains new Y coordinate

	RET

WaitAWhile:
	LD C, 10
.cloop:
	LD B, $FF
.bloop:	NOP
	NOP
	NOP
	NOP
	DJNZ .bloop

	DEC C
	JP NZ, .cloop
	RET

;;--------------------------------------------------------------------
;; copper list
;;--------------------------------------------------------------------

; declares copper wait instruction for given horizontal (0-440) and vertical (0-311) position
	MACRO COPPER_WAIT hor, ver
	DB %10000000 | ((hor/8) << 1) | ((ver & $1FF) >> 8)	; %1hhhhhhv (bit 9 of vertical)
	DB (ver & $FF)						; %vvvvvvvv (lsb of vertical)
	ENDM

; declares copper move instruction for moving given value (0-255) to given Next register (0-127)
	MACRO COPPER_MOVE reg, value
	DB (reg & %01111111)			; %0rrrrrrr
	DB (value & $FF)			; %vvvvvvvv
	ENDM

; declares copper NOOP instruction
	MACRO COPPER_NOOP
	DB %00000000
	DB %00000000
	ENDM

; declares copper HALT instruction (for ending copper list)
	MACRO COPPER_HALT
	DB %11111111
	DB %11111111
	ENDM

; declares 9-bit RGB colour through double $44 reg call; red, green and blue are 0-7
	MACRO COPPER_9BIT red, green, blue
	COPPER_MOVE $44, ((red & %111) << 5) | ((green & %111) << 2) | ((blue & %110) >> 1)
	COPPER_MOVE $44, (blue & %1)
	ENDM

; a sample copper list that changes palette entry 0 colour for Layer 2 palette 4 times
CopperList:
	; Wait line 0
	COPPER_WAIT 0, 0

	; Prepare palette handling (and hope noone changes this during copper pass ¯\_(ツ)_/¯)
	COPPER_MOVE $43, %10010000	; no auto-inc, L2 first palette
	COPPER_MOVE $40, 0		; colour index 0

	; Change L2 palette entry 0 to gray-ish
	COPPER_9BIT 1, 2, 2

	; Wait line 47 and change palette entry 0 to red-ish
CopperListRedWait = $ - CopperList + 1	; we will change the LSB of the WAIT instruction below, hence +1
	COPPER_WAIT 0, 47		; we'll change this 47 to animate the offset of the red background in the main loop
	COPPER_9BIT 4, 2, 2

	; Update Layer 2 clip window left position.
	COPPER_MOVE $1C, 1		; Reset Layer 2 clip window register index
CopperListWindowLeftMove = $ - CopperList + 1; we will change the value of the MOVE below, so LSB, hence +1
	COPPER_MOVE $18, 0		; Write clip window coordinate for L2, since we reset it above, this will always be left position

	; Wait line 94 and change palette entry 0 to green-ish as well as reset window position to 0. By resetting window coordinate we effectively restrict it to the red area above
	COPPER_WAIT 0, 94
	COPPER_9BIT 2, 4, 2
	COPPER_MOVE $1C, 1
	COPPER_MOVE $18, 0

	; Wait line 141 and change palette entry 0 to blue-ish
	COPPER_WAIT 0, 141
	COPPER_9BIT 1, 1, 4

	COPPER_HALT
CopperListSize = $ - CopperList


;;--------------------------------------------------------------------
;; Set up .nex output
;;--------------------------------------------------------------------

	; This sets the name of the project, the start address, 
	; and the initial stack pointer.
	SAVENEX OPEN "build/test.nex", Start, $ff40

	; This asserts the minimum core version.  Set it to the core version 
	; you are developing on.
	SAVENEX CORE 2, 0, 0

	; This sets the border colour while loading (in this case white),
	; what to do with the file handle of the nex file when starting (0 = 
	; close file handle as we're not going to access the project.nex 
	; file after starting.  See sjasmplus documentation), whether
	; we preserve the next registers (0 = no, we set to default), and 
	; whether we require the full 2MB expansion (0 = no we don't).
	SAVENEX CFG 7, 0, 0, 0

	; Generate the Nex file automatically based on which pages you use.
	SAVENEX AUTO

