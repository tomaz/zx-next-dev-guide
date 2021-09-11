L0021:
	EQU 0021h
L2371:
	EQU 2371h
L23E1:
	EQU 23E1h
L5C36:
	EQU 5C36h
L801C:
	EQU 801Ch
LFF28:
	EQU FF28h


	ORG 23FBh


23FB
	L23FB:
23FB
	CD 71 23     CALL L2371
23FE
	ED 5B 36 5C  LD   DE, (L5C36)
2402
	19 ADD  HL, DE
2403
	D1 POP  DE
2404
	CD 28 FF     CALL LFF28
2407
	18 47        JR   L2450


2409
	FE defb FEh
240A
	90 defb 90h
240B
	30 defb 30h
240C
	04 defb 04h
240D
	D6 defb D6h
240E
	7F defb 7Fh
240F
	18 defb 18h
2410
	11 defb 11h
2411
	D6 defb D6h
2412
	90 defb 90h
2413
	CD defb CDh
2414
	71 defb 71h
2415
	23 defb 23h
2416
	D1 defb D1h
2417
	CD defb CDh
2418
	20 defb 20h
2419
	1F defb 1Fh
241A
	D5 defb D5h
241B
	ED defb EDh
241C
	5B defb 5Bh
241D
	7B defb 7Bh
241E
	5C defb 5Ch
241F
	37 defb 37h
2420
	18 defb 18h
2421
	07 defb 07h
2422
	11 defb 11h
2423
	2F defb 2Fh
2424
	25 defb 25h
2425
	CD defb CDh
2426
	71 defb 71h
2427
	23 defb 23h
2428
	A7 defb A7h
2429
	08 defb 08h
242A
	19 defb 19h
242B
	D1 defb D1h
242C
	4A defb 4Ah
242D
	7E defb 7Eh
242E
	12 defb 12h
242F
	23 defb 23h
2430
	14 defb 14h
2431
	7E defb 7Eh
2432
	12 defb 12h
2433
	23 defb 23h
2434
	14 defb 14h
2435
	7E defb 7Eh
2436
	12 defb 12h
2437
	23 defb 23h
2438
	14 defb 14h
2439
	7E defb 7Eh
243A
	12 defb 12h
243B
	23 defb 23h
243C
	14 defb 14h
243D
	7E defb 7Eh
243E
	12 defb 12h
243F
	23 defb 23h
2440
	14 defb 14h
2441
	7E defb 7Eh
2442
	12 defb 12h
2443
	23 defb 23h
2444
	14 defb 14h
2445
	7E defb 7Eh
2446
	12 defb 12h
2447
	23 defb 23h
2448
	14 defb 14h
2449
	7E defb 7Eh
244A
	12 defb 12h
244B
	51 defb 51h
244C
	08 defb 08h
244D
	DC defb DCh
244E
	45 defb 45h
244F
	1F defb 1Fh


2450
	L2450:
2450
	E1 POP  HL
2451
	23 INC  HL
2452
	13 INC  DE
2453
	10 8C        DJNZ L23E1
2455
	C9 RET


2456
	C5 defb C5h
2457
	F3 defb F3h
2458
	01 defb 01h
2459
	FD defb FDh
245A
	7F defb 7Fh
245B
	3A defb 3Ah
245C
	5C defb 5Ch
245D
	5B defb 5Bh
245E
	EE defb EEh


	ORG 3BFDh


3BFD
	L3BFD:
3BFD
	FC 21 00     CALL M, L0021
3C00
	00 NOP
3C01
	11 00 08     LD   DE, 0800h
3C04
	01 FE BF     LD   BC, BFFEh
3C07
	ED 78        IN   A, (C)
3C09
	CB 47        BIT  0, A
3C0B
	28 49        JR   Z, L3C56
3C0D
	06 7F        LD   B, 7Fh
3C0F
	ED 78        IN   A, (C)
3C11
	CB 47        BIT  0, A
3C13
	28 41        JR   Z, L3C56
3C15
	06 F7        LD   B, F7h
3C17
	ED 78        IN   A, (C)
3C19
	CB 47        BIT  0, A
3C1B
	28 39        JR   Z, L3C56
3C1D
	L3C1D:
3C1D
	1B DEC  DE
3C1E
	7A LD   A, D
3C1F
	B3 OR   E
3C20
	28 09        JR   Z, L3C2B
3C22
	DB FE        IN   A, (00FEh)
3C24
	E6 40        AND  40h
3C26
	28 F5        JR   Z, L3C1D
3C28
	23 INC  HL
3C29
	18 F2        JR   L3C1D
3C2B
	L3C2B:
3C2B
	CB 15        RL   L
3C2D
	CB 14        RL   H
3C2F
	CB 15        RL   L
3C31
	CB 14        RL   H
3C33
	08 EX   AF, AF'
3C34
	28 07        JR   Z, L3C3D
3C36
	08 EX   AF, AF'
3C37
	3E 20        LD   A, 20h
3C39
	94 SUB  H
3C3A
	6F LD   L, A
3C3B
	18 02        JR   L3C3F
3C3D
	L3C3D:
3C3D
	08 EX   AF, AF'
3C3E
	6C LD   L, H
3C3F
	L3C3F:
3C3F
	AF XOR  A
3C40
	67 LD   H, A
3C41
	11 1F 59     LD   DE, 591Fh
3C44
	06 20        LD   B, 20h
3C46
	3E 48        LD   A, 48h
3C48
	FB EI
3C49
	76 HALT
3C4A
	F3 DI
3C4B
	L3C4B:
3C4B
	12 LD   (DE), A
3C4C
	1B DEC  DE
3C4D
	10 FC        DJNZ L3C4B
3C4F
	13 INC  DE
3C50
	19 ADD  HL, DE
3C51
	3E 68        LD   A, 68h
3C53
	77 LD   (HL), A
3C54
	18 A8        JR   L3BFD+1
3C56
	L3C56:
3C56
	FB EI
3C57
	06 19        LD   B, 19h
3C59
	L3C59:
3C59
	76 HALT
3C5A
	10 FD        DJNZ L3C59
3C5C
	21 3B 5C     LD   HL, 5C3Bh
3C5F
	CB AE        RES  5, (HL)


	ORG 8000h


8000
	L8000:
8000
	ED 91 07 03  NEXTREG REG_TURBO_MODE, RTM_28MHZ
8004
	F3 DI
8005
	ED 91 C0 61  NEXTREG C0h, 61h
8009
	ED 91 C4 81  NEXTREG C4h, 81h
800D
	ED 91 C5 00  NEXTREG C5h, 00h
8011
	ED 91 C6 00  NEXTREG C6h, 00h


	ORG 8023h


8023
	L8023:
8023
	C3 1C 80     JP   L801C


8026
	C9 defb C9h
8027
	06 defb 06h
8028
	FF defb FFh
8029
	00 defb 00h
802A
	00 defb 00h
802B
	00 defb 00h
802C
	00 defb 00h
802D
	10 defb 10h
802E
	FA defb FAh
802F
	C9 defb C9h
8030
	0E defb 0Eh
8031
	40 defb 40h
8032
	CD defb CDh
8033
	27 defb 27h
8034
	80 defb 80h
8035
	0D defb 0Dh
8036
	C2 defb C2h