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

; IMPORTANT: For this program to work on CSpect, you will need to 
; install OpenAL. Without it, CSpect will freeze on launch.
; Follow instructions from https://specnext.dev/tutorials/creating-a-z80-assembly-development-environment-on-windows/

	ORG $8000 

start:
	; Setup Turbo Sound chip
	LD BC, $FFFD		; Turbo Sound Next Control Register
	LD A, %11111101		; Enable left+right audio, select AY1
	OUT (C), A

	; Setup mapping of chip channels to stereo channels
	NEXTREG $08, %00010010	; Use ABC, enable internal speaker & turbosound
	NEXTREG $09, %11100000	; Enable mono for AY0-2

	; Play the tune
.infiniteLoop:
	LD HL, tune
	CALL playTune	
	JP .infiniteLoop

	RET

; HL = address in memory where tune starts
playTune:
	; Read noise/tone enable/disable
	LD A, (HL)	; Read next byte from (HL)
	CP $FF		; Is it $FF?
	RET Z		; Yes, exit

	; We still have data, transfer A to D and write to AY register 7
	LD D, A
	LD A, 7
	INC HL
	CALL writeDToAYReg

	; Read tone period (regs 0 & 1)
	LD A, 0
	LD E, (HL)
	INC HL
	LD D, (HL)
	INC HL
	CALL writeDEToAYReg

	; Read noise period (reg 6)
	LD A, 6
	LD D, (HL)
	INC HL
	CALL writeDToAYReg

	; Read channel for setting up volume (0-2)
	LD A, (HL)
	INC HL
	ADD 8		; channel A is reg 8, B=9, C=10

	; Read and set volume to register in A
	LD D, (HL)
	INC HL
	CALL writeDToAYReg

	; Do a small pause between tones...
	LD BC, $1000
.delay:
	DEC BC
	LD A, B
	OR C
	JR NZ, .delay

	; ...then continue with next tone
	JP playTune

tune:
	;     Noise enable (0), disable (1)
	;     |  Tone enable (0), disable (1)
	;     |  |    Tone period ($0-$FFF)
	;     |  |    |        Noise period ($0-$1F)
	;     |  |    |        |    Channel (0=A, 1=B, 2=C)
	;     |--|--  |        |    |  Volume ($0-$F)
	;   --CBACBA  |------  |--  |  |-
	DB %00111110, $00,$3F, $00, 0, $F
	DB %00111110, $00,$97, $00, 0, $A
	DB %00111110, $01,$00, $00, 0, $6
	DB %00110110, $00,$00, $1F, 0, $4
	DB %00110110, $00,$00, $11, 0, $4
	DB %00111110, $00,$4C, $00, 0, $A
	DB %00111110, $00,$7E, $00, 0, $7
	DB %00110110, $00,$C9, $1F, 0, $4
	DB %00110110, $01,$00, $11, 0, $4
	DB %00111110, $00,$00, $00, 0, $2
	DB %00111110, $00,$00, $00, 0, $2
	DB %00111110, $01,$2E, $00, 0, $1 
	DB %00111110, $01,$60, $00, 0, $1
	DB %00111110, $01,$92, $00, 0, $1
	DB %00111110, $00,$00, $00, 0, $2
	DB %00111110, $03,$0F, $17, 0, $C
	DB %00111110, $03,$C6, $10, 0, $B
	DB %00111110, $04,$40, $0E, 0, $A
	DB %00111110, $05,$35, $10, 0, $9
	DB %00111110, $05,$EC, $13, 0, $8
	DB %00111110, $06,$E1, $11, 0, $7
	DB $FF ; $FF = end of song

; Writes D to register A and E to A+1
; A = Starting register number
; DE = 16 bit value to write
writeDEToAYReg:
	PUSH AF		; writeDToAYReg will change A

	; Write D first
	CALL writeDToAYReg

	; Swap E to D and increment A, then continue straight to writeDToAYReg
	POP AF		; Restore A
	INC A		; Write to next register
	LD D, E		; Prepare value to write

; Note: register number (A) must have bit 7 reset, otherwise Next will use it as Turbo Sound Control! Should not be an issue as AY only uses registers 0-13
; A = Register number
; D = Value to write
writeDToAYReg:
	; Select desired register
	LD BC, $FFFD
	OUT (C), A

	; Write given value
	LD A, D
	LD BC, $BFFD
	OUT (C), A

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

