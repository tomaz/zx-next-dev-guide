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
;; interrupt handler
;;--------------------------------------------------------------------

; The interrupt handler itself; it can be anywhere in the memory.
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
;; interrupt vector table
;;--------------------------------------------------------------------

; Sets up the interrupt vectors to point to interrupt handler.
; Returns most significant byte of vector table address in I register
SetupInterruptVectors:
	; DE points to interrupt routine handler itself; we'll fill this address into the vector table.
	LD DE, InterruptHandler

	; HL points to interrupt vectors table we'll fill in.
	LD HL, InterruptVectorTable

	; Vector table contains 128 16-bit entries, each one points to the same routine which address we copied to DE register pair previously.
	LD B, 128
.loop:
	LD (HL), E	; Copy low byte
	INC HL
	LD (HL), D	; Copy high byte
	INC HL
	DJNZ .loop

	; Prepare I register to point to MSB of the vector table.
	LD A, InterruptVectorTable >> 8
	LD I, A

	RET

	; 128 entry vector table must start on 256 byte boundary $xx00, each entry 16-bit address pointing to our interrupt vector. For this example we put it towards the end of the addressable memory.
	.ALIGN 256
InterruptVectorTable:
	DEFS 128*2	; 128 16-bit vectors


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

