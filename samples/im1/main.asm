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

; The 8K page into which out interrupt program will be compiled to. We'll page out ROM at slot 0 with this page to get our interrupt working.
INTERRUPT_PAGE = 28

	; Main program will start at $8000
	ORG $8000
Start:
	; Try different CPU speeds (0-3) - the faster the CPU, the faster out main loop will be, therefore interrupt will occur less times and counter will not change so much between each iteration.
	NEXTREG $07, 3

	; Disable interrupts while we're paging out ROM, just in case to prevent one being raised before we're done.
	DI

	; Page out ROM in slot 0 ($0000-$1FFF). This will "inject" our interrupt handler to $0038 (as well as anything else we put into this page).
	NEXTREG $50, INTERRUPT_PAGE

	; Explicitly enable IM1; technically we don't have to since Next does it by default, but this ensures IM1 will be used in case another program run before ours set up IM2.
	IM 1

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
	LD B, $ff
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
;; interrupt handler
;;--------------------------------------------------------------------

	; In a nutshell, the following code is compiled into selected 8K bank which is loaded into slot 6 ($C000-$DFFF). We will load this bank into slot 0 ($0000-$1FFF) at the start of the program which will effectively page out ROM at those addresses.

	; Tell sjasmplus to load given 8K page into slot 6 ($C000-$DFFF).
	SLOT 6
	PAGE INTERRUPT_PAGE

	; Tell sjasmplus to start writing code into start of slot 6 (which now has given bank loaded into - so we're effectively writing the code into selected bank).
	ORG $C038

; The interrupt handler itself...
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

