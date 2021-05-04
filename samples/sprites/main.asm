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

start:
	; Load sprite data using DMA
	LD HL, sprites			; Sprites data source
	LD BC, 16*16*5			; Copy 5 sprites, each 16x16 pixels
	LD A, 0				; Start with first sprite
	CALL loadSprites		; Load sprites to FPGA

	; Setup sprite hardware
	NEXTREG $15, %01000001		; sprite 0 on top, SLU, sprites visible

	; Show single sprite 0 using pattern 0
	NEXTREG $34, 0			; First sprite
	NEXTREG $35, 100		; X=100
	NEXTREG $36, 80			; Y=80
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %10000000		; Visible, no byte 4, pattern 0

	; Show single sprite 1 using pattern 0
	NEXTREG $34, 1			; Second sprite
	NEXTREG $35, 84			; X=84
	NEXTREG $36, 80			; Y=80
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %10000000		; Visible, no byte 4, pattern 0

	; Show combined sprite 1-4 using patterns 1-4
	NEXTREG $34, 2			; Select third sprite
	NEXTREG $35, 150		; X=150
	NEXTREG $36, 80			; Y=80
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %11000001		; Visible, use byte 4, pattern 1
	NEXTREG $79, %00100000		; Anchor with unified relatives, no scaling

	NEXTREG $35, 16			; X=AnchorX+16
	NEXTREG $36, 0			; Y=AnchorY+0
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %11000010		; Visible, use byte 4, pattern 2
	NEXTREG $79, %01000000		; Relative sprite

	NEXTREG $35, 0			; X=AnchorX+0
	NEXTREG $36, 16			; Y=AnchorY+16
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %11000011		; Visible, use byte 4, pattern 3
	NEXTREG $79, %01000000		; Relative sprite

	NEXTREG $35, 16			; X=AnchorX+16
	NEXTREG $36, 16			; Y=AnchorY+16
	NEXTREG $37, %00000000		; Palette offset, no mirror, no rotation
	NEXTREG $38, %11000100		; Visible, use byte 4, pattern 4
	NEXTREG $79, %01000000		; Relative sprite

	; Wait for a while
	call delay

	; Update our relative sprite:
	; - change position
	; - rotate
	; - scale X 2x
	NEXTREG $34, 2			; Select third sprite
	NEXTREG $35, 200		; X=200
	NEXTREG $36, 100		; Y=100
	NEXTREG $37, %00000010		; Palette offset, no mirror, rotate
	NEXTREG $38, %11000001		; Visible, use byte 4, pattern 1
	NEXTREG $39, %00101000		; Anchor with unified relatives, scale X 

	call delay

	; Update our relative sprite again:
	; - change position
	; - mirror X
	; - scale X&Y 2x
	NEXTREG $34, 2			; Select third sprite
	NEXTREG $35, 220		; X=220
	NEXTREG $36, 120		; Y=120
	NEXTREG $37, %00001010		; Palette offset, mirror X, rotate
	NEXTREG $38, %11000001		; Visible, use byte 4, pattern 1
	NEXTREG $39, %00101010		; Anchor with unified relatives, scale X&Y 

.infiniteLoop:
	JR .infiniteLoop

	RET

delay:
	LD B, 5
.outer:
	LD HL, $FFFF
.inner:
	DEC HL
	LD A, H
	OR L
	JR NZ, .inner
	DJNZ .outer
	RET

;---------------------------------------------------------------------
; HL = address of sprite sheet in memory
; BC = number of bytes to load
; A  = index of first sprite to load int5o
loadSprites:
	LD BC, $303B			; Prepare port for sprite index
	OUT (C), A			; Load index of first sprite
	LD (.dmaSource), HL		; Copy sprite sheet address from HL
	LD (.dmaLength), BC		; Copy length in bytes from BC
	LD HL, .dmaCode			; Setup source for OTIR
	LD B, .dmaCodeLength		; Setup length for OTIR
	LD C, $6B			; Setup DMA port
	OTIR				; Invoke DMA code
	RET
.dmaCode:
	DB %10000011			; Disable DMA
	DB %01111101			; WR0 transfer mode, A->B, write adress + block length
.dmaSource:
	DW 0				; WR0 port A, source address
.dmaLength:
	DW 0				; WR0 block length in bytes
	DB %01010100			; WR1 read A, increment, to memory, bitmaks
	DB %00000010			; WR1 cycle port A length
	DB %01101000			; WR2 write B, port B address fixed, B is IO
	DB %00000010			; WR2 cycle length B
	DB %10101101			; WR4 continuous mode, write destination address
	DW $5B				; Sprite image port $xx5B
	DB %10000010			; WR5 restart on end of block
	DB %11001111			; WR6 load
	DB %10000111			; WR6 enable DMA
.dmaCodeLength:  EQU $-.dmaCode

;;--------------------------------------------------------------------
;; data
;;--------------------------------------------------------------------

sprites:
	INCBIN "sprites.spr"

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

