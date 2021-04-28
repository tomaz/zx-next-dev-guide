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

start:

	; Enable Layer 2
	LD BC, $123B
	LD A, 2
	OUT (C), A
    
	; Setup starting Layer2 16K bank and swap corresponding 8K
	; memory bank into screen memory $C000 where L2 will read from
	NEXTREG $12, START_16K_BANK

	LD D, 0                   ; D=Y, start at top of the screen
    
nextY:
	; Calculate bank number and swap it in
	LD A, D                   ; Copy current Y to A
	AND %11100000             ; 32100000 (3MSB = bank number)
	RLCA                      ; 21000003
	RLCA                      ; 10000032
	RLCA                      ; 00000321
	ADD A, START_8K_BANK      ; A=bank number to swap in
	NEXTREG $56, A            ; Swap bank

	; Convert DE (yx) to screen memory location starting at $C000
	PUSH DE                   ; (DE) will be changed to bank offset
	LD A, D                   ; Copy current Y to A
	AND %00011111             ; Discard bank number
	OR $C0                    ; Screen starts at $C000
	LD D, A                   ; D=high byte for $C000 screen memory

	; Loop X through 0..255; we don't have to deal with bank swapping
	; here because it only occurs when changing Y
	LD E, 0
nextX:
	LD A, E                   ; A=current X
	LD (DE), A                ; Write X into corresponding memory
	INC E                     ; Increment to next X
	JR NZ, nextX              ; Repeat until E rolls over

	; Continue with next line or exit
	POP DE                    ; Restore DE to coordinates
	INC D                     ; Increment to next Y
	LD A, D                   ; A=current Y
	CP 192                    ; Did we just complete last line?
	JP C, nextY               ; No, continue with next linee

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

