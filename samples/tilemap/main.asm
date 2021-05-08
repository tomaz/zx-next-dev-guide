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

START_OF_BANK_5		EQU $4000
START_OF_TILEMAP	EQU $6000	; Just after ULA attributes
START_OF_TILES		EQU $6600	; Just after 40x32 tilemap

OFFSET_OF_MAP		EQU (START_OF_TILEMAP - START_OF_BANK_5) >> 8
OFFSET_OF_TILES		EQU (START_OF_TILES - START_OF_BANK_5) >> 8

start:
	; Enable tilemap mode
	NEXTREG $6B, %10100001		; 40x32, 8-bit entries
	NEXTREG $6C, %00000000		; palette offset, visuals

	; Tell harware where to find tiles
	NEXTREG $6E, OFFSET_OF_MAP	; MSB of tilemap in bank 5
	NEXTREG $6F, OFFSET_OF_TILES	; MSB of tilemap definitions

	; Setup tilemap palette
	NEXTREG $43, %00110000		; Auto increment, select first tilemap palette
	NEXTREG $40, 0			; Start with first entry

	; Copy palette
	LD HL, palette			; Address of palette data in memory
	LD B, 16			; Copy 16 colours
	CALL copyPalette		; Call routine for copying

	; Copy tile definitions to expected memory
	LD HL, tiles			; Address of tiles in memory
	LD BC, tilesLength		; Number of bytes to copy
	CALL copyTileDefinitions	; Copy all tiles data

	; Copy tilemap to expected memory
	LD HL, tilemap			; Addreess of tilemap in memory
	CALL copyTileMap40x32		; Copy 40x32 tilemaps

	; Give it some time
	CALL delay
	CALL delay
	CALL delay
	CALL delay

	; Then use offset registers to simulate shake.
	LD A, 1				; Offset by 1 pixel
	LD B, 40			; Number of repetitions
.shakeLoop:
	NEXTREG $30, A			; Set current offset
	LD HL, 5000
	CALL customDelay
	XOR 1				; Change offset: if 0 to 1, then back to 0
	DJNZ .shakeLoop

	
.infiniteLoop:
	JR .infiniteLoop

	RET

delay:
	LD HL, $FFFF
customDelay:
	PUSH AF
.loop:
	DEC HL
	LD A, H
	OR L
	JR NZ, .loop

	POP AF
	RET

;;--------------------------------------------------------------------
;; subroutines
;;--------------------------------------------------------------------

;---------------------------------------------------------------------
; HL = memory location of the palette
copyPalette256:
	LD B, 0			; This variant always starts with 0
;---------------------------------------------------------------------
; HL = memory location of the palette
; B = number of colours to copy
copyPalette:
	LD A, (HL)		; Load RRRGGGBB into A
	INC HL			; Increment to next entry
	NEXTREG $41, A		; Send entry to Next HW
	DJNZ copyPalette	; Repeat until B=0
	RET

;---------------------------------------------------------------------
; HL = memory location of tile definitons
; BC = size of tile defitions in bytes.
copyTileDefinitions:
	LD DE, START_OF_TILES
	LDIR
	RET

;---------------------------------------------------------------------
; HL = memory location of tilemap
copyTileMap40x32:
	LD BC, 40*32		; This variant always load 40x32
	JR copyTileMap
copyTileMap80x32:
	LD BC, 80*32		; This variant always loads 80x32
;---------------------------------------------------------------------
; HL = memory location of tilemap
; BC = size of tilemap in bytes
copyTileMap:
	LD DE, START_OF_TILEMAP
	LDIR
	RET

;;--------------------------------------------------------------------
;; data
;;--------------------------------------------------------------------

; Note: all files created with https://zx.remysharp.com/sprites/#sprite-editor
; See individual notes besides each entry below:

; Tilemap settings: 8px, 40x32, disable "include header" when downloading, file is then usabe as is.
tilemap:
	INCBIN "tiles.map"
tilemapLength: EQU $ - tilemap

; Sprite Editor settings: 4bit, after downloading manually removed empty data (with HxD) to only leave first 192 bytes.
tiles:
	INCBIN "tiles.spr"
tilesLength: EQU $ - tiles

; After setting up palette, used Download button and then manually removed every second byte (with HxD) and only left 16 entries (so 16 bytes)
palette:
	INCBIN "tiles.pal"
paletteLength: EQU $-palette

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

