L0008:       equ  0008h
L0018:       equ  0018h
L02BF:       equ  02BFh
L034F:       equ  034Fh
L0367:       equ  0367h
L03B5:       equ  03B5h
L0D6E:       equ  0D6Eh
L0DAF:       equ  0DAFh
L0ECD:       equ  0ECDh
L0F2C:       equ  0F2Ch
L101E:       equ  101Eh
L11A7:       equ  11A7h
L12A2:       equ  12A2h
L12AC:       equ  12ACh
L155D:       equ  155Dh
L15D4:       equ  15D4h
L1664:       equ  1664h
L19FB:       equ  19FBh
L1B17:       equ  1B17h
L1B8A:       equ  1B8Ah
L1F05:       equ  1F05h
L5C08:       equ  5C08h
L5C09:       equ  5C09h
L5C0A:       equ  5C0Ah
L5C3A:       equ  5C3Ah
L5C51:       equ  5C51h
L5C59:       equ  5C59h
L5C5B:       equ  5C5Bh
L5C5D:       equ  5C5Dh
L5C8C:       equ  5C8Ch


             org 004Ah


004A L004A:
004A CD BF 02     CALL L02BF  
004D D1           POP  DE     
004E C1           POP  BC     
004F E1           POP  HL     
0050 F1           POP  AF     
0051 FB           EI          
0052 C9           RET         


0053 E1           defb E1h    
0054 6E           defb 6Eh    
0055 FD           defb FDh    
0056 75           defb 75h    
0057 00           defb 00h    
0058 ED           defb EDh    
0059 7B           defb 7Bh    
005A 3D           defb 3Dh    
005B 5C           defb 5Ch    
005C C3           defb C3h    
005D C5           defb C5h    
005E 16           defb 16h    
005F FF           defb FFh    
0060 FF           defb FFh    
0061 FF           defb FFh    
0062 FF           defb FFh    
0063 FF           defb FFh    
0064 FF           defb FFh    


0065 L0065:
0065 FF           defb FFh    
0066 F5           defb F5h    
0067 E5           defb E5h    
0068 2A           defb 2Ah    
0069 B0           defb B0h    
006A 5C           defb 5Ch    
006B 7C           defb 7Ch    
006C B5           defb B5h    
006D 20           defb 20h    
006E 01           defb 01h    
006F E9           defb E9h    
0070 E1           defb E1h    
0071 F1           defb F1h    
0072 ED           defb EDh    
0073 45           defb 45h    
0074 2A           defb 2Ah    
0075 5D           defb 5Dh    
0076 5C           defb 5Ch    
0077 23           defb 23h    
0078 22           defb 22h    
0079 5D           defb 5Dh    
007A 5C           defb 5Ch    
007B 7E           defb 7Eh    
007C C9           defb C9h    
007D FE           defb FEh    
007E 21           defb 21h    
007F D0           defb D0h    
0080 FE           defb FEh    
0081 0D           defb 0Dh    
0082 C8           defb C8h    
0083 FE           defb FEh    
0084 10           defb 10h    
0085 D8           defb D8h    
0086 FE           defb FEh    
0087 18           defb 18h    
0088 3F           defb 3Fh    
0089 D8           defb D8h    
008A 23           defb 23h    
008B FE           defb FEh    
008C 16           defb 16h    
008D 38           defb 38h    
008E 01           defb 01h    
008F 23           defb 23h    
0090 37           defb 37h    
0091 22           defb 22h    
0092 5D           defb 5Dh    
0093 5C           defb 5Ch    
0094 C9           defb C9h    
0095 BF           defb BFh    
0096 52           defb 52h    
0097 4E           defb 4Eh    
0098 C4           defb C4h    
0099 49           defb 49h    
009A 4E           defb 4Eh    
009B 4B           defb 4Bh    
009C 45           defb 45h    
009D 59           defb 59h    
009E A4           defb A4h    
009F 50           defb 50h    
00A0 C9           defb C9h    
00A1 46           defb 46h    
00A2 CE           defb CEh    
00A3 50           defb 50h    
00A4 4F           defb 4Fh    
00A5 49           defb 49h    
00A6 4E           defb 4Eh    
00A7 D4           defb D4h    
00A8 53           defb 53h    
00A9 43           defb 43h    
00AA 52           defb 52h    
00AB 45           defb 45h    
00AC 45           defb 45h    
00AD 4E           defb 4Eh    


             org 02D8h


02D8 L02D8:
02D8 CD 1E 03     CALL L031E  
02DB D0           RET  NC     
02DC 21 00 5C     LD   HL,5C00h 
02DF BE           CP   (HL)   
02E0 28 2E        JR   Z,L0310 
02E2 EB           EX   DE,HL  
02E3 21 04 5C     LD   HL,5C04h 
02E6 BE           CP   (HL)   
02E7 28 27        JR   Z,L0310 
02E9 CB 7E        BIT  7,(HL) 
02EB 20 04        JR   NZ,L02F1 
02ED EB           EX   DE,HL  
02EE CB 7E        BIT  7,(HL) 
02F0 C8           RET  Z      
02F1 L02F1:
02F1 5F           LD   E,A    
02F2 77           LD   (HL),A 
02F3 23           INC  HL     
02F4 36 05        LD   (HL),05h 
02F6 23           INC  HL     
02F7 3A 09 5C     LD   A,(L5C09) 
02FA 77           LD   (HL),A 
02FB 23           INC  HL     
02FC FD 4E 07     LD   C,(IY+7) 
02FF FD 56 01     LD   D,(IY+1) 
0302 E5           PUSH HL     
0303 CD 33 03     CALL L0333  
0306 E1           POP  HL     
0307 77           LD   (HL),A 
0308 L0308:
0308 32 08 5C     LD   (L5C08),A 
030B FD CB 01 EE  SET  5,(IY+1) 
030F C9           RET         
0310 L0310:
0310 23           INC  HL     
0311 36 05        LD   (HL),05h 
0313 23           INC  HL     
0314 35           DEC  (HL)   
0315 C0           RET  NZ     
0316 3A 0A 5C     LD   A,(L5C0A) 
0319 77           LD   (HL),A 
031A 23           INC  HL     
031B 7E           LD   A,(HL) 
031C 18 EA        JR   L0308  


031E L031E:
031E 42           LD   B,D    
031F 16 00        LD   D,00h  
0321 7B           LD   A,E    
0322 FE 27        CP   27h    
0324 D0           RET  NC     
0325 FE 18        CP   18h    
0327 20 03        JR   NZ,L032C 
0329 CB 78        BIT  7,B    
032B C0           RET  NZ     
032C L032C:
032C 21 05 02     LD   HL,0205h 
032F 19           ADD  HL,DE  
0330 7E           LD   A,(HL) 
0331 37           SCF         
0332 C9           RET         


0333 L0333:
0333 7B           LD   A,E    
0334 FE 3A        CP   3Ah    
0336 38 2F        JR   C,L0367 
0338 0D           DEC  C      
0339 FA 4F 03     JP   M,L034F 


             org 0F38h


0F38 L0F38:
0F38 CD D4 15     CALL L15D4  
0F3B F5           PUSH AF     
0F3C 16 00        LD   D,00h  
0F3E FD 5E FF     LD   E,(IY-1) 
0F41 21 C8 00     LD   HL,00C8h 
0F44 CD B5 03     CALL L03B5  
0F47 F1           POP  AF     
0F48 21 38 0F     LD   HL,0F38h 
0F4B E5           PUSH HL     
0F4C FE 18        CP   18h    
0F4E 30 31        JR   NC,L0F81 
0F50 FE 07        CP   07h    
0F52 38 2D        JR   C,L0F81 
0F54 FE 10        CP   10h    
0F56 38 3A        JR   C,L0F92 
0F58 01 02 00     LD   BC,0002h 
0F5B 57           LD   D,A    
0F5C FE 16        CP   16h    
0F5E 38 0C        JR   C,L0F6C 
0F60 03           INC  BC     
0F61 FD CB 37 7E  BIT  7,(IY+55) 
0F65 CA 1E 10     JP   Z,L101E 
0F68 CD D4 15     CALL L15D4  
0F6B 5F           LD   E,A    
0F6C L0F6C:
0F6C CD D4 15     CALL L15D4  
0F6F D5           PUSH DE     
0F70 2A 5B 5C     LD   HL,(L5C5B) 
0F73 FD CB 07 86  RES  0,(IY+7) 
0F77 CD 55 16     CALL L1655  
0F7A C1           POP  BC     
0F7B 23           INC  HL     
0F7C 70           LD   (HL),B 
0F7D 23           INC  HL     
0F7E 71           LD   (HL),C 
0F7F 18 0A        JR   L0F8B  
0F81 L0F81:
0F81 FD CB 07 86  RES  0,(IY+7) 
0F85 2A 5B 5C     LD   HL,(L5C5B) 
0F88 CD 52 16     CALL L1652  
0F8B L0F8B:
0F8B 12           LD   (DE),A 
0F8C 13           INC  DE     
0F8D ED 53 5B 5C  LD   (L5C5B),DE 
0F91 C9           RET         
0F92 L0F92:
0F92 5F           LD   E,A    
0F93 16 00        LD   D,00h  
0F95 21 99 0F     LD   HL,0F99h 
0F98 19           ADD  HL,DE  
0F99 5E           LD   E,(HL) 
0F9A 19           ADD  HL,DE  
0F9B E5           PUSH HL     


             org 12B1h


12B1 L12B1:
12B1 CD 2C 0F     CALL L0F2C  
12B4 CD 17 1B     CALL L1B17  
12B7 FD CB 00 7E  BIT  7,(IY+0) 
12BB 20 12        JR   NZ,L12CF 
12BD FD CB 30 66  BIT  4,(IY+48) 
12C1 28 40        JR   Z,L1303 
12C3 2A 59 5C     LD   HL,(L5C59) 
12C6 CD A7 11     CALL L11A7  
12C9 FD 36 00 FF  LD   (IY+0),%s 
12CD 18 DD        JR   L12AC  
12CF L12CF:
12CF 2A 59 5C     LD   HL,(L5C59) 
12D2 22 5D 5C     LD   (L5C5D),HL 
12D5 CD FB 19     CALL L19FB  
12D8 78           LD   A,B    
12D9 B1           OR   C      
12DA C2 5D 15     JP   NZ,L155D 
12DD DF           RST  18h    
12DE FE 0D        CP   0Dh    
12E0 28 C0        JR   Z,L12A2 
12E2 FD CB 30 46  BIT  0,(IY+48) 
12E6 C4 AF 0D     CALL NZ,L0DAF 
12E9 CD 6E 0D     CALL L0D6E  
12EC 3E 19        LD   A,19h  
12EE FD 96 4F     SUB  (IY+79) 
12F1 32 8C 5C     LD   (L5C8C),A 
12F4 FD CB 01 FE  SET  7,(IY+1) 
12F8 FD 36 00 FF  LD   (IY+0),%s 
12FC FD 36 0A 01  LD   (IY+10),%s 
1300 CD 8A 1B     CALL L1B8A  
1303 L1303:
1303 76           HALT        
1304 FD CB 01 AE  RES  5,(IY+1) 
1308 FD CB 30 4E  BIT  1,(IY+48) 
130C C4 CD 0E     CALL NZ,L0ECD 
130F 3A 3A 5C     LD   A,(L5C3A) 
1312 3C           INC  A      
1313 F5           PUSH AF     
1314 21 00 00     LD   HL,0000h 


             org 15DEh
15DE L15DE:
15DE CD E6 15     CALL L15E6  
15E1 D8           RET  C      
15E2 28 FA        JR   Z,L15DE 
15E4 CF 07        RST  08h,07h 


15E6 L15E6:
15E6 D9           EXX         
15E7 E5           PUSH HL     
15E8 2A 51 5C     LD   HL,(L5C51) 
15EB 23           INC  HL     
15EC 23           INC  HL     
15ED 18 08        JR   L15F7  


15EF 1E           defb 1Eh    
15F0 30           defb 30h    
15F1 83           defb 83h    
15F2 D9           defb D9h    
15F3 E5           defb E5h    
15F4 2A           defb 2Ah    
15F5 51           defb 51h    
15F6 5C           defb 5Ch    


15F7 L15F7:
15F7 5E           LD   E,(HL) 
15F8 23           INC  HL     
15F9 56           LD   D,(HL) 
15FA EB           EX   DE,HL  
15FB CD 2C 16     CALL L162C  
15FE E1           POP  HL     
15FF D9           EXX         
1600 C9           RET         


1601 87           defb 87h    
1602 C6           defb C6h    
1603 16           defb 16h    
1604 6F           defb 6Fh    
1605 26           defb 26h    
1606 5C           defb 5Ch    
1607 5E           defb 5Eh    
1608 23           defb 23h    
1609 56           defb 56h    
160A 7A           defb 7Ah    
160B B3           defb B3h    
160C 20           defb 20h    
160D 02           defb 02h    
160E CF           defb CFh    
160F 17           defb 17h    
1610 1B           defb 1Bh    
1611 2A           defb 2Ah    
1612 4F           defb 4Fh    
1613 5C           defb 5Ch    
1614 19           defb 19h    
1615 22           defb 22h    
1616 51           defb 51h    
1617 5C           defb 5Ch    
1618 FD           defb FDh    
1619 CB           defb CBh    
161A 30           defb 30h    
161B A6           defb A6h    
161C 23           defb 23h    
161D 23           defb 23h    
161E 23           defb 23h    
161F 23           defb 23h    
1620 4E           defb 4Eh    
1621 21           defb 21h    
1622 2D           defb 2Dh    
1623 16           defb 16h    
1624 CD           defb CDh    
1625 DC           defb DCh    
1626 16           defb 16h    
1627 D0           defb D0h    
1628 16           defb 16h    
1629 00           defb 00h    
162A 5E           defb 5Eh    
162B 19           defb 19h    


162C L162C:
162C E9           JP   (HL)   


162D 4B           defb 4Bh    
162E 06           defb 06h    
162F 53           defb 53h    
1630 12           defb 12h    
1631 50           defb 50h    
1632 1B           defb 1Bh    
1633 00           defb 00h    
1634 FD           defb FDh    
1635 CB           defb CBh    
1636 02           defb 02h    
1637 C6           defb C6h    
1638 FD           defb FDh    
1639 CB           defb CBh    
163A 01           defb 01h    
163B AE           defb AEh    
163C FD           defb FDh    
163D CB           defb CBh    
163E 30           defb 30h    
163F E6           defb E6h    
1640 18           defb 18h    
1641 04           defb 04h    
1642 FD           defb FDh    
1643 CB           defb CBh    
1644 02           defb 02h    
1645 86           defb 86h    
1646 FD           defb FDh    
1647 CB           defb CBh    
1648 01           defb 01h    
1649 8E           defb 8Eh    
164A C3           defb C3h    
164B 4D           defb 4Dh    
164C 0D           defb 0Dh    
164D FD           defb FDh    
164E CB           defb CBh    
164F 01           defb 01h    
1650 CE           defb CEh    
1651 C9           defb C9h    


1652 L1652:
1652 01 01 00     LD   BC,0001h 


1655 L1655:
1655 E5           PUSH HL     
1656 CD 05 1F     CALL L1F05  
1659 E1           POP  HL     
165A CD 64 16     CALL L1664  
165D 2A 65 00     LD   HL,(L0065) 