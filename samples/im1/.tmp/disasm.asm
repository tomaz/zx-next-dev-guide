L1C8A:
	EQU 1C8Ah
L24FB:
	EQU 24FBh
L2684:
	EQU 2684h


	ORG 16DBh


16DB
	L16DB:
16DB
	23 INC  HL


16DC
	L16DC:
16DC
	7E LD   A, (HL)
16DD
	A7 AND  A
16DE
	C8 RET  Z
16DF
	B9 CP   C
16E0
	23 INC  HL
16E1
	20 F8        JR   NZ, L16DB
16E3
	37 SCF
16E4
	C9 RET


16E5
	CD defb CDh
16E6
	1E defb 1Eh
16E7
	17 defb 17h
16E8
	CD defb CDh
16E9
	01 defb 01h
16EA
	17 defb 17h
16EB
	01 defb 01h
16EC
	00 defb 00h
16ED
	00 defb 00h
16EE
	11 defb 11h
16EF
	E2 defb E2h
16F0
	A3 defb A3h
16F1
	EB defb EBh
16F2
	19 defb 19h
16F3
	38 defb 38h
16F4
	07 defb 07h
16F5
	01 defb 01h
16F6
	D4 defb D4h
16F7
	15 defb 15h
16F8
	09 defb 09h
16F9
	4E defb 4Eh
16FA
	23 defb 23h
16FB
	46 defb 46h
16FC
	EB defb EBh
16FD
	71 defb 71h
16FE
	23 defb 23h
16FF
	70 defb 70h
1700
	C9 defb C9h
1701
	E5 defb E5h
1702
	2A defb 2Ah
1703
	4F defb 4Fh
1704
	5C defb 5Ch
1705
	09 defb 09h
1706
	23 defb 23h
1707
	23 defb 23h
1708
	23 defb 23h
1709
	4E defb 4Eh
170A
	EB defb EBh
170B
	21 defb 21h
170C
	16 defb 16h
170D
	17 defb 17h
170E
	CD defb CDh
170F
	DC defb DCh
1710
	16 defb 16h
1711
	4E defb 4Eh
1712
	06 defb 06h
1713
	00 defb 00h
1714
	09 defb 09h
1715
	E9 defb E9h
1716
	4B defb 4Bh
1717
	05 defb 05h
1718
	53 defb 53h
1719
	03 defb 03h
171A
	50 defb 50h
171B
	01 defb 01h
171C
	E1 defb E1h
171D
	C9 defb C9h
171E
	CD defb CDh
171F
	94 defb 94h
1720
	1E defb 1Eh
1721
	FE defb FEh
1722
	10 defb 10h
1723
	38 defb 38h
1724
	02 defb 02h
1725
	CF defb CFh
1726
	17 defb 17h
1727
	C6 defb C6h
1728
	03 defb 03h
1729
	07 defb 07h
172A
	21 defb 21h
172B
	10 defb 10h
172C
	5C defb 5Ch
172D
	4F defb 4Fh
172E
	06 defb 06h
172F
	00 defb 00h
1730
	09 defb 09h
1731
	4E defb 4Eh
1732
	23 defb 23h
1733
	46 defb 46h
1734
	2B defb 2Bh
1735
	C9 defb C9h
1736
	EF defb EFh
1737
	01 defb 01h
1738
	38 defb 38h
1739
	CD defb CDh
173A
	1E defb 1Eh
173B
	17 defb 17h
173C
	78 defb 78h
173D
	B1 defb B1h
173E
	28 defb 28h


	ORG 1C8Ch


1C8C
	L1C8C:
1C8C
	CD FB 24     CALL L24FB
1C8F
	FD CB 01 76  BIT  6, (IY+1)
1C93
	C8 RET  Z
1C94
	18 F4        JR   L1C8A


1C96
	FD defb FDh
1C97
	CB defb CBh
1C98
	01 defb 01h
1C99
	7E defb 7Eh
1C9A
	FD defb FDh
1C9B
	CB defb CBh
1C9C
	02 defb 02h
1C9D
	86 defb 86h
1C9E
	C4 defb C4h
1C9F
	4D defb 4Dh
1CA0
	0D defb 0Dh
1CA1
	F1 defb F1h
1CA2
	3A defb 3Ah
1CA3
	74 defb 74h
1CA4
	5C defb 5Ch
1CA5
	D6 defb D6h
1CA6
	13 defb 13h
1CA7
	CD defb CDh
1CA8
	FC defb FCh
1CA9
	21 defb 21h
1CAA
	CD defb CDh
1CAB
	EE defb EEh
1CAC
	1B defb 1Bh
1CAD
	2A defb 2Ah
1CAE
	8F defb 8Fh
1CAF
	5C defb 5Ch
1CB0
	22 defb 22h
1CB1
	8D defb 8Dh
1CB2
	5C defb 5Ch
1CB3
	21 defb 21h
1CB4
	91 defb 91h
1CB5
	5C defb 5Ch
1CB6
	7E defb 7Eh
1CB7
	07 defb 07h
1CB8
	AE defb AEh
1CB9
	E6 defb E6h
1CBA
	AA defb AAh
1CBB
	AE defb AEh
1CBC
	77 defb 77h
1CBD
	C9 defb C9h
1CBE
	CD defb CDh
1CBF
	30 defb 30h
1CC0
	25 defb 25h
1CC1
	28 defb 28h
1CC2
	13 defb 13h
1CC3
	FD defb FDh
1CC4
	CB defb CBh
1CC5
	02 defb 02h
1CC6
	86 defb 86h
1CC7
	CD defb CDh
1CC8
	4D defb 4Dh
1CC9
	0D defb 0Dh
1CCA
	21 defb 21h
1CCB
	90 defb 90h
1CCC
	5C defb 5Ch
1CCD
	7E defb 7Eh
1CCE
	F6 defb F6h
1CCF
	F8 defb F8h
1CD0
	77 defb 77h
1CD1
	FD defb FDh
1CD2
	CB defb CBh
1CD3
	57 defb 57h
1CD4
	B6 defb B6h
1CD5
	DF defb DFh
1CD6
	CD defb CDh
1CD7
	E2 defb E2h
1CD8
	21 defb 21h
1CD9
	18 defb 18h
1CDA
	9F defb 9Fh
1CDB
	C3 defb C3h
1CDC
	05 defb 05h
1CDD
	06 defb 06h
1CDE
	FE defb FEh
1CDF
	0D defb 0Dh
1CE0
	28 defb 28h
1CE1
	04 defb 04h
1CE2
	FE defb FEh
1CE3
	3A defb 3Ah
1CE4
	20 defb 20h
1CE5
	9C defb 9Ch
1CE6
	CD defb CDh
1CE7
	30 defb 30h
1CE8
	25 defb 25h
1CE9
	C8 defb C8h
1CEA
	EF defb EFh
1CEB
	A0 defb A0h
1CEC
	38 defb 38h
1CED
	C9 defb C9h
1CEE
	CF defb CFh
1CEF
	08 defb 08h


	ORG 2503h


2503
	L2503:
2503
	CD DC 16     CALL L16DC
2506
	79 LD   A, C
2507
	D2 84 26     JP   NC, L2684
250A
	06 00        LD   B, 00h
250C
	4E LD   C, (HL)
250D
	09 ADD  HL, BC
250E
	E9 JP   (HL)


250F
	CD defb CDh
2510
	74 defb 74h
2511
	00 defb 00h
2512
	03 defb 03h
2513
	FE defb FEh
2514
	0D defb 0Dh
2515
	CA defb CAh
2516
	8A defb 8Ah
2517
	1C defb 1Ch
2518
	FE defb FEh
2519
	22 defb 22h
251A
	20 defb 20h
251B
	F3 defb F3h
251C
	CD defb CDh
251D
	74 defb 74h
251E
	00 defb 00h
251F
	FE defb FEh
2520
	22 defb 22h
2521
	C9 defb C9h
2522
	E7 defb E7h
2523
	FE defb FEh
2524
	28 defb 28h
2525
	20 defb 20h
2526
	06 defb 06h
2527
	CD defb CDh
2528
	79 defb 79h
2529
	1C defb 1Ch
252A
	DF defb DFh
252B
	FE defb FEh
252C
	29 defb 29h
252D
	C2 defb C2h
252E
	8A defb 8Ah
252F
	1C defb 1Ch
2530
	FD defb FDh
2531
	CB defb CBh
2532
	01 defb 01h
2533
	7E defb 7Eh
2534
	C9 defb C9h
2535
	CD defb CDh
2536
	07 defb 07h
2537
	23 defb 23h
2538
	2A defb 2Ah
2539
	36 defb 36h
253A
	5C defb 5Ch
253B
	11 defb 11h
253C
	00 defb 00h
253D
	01 defb 01h
253E
	19 defb 19h
253F
	79 defb 79h
2540
	0F defb 0Fh
2541
	0F defb 0Fh
2542
	0F defb 0Fh
2543
	E6 defb E6h
2544
	E0 defb E0h
2545
	A8 defb A8h
2546
	5F defb 5Fh
2547
	79 defb 79h
2548
	E6 defb E6h
2549
	18 defb 18h
254A
	EE defb EEh
254B
	40 defb 40h
254C
	57 defb 57h
254D
	06 defb 06h
254E
	60 defb 60h
254F
	C5 defb C5h
2550
	D5 defb D5h
2551
	E5 defb E5h
2552
	1A defb 1Ah
2553
	AE defb AEh
2554
	28 defb 28h
2555
	04 defb 04h
2556
	3C defb 3Ch
2557
	20 defb 20h
2558
	1A defb 1Ah
2559
	3D defb 3Dh
255A
	4F defb 4Fh
255B
	06 defb 06h
255C
	07 defb 07h
255D
	14 defb 14h
255E
	23 defb 23h
255F
	1A defb 1Ah
2560
	AE defb AEh
2561
	A9 defb A9h
2562
	20 defb 20h
2563
	0F defb 0Fh
2564
	10 defb 10h
2565
	F7 defb F7h
2566
	C1 defb C1h


	ORG 8000h


8000
	L8000:
8000
	F0 RET  P
8001
	00 NOP
8002
	8F ADC  A, A
8003
	1C INC  E
8004
	F0 RET  P
8005
	00 NOP
8006
	8F ADC  A, A
8007
	1C INC  E
8008
	F0 RET  P
8009
	00 NOP
800A
	8F ADC  A, A
800B
	1C INC  E
800C
	F0 RET  P
800D
	00 NOP
800E
	8F ADC  A, A
800F
	1C INC  E
8010
	F0 RET  P
8011
	00 NOP
8012
	8F ADC  A, A
8013
	1C INC  E