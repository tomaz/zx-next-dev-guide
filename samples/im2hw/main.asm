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

	; Prepare programmable portion of IM2 vector in bits 7-5 and enable IM2 mode in bit 0
	; Because we use .ALIGN 32, interrupt table already uses top 3 bits of LSB only, so we don't have to and with %11100000. But we do need to and with "something" in order to suppress assembler warning (vector table is 16-bit address while we need 8-bit value, so it warns us about potential data loss). We do need to set bit 0 though to enable IM2 mode!
	NEXTREG $C0, (InterruptVectorTable & %11100000) | %00000001

	; Enable expansion bus /INT (bit 7) and ULA interrupts (bit 0)
	NEXTREG $C4, %10000001

	; Disable all CTC channel interrupts
	NEXTREG $C5, %00000000

	; Disable UART0 and UART1 interrupts.
	NEXTREG $C6, %00000000

	; Prepare I register to point to MSB of the vector table. This is the same as with legacy IM2.
	LD A, InterruptVectorTable >> 8	; prepare high byte for vector table...
	LD I, A				; ...and copy it over to I

	; Enable IM2; since we switched hardware IM2 mode with nextreg $C0 above, we are in fact enabling that mode, therefore we don't need the legacy IM2 vector table.
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

InterruptHandlerLine:
	; In line interrupt we reset line bit that indicates whether interrupt was generated or not. Then we process interrupt exactly the same as otherwise.
	; This is not needed for subsequent interrupts - they will be triggered again regardless of whether we do this or not. We can use it to determine whether the interrupt was triggered since last time.
	NEXTREG $C8, %00000010
	JP InterruptHandler
InterruptHandlerULA:
	; In ULA interrupt we reset ULA bit that indicates whether interrupt was generated or not. Then we process interrupt exactly the same as otherwise.
	; This is not needed for subsequent interrupts - they will be triggered again regardless of whether we do this or not. We can use it to determine whether the interrupt was triggered since last time.
	NEXTREG $C8, %00000001
InterruptHandlerCTC:
InterruptHandler:
	; Save registers.
	EX AF, AF'
	EXX

	; Load address of our counter and increment it
	LD HL, counter
	INC (HL)

	; Restore registers.
	EXX
	EX AF, AF'

	; Re-enable interrupts (note we don't have to call DI, system will do it for us)
	EI

	; Return from interrupt!
	RETI

;;--------------------------------------------------------------------
;; vector table
;;--------------------------------------------------------------------

	; Vector table must be aligned to %xxxxxxxx %xxx00000 address.
	.ALIGN 32
InterruptVectorTable:
	; Note: I setup different interrupt vectors only to demonstrate we can have multiple handlers. In this example they all point to the same interrupt routine so all could be the same (apart from line and ULA which indeed execute additional commands).
	DW InterruptHandlerLine	; 0 = line interrupt (highest priority)
	DW InterruptHandler	; 1 = UART0 Rx
	DW InterruptHandler	; 2 = UART1 Rx
	DW InterruptHandlerCTC	; 3 = CTC channel 0
	DW InterruptHandlerCTC	; 4 = CTC channel 1
	DW InterruptHandlerCTC	; 5 = CTC channel 2
	DW InterruptHandlerCTC	; 6 = CTC channel 3
	DW InterruptHandlerCTC	; 7 = CTC channel 4
	DW InterruptHandlerCTC	; 8 = CTC channel 5
	DW InterruptHandlerCTC	; 9 = CTC channel 6
	DW InterruptHandlerCTC	; 10 = CTC channel 7
	DW InterruptHandlerULA	; 11 = ULA
	DW InterruptHandler	; 12 = UART0 Tx
	DW InterruptHandler	; 13 = UART1 Tx (lowest priority)
	; Not sure if the following 2 vectors are needed - I only counted 14 interrupters!? It just felt awkward to only have 14 instead of "rounded" 16... ¯\_(ツ)_/¯
	DW InterruptHandler
	DW InterruptHandler

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

