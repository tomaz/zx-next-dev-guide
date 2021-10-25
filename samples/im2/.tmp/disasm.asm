L0008:
	EQU 0008h
L0018:
	EQU 0018h
L0065:
	EQU 0065h
L03B5:
	EQU 03B5h
L0D6E:
	EQU 0D6Eh
L0DAF:
	EQU 0DAFh
L0ECD:
	EQU 0ECDh
L0F2C:
	EQU 0F2Ch
L101E:
	EQU 101Eh
L11A7:
	EQU 11A7h
L12A2:
	EQU 12A2h
L12AC:
	EQU 12ACh
L155D:
	EQU 155Dh
L15D4:
	EQU 15D4h
L1664:
	EQU 1664h
L19FB:
	EQU 19FBh
L1B17:
	EQU 1B17h
L1B8A:
	EQU 1B8Ah
L1F05:
	EQU 1F05h
L5C3A:
	EQU 5C3Ah
L5C51:
	EQU 5C51h
L5C59:
	EQU 5C59h
L5C5B:
	EQU 5C5Bh
L5C5D:
	EQU 5C5Dh
L5C8C:
	EQU 5C8Ch


	ORG 0F38h


0F38
	L0F38:
0F38
	CD D4 15     CALL L15D4
0F3B
	F5 PUSH AF
0F3C
	16 00        LD   D, 00h
0F3E
	FD 5E FF     LD   E, (IY-1)
0F41
	21 C8 00     LD   HL, 00C8h
0F44
	CD B5 03     CALL L03B5
0F47
	F1 POP  AF
0F48
	21 38 0F     LD   HL, 0F38h
0F4B
	E5 PUSH HL
0F4C
	FE 18        CP   18h
0F4E
	30 31        JR   NC, L0F81
0F50
	FE 07        CP   07h
0F52
	38 2D        JR   C, L0F81
0F54
	FE 10        CP   10h
0F56
	38 3A        JR   C, L0F92
0F58
	01 02 00     LD   BC, 0002h
0F5B
	57 LD   D, A
0F5C
	FE 16        CP   16h
0F5E
	38 0C        JR   C, L0F6C
0F60
	03 INC  BC
0F61
	FD CB 37 7E  BIT  7, (IY+55)
0F65
	CA 1E 10     JP   Z, L101E
0F68
	CD D4 15     CALL L15D4
0F6B
	5F LD   E, A
0F6C
	L0F6C:
0F6C
	CD D4 15     CALL L15D4
0F6F
	D5 PUSH DE
0F70
	2A 5B 5C     LD   HL, (L5C5B)
0F73
	FD CB 07 86  RES  0, (IY+7)
0F77
	CD 55 16     CALL L1655
0F7A
	C1 POP  BC
0F7B
	23 INC  HL
0F7C
	70 LD   (HL), B
0F7D
	23 INC  HL
0F7E
	71 LD   (HL), C
0F7F
	18 0A        JR   L0F8B
0F81
	L0F81:
0F81
	FD CB 07 86  RES  0, (IY+7)
0F85
	2A 5B 5C     LD   HL, (L5C5B)
0F88
	CD 52 16     CALL L1652
0F8B
	L0F8B:
0F8B
	12 LD   (DE), A
0F8C
	13 INC  DE
0F8D
	ED 53 5B 5C  LD   (L5C5B), DE
0F91
	C9 RET
0F92
	L0F92:
0F92
	5F LD   E, A
0F93
	16 00        LD   D, 00h
0F95
	21 99 0F     LD   HL, 0F99h
0F98
	19 ADD  HL, DE
0F99
	5E LD   E, (HL)
0F9A
	19 ADD  HL, DE
0F9B
	E5 PUSH HL


	ORG 12B1h


12B1
	L12B1:
12B1
	CD 2C 0F     CALL L0F2C
12B4
	CD 17 1B     CALL L1B17
12B7
	FD CB 00 7E  BIT  7, (IY+0)
12BB
	20 12        JR   NZ, L12CF
12BD
	FD CB 30 66  BIT  4, (IY+48)
12C1
	28 40        JR   Z, L1303
12C3
	2A 59 5C     LD   HL, (L5C59)
12C6
	CD A7 11     CALL L11A7
12C9
	FD 36 00 FF  LD   (IY+0), %s
12CD
	18 DD        JR   L12AC
12CF
	L12CF:
12CF
	2A 59 5C     LD   HL, (L5C59)
12D2
	22 5D 5C     LD   (L5C5D), HL
12D5
	CD FB 19     CALL L19FB
12D8
	78 LD   A, B
12D9
	B1 OR   C
12DA
	C2 5D 15     JP   NZ, L155D
12DD
	DF RST  18h
12DE
	FE 0D        CP   0Dh
12E0
	28 C0        JR   Z, L12A2
12E2
	FD CB 30 46  BIT  0, (IY+48)
12E6
	C4 AF 0D     CALL NZ, L0DAF
12E9
	CD 6E 0D     CALL L0D6E
12EC
	3E 19        LD   A, 19h
12EE
	FD 96 4F     SUB  (IY+79)
12F1
	32 8C 5C     LD   (L5C8C), A
12F4
	FD CB 01 FE  SET  7, (IY+1)
12F8
	FD 36 00 FF  LD   (IY+0), %s
12FC
	FD 36 0A 01  LD   (IY+10), %s
1300
	CD 8A 1B     CALL L1B8A
1303
	L1303:
1303
	76 HALT
1304
	FD CB 01 AE  RES  5, (IY+1)
1308
	FD CB 30 4E  BIT  1, (IY+48)
130C
	C4 CD 0E     CALL NZ, L0ECD
130F
	3A 3A 5C     LD   A, (L5C3A)
1312
	3C INC  A
1313
	F5 PUSH AF
1314
	21 00 00     LD   HL, 0000h


	ORG 15DEh
15DE
	L15DE:
15DE
	CD E6 15     CALL L15E6
15E1
	D8 RET  C
15E2
	28 FA        JR   Z, L15DE
15E4
	CF 07        RST  08h, 07h


15E6
	L15E6:
15E6
	D9 EXX
15E7
	E5 PUSH HL
15E8
	2A 51 5C     LD   HL, (L5C51)
15EB
	23 INC  HL
15EC
	23 INC  HL
15ED
	18 08        JR   L15F7


15EF
	1E defb 1Eh
15F0
	30 defb 30h
15F1
	83 defb 83h
15F2
	D9 defb D9h
15F3
	E5 defb E5h
15F4
	2A defb 2Ah
15F5
	51 defb 51h
15F6
	5C defb 5Ch


15F7
	L15F7:
15F7
	5E LD   E, (HL)
15F8
	23 INC  HL
15F9
	56 LD   D, (HL)
15FA
	EB EX   DE, HL
15FB
	CD 2C 16     CALL L162C
15FE
	E1 POP  HL
15FF
	D9 EXX
1600
	C9 RET


1601
	87 defb 87h
1602
	C6 defb C6h
1603
	16 defb 16h
1604
	6F defb 6Fh
1605
	26 defb 26h
1606
	5C defb 5Ch
1607
	5E defb 5Eh
1608
	23 defb 23h
1609
	56 defb 56h
160A
	7A defb 7Ah
160B
	B3 defb B3h
160C
	20 defb 20h
160D
	02 defb 02h
160E
	CF defb CFh
160F
	17 defb 17h
1610
	1B defb 1Bh
1611
	2A defb 2Ah
1612
	4F defb 4Fh
1613
	5C defb 5Ch
1614
	19 defb 19h
1615
	22 defb 22h
1616
	51 defb 51h
1617
	5C defb 5Ch
1618
	FD defb FDh
1619
	CB defb CBh
161A
	30 defb 30h
161B
	A6 defb A6h
161C
	23 defb 23h
161D
	23 defb 23h
161E
	23 defb 23h
161F
	23 defb 23h
1620
	4E defb 4Eh
1621
	21 defb 21h
1622
	2D defb 2Dh
1623
	16 defb 16h
1624
	CD defb CDh
1625
	DC defb DCh
1626
	16 defb 16h
1627
	D0 defb D0h
1628
	16 defb 16h
1629
	00 defb 00h
162A
	5E defb 5Eh
162B
	19 defb 19h


162C
	L162C:
162C
	E9 JP   (HL)


162D
	4B defb 4Bh
162E
	06 defb 06h
162F
	53 defb 53h
1630
	12 defb 12h
1631
	50 defb 50h
1632
	1B defb 1Bh
1633
	00 defb 00h
1634
	FD defb FDh
1635
	CB defb CBh
1636
	02 defb 02h
1637
	C6 defb C6h
1638
	FD defb FDh
1639
	CB defb CBh
163A
	01 defb 01h
163B
	AE defb AEh
163C
	FD defb FDh
163D
	CB defb CBh
163E
	30 defb 30h
163F
	E6 defb E6h
1640
	18 defb 18h
1641
	04 defb 04h
1642
	FD defb FDh
1643
	CB defb CBh
1644
	02 defb 02h
1645
	86 defb 86h
1646
	FD defb FDh
1647
	CB defb CBh
1648
	01 defb 01h
1649
	8E defb 8Eh
164A
	C3 defb C3h
164B
	4D defb 4Dh
164C
	0D defb 0Dh
164D
	FD defb FDh
164E
	CB defb CBh
164F
	01 defb 01h
1650
	CE defb CEh
1651
	C9 defb C9h


1652
	L1652:
1652
	01 01 00     LD   BC, 0001h


1655
	L1655:
1655
	E5 PUSH HL
1656
	CD 05 1F     CALL L1F05
1659
	E1 POP  HL
165A
	CD 64 16     CALL L1664
165D
	2A 65 00     LD   HL, (L0065)