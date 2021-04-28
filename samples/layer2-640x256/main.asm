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

	ORG $8000 

START_16K_BANK  EQU 9
START_8K_BANK   EQU START_16K_BANK*2

RESOLUTION_X    EQU 640
RESOLUTION_Y    EQU 256

BANK_8K_SIZE    EQU 8192
NUM_BANKS       EQU RESOLUTION_X * RESOLUTION_Y / BANK_8K_SIZE / 2
BANK_X          EQU BANK_8K_SIZE / RESOLUTION_Y


start:

	; Enable Layer 2
	LD BC, $123B
	LD A, 2
	OUT (C), A

	; Setup starting Layer2 16K bank and swap corresponding 8K
	; memory bank into screen memory $C000 where L2 will read from
	NEXTREG $12, START_16K_BANK
	NEXTREG $70, %00100000    ; 640x256 256 colour mode

	NEXTREG $1C, 1            ; Reset Layer 2 clip window reg index
	NEXTREG $18, 0
	NEXTREG $18, RESOLUTION_X / 4 - 1
	NEXTREG $18, 0
	NEXTREG $18, RESOLUTION_Y - 1

	LD B, START_8K_BANK       ; Bank number
	LD H, 0                   ; Colour

nextBank:
	; Swap to next bank, exit once all 5 are done
	LD A, B                   ; Copy current bank number to A
	NEXTREG $56, A            ; Switch to bank

	; Fill in current bank
	LD DE, $C000              ; Prepare starting address

nextY:
	; Fill in 256 pixels of current line
	LD A, H                   ; Copy colour to A
	LD (DE), A                ; Write colour into memory
	INC E                     ; Increment Y
	JR NZ, nextY              ; Continue with next Y until we wrap to next X

	; Prepare for next line until bank is full
	INC H                     ; Increment colour
	INC D                     ; Increment X
	LD A, D                   ; Copy X to A
	AND %00111111             ; Clear $C0 to get pure X coordinate
	CP BANK_X                 ; Did we reach next bank?
	JP NZ, nextY              ; No, continue with next Y

	; Prepare for next bank
	INC B                     ; Increment to next bank
	LD A, B                   ; Copy bank to A
	CP START_8K_BANK+NUM_BANKS; Did we fill last bank?
	JP NZ, nextBank           ; No, proceed with next bank

.infiniteLoop:
	JR .infiniteLoop

	RET

;;--------------------------------------------------------------------
;; Set up .nex output
;;--------------------------------------------------------------------

	; This sets the name of the project, the start address, 
	; and the initial stack pointer.
	SAVENEX OPEN "build/test.nex", start, $ff40

	; This asserts the minimum core version.  Set it to the core version 
	; you are developing on.
	SAVENEX CORE 2,0,0

	; This sets the border colour while loading (in this case white),
	; what to do with the file handle of the nex file when starting (0 = 
	; close file handle as we're not going to access the project.nex 
	; file after starting.  See sjasmplus documentation), whether
	; we preserve the next registers (0 = no, we set to default), and 
	; whether we require the full 2MB expansion (0 = no we don't).
	SAVENEX CFG 7,0,0,0

	; Generate the Nex file automatically based on which pages you use.
	SAVENEX AUTO

