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

	; Main program will start at $8000
	ORG $8000
Start:
	; Try different CPU speeds (0-3) - the faster the CPU, the faster out main loop will be, therefore interrupt will occur less times and counter will not change so much between each iteration.
	NEXTREG $07, 3

	; Disable interrupts while we're preparing for IM2, just in case to prevent one being triggered in the middle.
	DI

	; Setup interrupt vector table.
	CALL SetupInterruptVectors

	; Enable IM2; this will disable IM1 and use our `InterruptHandler`.
	IM 2

	; We're done with setup, enable interrupts now and let the fun begin...
	EI

	; At this point we'll start infinite loop in our main routine. The only thing it will do is read the value of the counter into A (that our interrupt handler is incrementing). You can inspect the value in debugger.
.loop:
	CALL WaitALittleBitLonger
	LD HL, counter
	LD A, (HL)

	; You can set breakpoint on the following line and inspect A to see how it changes.
	JP .loop

	; Return from main routine (will never occur in our case)
	RET

; Waiting routine; just chilling out, doing nothing for a while :)
WaitAWhile:
	LD B, $FF
.loop:	NOP
	NOP
	NOP
	NOP
	DJNZ .loop
	RET

; A longer delay...
WaitALittleBitLonger:
	LD C, $40
.loop:	CALL WaitAWhile
	DEC C
	JP NZ, .loop
	RET


; Counter variable
counter:
	DB 0


;;--------------------------------------------------------------------
;; interrupt vector table
;;--------------------------------------------------------------------

SetupInterruptVectors:
	; Vector table contains 257 bytes, all the same value. So we can simply setup the first, then use LDIR to fill in the rest. Since our interrupt handler is now on address where both bytes are the same, we can retrieve one and use it as the value to fill in.
	LD A, InterruptHandler >> 8

	; Fill in the whole vector table with the interrupt handler address byte (remember, both, high and low, are the same value). We could hard code interrupt address with DEFS instruction below ("DEFS 256, $F0" in our case) and get rid of this setup code, but then we'd have interrupt routine address hard coded in two places, making it more prone to errors when changing.
	LD HL, InterruptVectorTable	; source
	LD DE, InterruptVectorTable+1	; destination
	LD BC, 256			; 256+1 times (LDI first copies, then tests)
	LD (HL), A			; Write the first byte...
	LDIR				; ...and let LDIR copy it over the other 256

	; Prepare I register to point to MSB of the vector table.
	LD A, InterruptVectorTable >> 8	; prepare high byte for vector table...
	LD I, A				; ...and copy it over to I

	RET

	; 128 entry vector table must start on 256 byte boundary $xx00, each entry 16-bit address pointing to our interrupt vector. We also add additional byte at the end in case bus will hold $FF (which means we can't use $FF00 as we'll overflow!)
	.ALIGN 256
InterruptVectorTable:
	DEFS 257	; 257 bytes are needed this time, in case data bus returns $FF. Note we could also do "DEFS 257, $F0" but then changes to interrupt handler will also need to be made here.


;;--------------------------------------------------------------------
;; interrupt handler
;;--------------------------------------------------------------------

	; The interrupt handler itself; we must have it at exact address this time - both bytes must be equal. Then we can setup vector table with this byte only and it will jump to this interrupt handler regardless of whether it reads vector from odd or even byte in the table!
	ORG $F0F0
InterruptHandler:
	; Note: ideally we'd be exchanging registers here so they would be preserved when interrupts returns. But for this simple example, it'll do.

	; Load address of our counter and increment it
	LD HL, counter
	INC (HL)

	; Re-enable interrupts (note we don't have to call DI, system will do it for us)
	EI

	; Return from interrupt!
	RETI


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

