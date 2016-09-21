			;code27/11/2012
;code cho hao quang
;*************

SI	    BIT P1.0			
RCK 	BIT P1.1
SCK 	BIT P1.2
VAN     BIT P3.3
BITDICH	BIT 20H.0
BITTAM	BIT 20H.1
BITXOAd	BIT 20H.2
BITXOAt	BIT 20H.3
BITDON  BIT 20H.4
BITLENXUONG BIT 20H.5
BITDICHTRAI BIT 20H.6
BITDICHPHAI BIT 20H.7
BITDICHLEN  BIT 21H.0
BITDICHXUONG BIT 21H.1
;***************************
DICHBIT  EQU 08H		
TAM      EQU 10H
GIATRI_TOCDO EQU 11H
;***************************
HANGTREN EQU P2
HANGDUOI EQU P0	
;****************************
TOC_DO    EQU R2
SOLANCHAY EQU R4
MODECHAY  EQU R5
;bien xoa mang hinh dau= R6

;****************************
;16byte ram tu 30H...> 40H =MAHANG
;32byte ram tu 41H...> 61H =XUATHANGDUOI
;32byte ram tu 61H...> 81H =XUATHANTREN
;****************************
RAM1DAU DATA 41H
RAM2DAU DATA 61H
RAM1CUOI DATA 61H
RAM2CUOI DATA 81H
RAMTAM1DAU DATA 82H ;32BYTE tu 82H den 0a2H
RAMTAM2DAU DATA 0A3H ;32BYTE tu 0A3H den 0C4H
RAMTAM1CUOI DATA 0A2H
RAMTAM2CUOI DATA 0C3H
;SP = 0C5H  

;****************************

                      ORG 0000H              
                      LJMP MAIN
					  ORG 000BH ;Dia chi vector bo dinh thoi 0
					  LJMP T0ISR
					 ; ORG 001BH ;Dia chi vector bo dinh thoi 1
					 ; LJMP T1ISR
					  
				

MAIN:
;**************************
		    MOV TMOD,#11H    ;Ca 2 bo dinh thoi che do 1
		    MOV IE,#80H 
			MOV SP,#0C5H;90H
            MOV R7,#20
          ; CLR VAN
		   SETB TF0         ;Buoc ngat do bo time 0
		   SETB ET0         ;Cho phep ngat bo dinh thoi 0 
;*************
           LCALL LODE_MAHANG 
;************
		   SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
           SETB BITDICHPHAI 
           SETB BITDICHLEN  
          ; SETB BITDICHXUONG 		  
	
CHUONGTRINH1:
;****************
         MOV MODECHAY,#1
         LCALL TIMMA_DPTR        
          CLR BITDICH
		  clr bitlenxuong

;**************************         
DICH_LEN_C1:
         
    	 clr bitxoad
         clr bitxoat
         mov r6,#0
		 clr bitdon
		 MOV SOLANCHAY,#18	
         MOV TOC_DO,#4
		 MOV R3,#8
		 LCALL LOADRAM_TAM
TIEP_C1: 
;((((((( 	
         LCALL LOADRAM_HIENTHI
;(((((((
		 DJNZ TOC_DO,TIEP_C1
    	 MOV TOC_DO,#4
		 JB BITDICH,D8_16_C1
		 jb bitlenxuong,xuong_C1
		 LCALL DICH_RAM_LEN1_8	;dich len 1bit
	     ljmp _0xC1
xuong_C1:LCALL DICH_RAM_XUONG8_16
_0xC1:   jb bitxoat,nor6
         inc r6				   ;lay ma xoa
nor6:    DJNZ R3,THOAT_C1
		 MOV R3,#8
		 setb bitxoad
		 SETB BITDICH
;(((((((
THOAT_C1:LJMP TIEP_C1
D8_16_C1:jb bitlenxuong,xuong1_C1
         LCALL DICH_RAM_LEN8_16
		 ljmp _0xC2
xuong1_C1:LCALL DICH_RAM_XUONG1_8
_0xC2:   jb bitxoat,nor6_1
         inc r6
nor6_1:  DJNZ R3,EXIT_C1_1
		 MOV R3,#8
		 CLR BITDICH
		 setb bitxoat
		 DEC SOLANCHAY
		 CJNE SOLANCHAY,#16,EXIT_C1 		  
		 cpl bitlenxuong
	     setb bitdon
		 mov r6,#0
		 jmp EXIT_C1_1		 
EXIT_C1: jnb bitdon,nor6_2
         inc r6
nor6_2:  CJNE SOLANCHAY,#0,EXIT_C1_1
         INC MODECHAY 		  
EX_01:	 ; POP 05H
          LJMP CHUONGTRINH2;&&&&&&&&
EXIT_C1_1:LJMP TIEP_C1

;**************************************************

CHUONGTRINH2:
;****************
          LCALL TIMMA_DPTR 
		  JNB BITDICHLEN,EX_02
          CLR BITDICH
		  clr bitlenxuong
;**************************         
DICH_LEN_C2:
    	 clr bitxoad
         clr bitxoat
         mov r6,#0
		 clr bitdon
		 MOV SOLANCHAY,#10	
         MOV TOC_DO,#6;GIATRI_TOCDO;#6
		 MOV R3,#8
		 LCALL LOADRAM_TAM
TIEP_C2: 
;((((((( 	
         LCALL LOADRAM_HIENTHI
;(((((((
		 DJNZ TOC_DO,TIEP_C2
    	 MOV TOC_DO,#6;GIATRI_TOCDO;#6#6
		 JB BITDICH,D8_16_C2
		 jb bitlenxuong,xuong_C2
		 LCALL DICH_RAM_LEN1_8	;dich len 1bit
	     ljmp _0x2C2
xuong_C2:LCALL DICH_RAM_XUONG8_16
_0x2C2:  inc r6				   ;lay ma xoa
		 DJNZ R3,THOAT_C2
		 MOV R3,#8
		 setb bitxoad
		 SETB BITDICH
;(((((((
THOAT_C2:LJMP TIEP_C2
D8_16_C2:jb bitlenxuong,xuong1_C2
         LCALL DICH_RAM_LEN8_16
		 ljmp _0x3C2
xuong1_C2:LCALL DICH_RAM_XUONG1_8
_0x3C2:  inc r6
         DJNZ R3,EXIT_C2
		 MOV R3,#8
		 CLR BITDICH
		 setb bitxoat
		 DEC SOLANCHAY
		 CJNE SOLANCHAY,#5,EXIT_C2 		  
		 cpl bitlenxuong
EXIT_C2: CJNE SOLANCHAY,#0,EXIT_C2_1
         LJMP CHUONGTRINH3
EX_02:	 LCALL LOADRAM_TAM
         LJMP CHUONGTRINH3;&&&&&&&&
EXIT_C2_1:LJMP TIEP_C2
;**************************************************
CHUONGTRINH3:;dich sang trai
         JNB BITDICHTRAI,EX_03
;********
         mov r6,#0
		 MOV SOLANCHAY,#100	
         MOV TOC_DO,#6
		; LCALL LOADRAM_TAM
TIEP_C3: 
;((((((( 	
         LCALL LOADRAM_HIENTHI
;(((((((
		 DJNZ TOC_DO,TIEP_C3
    	 MOV TOC_DO,#6
		 LCALL DICHRAMQUATRAI 
		 DEC SOLANCHAY
		 CJNE SOLANCHAY,#0,EXIT_C3 	
EX_03:	 LJMP CHUONGTRINH4;&&&&&&&&	  
EXIT_C3: LJMP TIEP_C3		 
;$$$$$$$$$$$$$$$$$$$
CHUONGTRINH4:;dich sang phai
         JNB BITDICHPHAI,EX1_04
;***********
         mov r6,#0
		 MOV SOLANCHAY,#100	
         MOV TOC_DO,#6
;***
		; LCALL LOADRAM_TAM
TIEP_C4: 
;((((((( 	
         LCALL LOADRAM_HIENTHI
;(((((((
		 DJNZ TOC_DO,TIEP_C4
    	 MOV TOC_DO,#6
		 LCALL DICHRAMQUAPHAI 
		 DEC SOLANCHAY
		 CJNE SOLANCHAY,#0,EXIT_C4 
EX1_04:	 INC MODECHAY	
		 CJNE MODECHAY,#29,EX_04
		 LJMP CHUONGTRINH1         
EX_04:   LJMP CHUONGTRINH2                      ;&&&&&&&&	  
EXIT_C4: LJMP TIEP_C4		 


;**************************************************
;**************************************************
T0ISR :  CLR TR0       ; dung bo dinh thoi
        ; DJNZ R7,SKIP   ;neu chua du thoat
		; CPL VAN
		; MOV R7,#5
 SKIP :  MOV TH0,#HIGH(-1000) ;tri hoan 0.1sec
 		 MOV TL0,#LOW(-1000)
		 CPL VAN
 		 SETB TR0
         RETI
;**************************************************
;**********CH/TR con ********************** 
;**************************************************
LOADRAM_TAM:
		 LCALL LOADRAMTAM_TREN ;load data tu mang vao
		 LCALL LOADRAMTAM_DUOI ;ram tam
	   RET
;*******************************
LOADRAM_HIENTHI:      
         LCALL LOADRAMDUOI	  ;load data tu ram tam vao
		 LCALL LOADRAMTREN	  ;ram hien thi	
     	 LCALL QUET8HANG1_8
		 LCALL QUET8HANG8_16
 RET
;*******************************
DICHRAMQUATRAI:
	LCALL DICHRAM_TRAI_DUOI
	LCALL DICHRAM_TRAI_TREN
	RET
;*******************************
DICHRAMQUAPHAI:
	LCALL DICHRAM_PHAI_TREN
	LCALL DICHRAM_PHAI_DUOI
	RET
;*******************************
DICH_RAM_LEN1_8:
        PUSH 00H
		PUSH 01H
		MOV R0,#RAMTAM2DAU ;ram tren
		MOV R1,#RAMTAM1DAU ;ram duoi
DICHT:
		MOV A,@R0;nap vao A
		CLR C
		RRC A ;dich 1 bit sang trai dua bit nay vao co C ;luc nay co C luu bit 7 cua a	        
	    MOV TAM,A;MOV @R0,A;nap vao RAM
;
    	MOV A,@R1;nap vao A ram duoi
		RRC A    ;dich 1 bit sang trai dong thoi dua C vao bit vao bit 0
	   	MOV @R1,A;nap vao RAM
;		;C chuan bi nap
		mov BITTAM,C
;***********
		MOV A,TAM ;Lay lai byte duoi
		RL A
		MOV C,BITTAM
		RRC A ;nap c vao
		MOV @R0,A;nap vao RAM
;*******
		INC R0
		INC R1
		CJNE R0,#RAMTAM2CUOI,DICHT

		POP 00H
		POP 01H
        RET
;***************************************
;*******************************
DICH_RAM_XUONG1_8:
        PUSH 00H
		PUSH 01H
		MOV R0,#RAMTAM2DAU ;ram tren
		MOV R1,#RAMTAM1DAU ;ram duoi
DICHTX:
		MOV A,@R0;nap vao A
		CLR C
		RLC A ;dich 1 bit sang PHAI dua bit nay vao co C ;luc nay co C luu bit 7 cua a	        
	    MOV TAM,A;MOV @R0,A;nap vao RAM
;
    	MOV A,@R1;nap vao A ram duoi
		RLC A    ;dich 1 bit sang trai dong thoi dua C vao bit vao bit 0
	   	MOV @R1,A;nap vao RAM
;		;C chuan bi nap
		mov BITTAM,C
;***********
		MOV A,TAM ;Lay lai byte duoi
		RR A
		MOV C,BITTAM
		RLC A ;nap c vao
		MOV @R0,A;nap vao RAM
;*******
		INC R0
		INC R1
		CJNE R0,#RAMTAM2CUOI,DICHTX

		POP 00H
		POP 01H
        RET
;***************************************
DICH_RAM_LEN8_16:
        PUSH 00H
		PUSH 01H
		MOV R0,#RAMTAM2DAU ;ram tren
		MOV R1,#RAMTAM1DAU ;ram duoi
DICHT2:
		MOV A,@R1;nap vao A
		CLR C
		RRC A ;dich 1 bit sang trai dua bit nay vao co C ;luc nay co C luu bit 7 cua a		        
		MOV TAM,A;MOV @R1,A;nap vao RAM
;		;C chuan bi nap
    	MOV A,@R0;nap vao A ram Tren
		RRC A    ;dich 1 bit sang trai dong thoi dua C vao bit vao bit 0
		MOV @R0,A;nap vao RAM
		;C chuan bi nap
		mov BITTAM,C
;***********
		MOV A,TAM ;Lay lai byte duoi
		RL A
		MOV C,BITTAM
		RRC A ;nap c vao
		MOV @R1,A;nap vao RAM        
;**************
		INC R0
		INC R1
		CJNE R0,#RAMTAM2CUOI,DICHT2
		POP 00H
		POP 01H
        RET
;**************************************************
;***************************************
DICH_RAM_XUONG8_16:
        PUSH 00H
		PUSH 01H
		MOV R0,#RAMTAM2DAU ;ram tren
		MOV R1,#RAMTAM1DAU ;ram duoi
DICHT2X:
		MOV A,@R1;nap vao A
		CLR C
		RLC A ;dich 1 bit sang trai dua bit nay vao co C ;luc nay co C luu bit 7 cua a		        
		MOV TAM,A;MOV @R1,A;nap vao RAM
;		;C chuan bi nap
    	MOV A,@R0;nap vao A ram Tren
		RLC A    ;dich 1 bit sang trai dong thoi dua C vao bit vao bit 0
		MOV @R0,A;nap vao RAM
		;C chuan bi nap
		mov BITTAM,C
;***********
		MOV A,TAM ;Lay lai byte duoi
		RR A
		MOV C,BITTAM
		RLC A ;nap c vao
		MOV @R1,A;nap vao RAM        
;**************
		INC R0
		INC R1
		CJNE R0,#RAMTAM2CUOI,DICHT2X
		POP 00H
		POP 01H
        RET
;**************************************************
QUET8HANG1_8: MOV HANGTREN,#0FFH  
          PUSH 00H
		  PUSH 01H
          MOV R1,#30H  ;chon hang 		   
 LAPHANG:  MOV R0,#RAM1DAU
	       CLR RCK					 
   LAPCOT: CLR SCK 
           MOV A,@R0	          
		   SETB C
		   RLC A
		   MOV @R0,A
	       SETB SCK
		   MOV SI,C	   
           INC R0		  		 		  
		   CJNE R0,#RAM1CUOI,LAPCOT
		   LCALL XUNGSAU
		   SETB RCK		  
	       LCALL XUATDUOI; MOV CHONHANG,R7;Sang hang			  
		   LCALL DELAYLED
		   MOV HANGDUOI,#0FFH
		   INC R1
           CJNE R1,#38H,LAPHANG
		  POP 01H
		  POP 00H
	        	RET
;*******************************************  
;*******************************************  
QUET8HANG8_16:MOV HANGDUOI,#0FFH  
          PUSH 00H
		  PUSH 01H
          MOV R1,#38H  ;chon hang 		   
LAPHANG1: 
           MOV R0,#RAM2DAU
	       CLR RCK					 
   LAPCOT1:CLR SCK 
           MOV A,@R0	          
		   SETB C
		   RLC A
		   MOV @R0,A
	       SETB SCK
	       MOV SI,C	
		   INC R0		  		 		  
		   CJNE R0,#81H,LAPCOT1
		   LCALL XUNGSAU
		   SETB RCK		  
	       LCALL XUATTREN; 			  
		   LCALL DELAYLED
		   MOV HANGTREN,#0FFH  
		   INC R1
           CJNE R1,#40H,LAPHANG1
		  POP 01H
		  POP 00H
	        	RET
;*******************************************
;********************
XUATDUOI:
      MOV A,@R1
	  MOV HANGDUOI,A
	  RET
;***********************
XUATTREN:
      MOV A,@R1
	  MOV HANGTREN,A
	  RET  
;***********************        
LODE_MAHANG:
      PUSH 00H
	  PUSH 01H
	  PUSH DPH
	  PUSH DPL
      MOV DPTR,#MAHANG
	  MOV R0,#30H
	  MOV R1,#0
NAPTIEP:
      MOV A,R1
	  MOVC A,@A+DPTR
	  MOV @R0,A
	  INC R1
	  INC R0
	  CJNE R1,#16,NAPTIEP
	  POP DPL
	  POP DPH
	  POP 01H
	  POP 00H
	  RET
;*******************************

;*******************************
;*******************************
;*******************************;
LOADRAMDUOI:;(RAM1);sao chep tu ram tam sang ram duoi de hien thi
	PUSH 00H
	PUSH 01H
;	mov r6,#0
	MOV R0,#RAMTAM1DAU
	MOV R1,#RAM1DAU
LRAM1:CLR A
	MOV A,@R0
    jb bitxoad,k_xd
	mov dptr,#maxoa
	push acc
	mov a,r6
	movc a,@a+dptr
	mov tam,a
	pop acc
	orl a,tam
	jmp lrd
k_xd:jnb bitdon,k_xd1
    mov dptr,#madond
	push acc
	mov a,r6
	movc a,@a+dptr
	mov tam,a
	pop acc
	anl a,tam
k_xd1:	
lrd:MOV @R1,A
	INC R0
	INC R1
	CJNE R1,#RAM1CUOI,LRAM1
;	pop 06h
	POP 01H
	POP 00H
  RET
;********************************************
LOADRAMTREN:;(RAM2);sao chep tu ram tam sang ram duoi de hien thi
	PUSH 00H
	PUSH 01H
  mov dptr,#maxoat
	MOV R0,#RAMTAM2DAU
	MOV R1,#RAM2DAU
LRAM2:CLR A
	MOV A,@R0
	jb bitxoat,k_xt
	push acc
	mov a,r6
	movc a,@a+dptr
	mov tam,a
	pop acc
	orl a,tam
	jmp lrt
k_xt:jnb bitdon,k_xt1
    mov dptr,#madont
	push acc
	mov a,r6
	movc a,@a+dptr
	mov tam,a
	pop acc
	anl a,tam
k_xt1:
lrt:	
	MOV @R1,A
	INC R0
	INC R1
	CJNE R1,#RAM2CUOI,LRAM2
	POP 01H
	POP 00H
  RET

;*******************************
LOADRAMTAM_DUOI:
      PUSH 00H
	  PUSH 06H
     ; LCALL TIMMA_DPTR;MOV DPTR,#HINH_CARO;MAHINH;&&&&
	  MOV R0,#RAMTAM1DAU
	  MOV R6,#0;	byte chan 2,4,6
NAPDUOI:
      MOV A,R6
	  MOVC A,@A+DPTR
	  MOV @R0,A
	INC R6
	inc r6
	  INC R0	  
	  CJNE R0,#RAMTAM1CUOI,NAPDUOI	 
	  POP 06H
	  POP 00H
	  RET
;*******************************
;*******************************

LOADRAMTAM_TREN:
      PUSH 00H
	  PUSH 06H
     ; LCALL TIMMA_DPTR; MOV DPTR,#HINH_CARO;MAHINH;&&&&&
	  MOV R0,#RAMTAM2DAU
	  MOV R6,#1	;byte le 1,3,5
NAPTREN:
      MOV A,R6
	  MOVC A,@A+DPTR
	  MOV @R0,A
	  INC R6
	  inc r6
	  INC R0
	  CJNE R0,#RAMTAM2CUOI,NAPTREN
	  POP 06H
	  POP 00H
	  RET
;*******************************
DICHRAM_PHAI_DUOI:
	PUSH 00H
	PUSH 01H
	MOV R1,#RAMTAM1DAU
	MOV R0,#RAMTAM1DAU	 ;ram hien thi
	MOV A,@R0
	MOV TAM,A
LDICHPD:
	INC R0
	MOV A,@R0
	MOV @R1,A
	INC R1
	CJNE R1,#RAMTAM1CUOI,LDICHPD
	DEC R1
	MOV @R1,TAM
	POP 01H
	POP 00H
  RET
;*******************************
DICHRAM_PHAI_TREN:
	PUSH 00H
	PUSH 01H
	MOV R1,#RAMTAM2DAU
	MOV R0,#RAMTAM2DAU	 ;ram hien thi
	MOV A,@R0
	MOV TAM,A
LDICHPT:
	INC R0
	MOV A,@R0
	MOV @R1,A
	INC R1
	CJNE R1,#RAMTAM2CUOI,LDICHPT
	DEC R1
	MOV @R1,TAM
	POP 01H
	POP 00H
  RET
;*******************************
;*******************************
DICHRAM_TRAI_DUOI:
	PUSH 00H
	PUSH 01H
	MOV R1,#RAMTAM1CUOI
	MOV R0,#RAMTAM1CUOI;RAMTAM1DAU	 ;ram hien thi
	dec r0
	dec r1
	MOV A,@R0
	MOV TAM,A
LDICHTD:
	DEC R0
	MOV A,@R0
	MOV @R1,A
	DEC R1
	CJNE R1,#RAMTAM1DAU,LDICHTD
	MOV @R1,TAM
	POP 01H
	POP 00H
  RET
;*******************************
DICHRAM_TRAI_TREN:
	PUSH 00H
	PUSH 01H
	MOV R1,#RAMTAM2CUOI;RAMTAM2DAU
	MOV R0,#RAMTAM2CUOI;RAMTAM2DAU	 ;ram hien thi
    dec r0
	dec r1
	MOV A,@R0
	MOV TAM,A
LDICHTT:
	DEC R0
	MOV A,@R0
	MOV @R1,A
	DEC R1
	CJNE R1,#RAMTAM2DAU,LDICHTT
	MOV @R1,TAM
	POP 01H
	POP 00H
  RET
;*******************************TIM MA CHAY HAO QUANG************
;*******************************
TIMMA_DPTR:
      CJNE MODECHAY,#1,M_KH
	  MOV DPTR,#HINH_CARO
	  MOV GIATRI_TOCDO,#4
	  RET
M_KH:CJNE MODECHAY,#2,M_KH1
      MOV DPTR,#BAUTROISAO	 ;MOV GIATRI_TOCDO,#6
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN ;SETB 
	  RET
M_KH1:CJNE MODECHAY,#3,M_KH2
	  MOV DPTR,#MASAUTIAAM
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH2:CJNE MODECHAY,#4,M_KH3
	  MOV DPTR,#MASAUTIADUONG 
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH3:CJNE MODECHAY,#5,M_KH4
	  MOV DPTR,#MAHOASEN2
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH4:CJNE MODECHAY,#6,M_KH5
	  MOV DPTR,#AMDUONG4
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH5:CJNE MODECHAY,#7,M_KH6
	  MOV DPTR,#MAHOASEN1
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH6:CJNE MODECHAY,#8,M_KH7
	  MOV DPTR,#MAHINHVAN
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH7:CJNE MODECHAY,#9,M_KH8 ;LAM LAI
	  MOV DPTR,#XOEDUOICONG2
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH8:CJNE MODECHAY,#10,M_KH9
	  MOV DPTR,#MAXOEDUOICONG
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH9:CJNE MODECHAY,#11,M_KH10
	  MOV DPTR,#MAMOTVONG
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH10:CJNE MODECHAY,#12,M_KH11
	  MOV DPTR,#MABAVONG
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH11:CJNE MODECHAY,#13,M_KH12;thay cai khac
	  MOV DPTR,#HINH_CARO
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH12:CJNE MODECHAY,#14,M_KH13
	  MOV DPTR,#TIA16NHANH
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH13:CJNE MODECHAY,#15,M_KH14
	  MOV DPTR,#BONCANHTIA5NHANH
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH14:CJNE MODECHAY,#16,M_KH15
	  MOV DPTR,#BATPHONG
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH15:CJNE MODECHAY,#17,M_KH16
	  MOV DPTR,#BATIAVONGCUNG
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
	  RET
M_KH16:CJNE MODECHAY,#18,M_KH17
	  MOV DPTR,#HOABONCANH
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH17:CJNE MODECHAY,#19,M_KH18
	  MOV DPTR,#HINHAMDUONG
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
	  RET
M_KH18:CJNE MODECHAY,#20,M_KH19
	  MOV DPTR,#TIABONCANH
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH19:CJNE MODECHAY,#21,M_KH20
	  MOV DPTR,#BACANHQUAT
	  setb BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH20:CJNE MODECHAY,#22,M_KH21
	  MOV DPTR,#MAKHONGTEN
	  CLR BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      CLR BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH21:CJNE MODECHAY,#23,M_KH23
	  MOV DPTR,#CHAMDANGSONG
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      SETB BITDICHLEN  
	  RET
M_KH23:CJNE MODECHAY,#24,M_KH24
	  MOV DPTR,#HAIVONG8TIA
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
	  RET			
M_KH24:CJNE MODECHAY,#25,M_KH25
	  MOV DPTR,#MAVONGCON
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
	  RET
M_KH25:CJNE MODECHAY,#26,M_KH26
	  MOV DPTR,#BANHXE6
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
M_KH26:CJNE MODECHAY,#27,M_KH27
	  MOV DPTR,#CHAMHAI
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
M_KH27:CJNE MODECHAY,#28,M_KH28
	  MOV DPTR,#MA12VONG
	  SETB BITDICHTRAI  ;=1 CHAY, =0 BO QUA
      SETB BITDICHPHAI 
      CLR BITDICHLEN  
M_KH28:
	
	  RET
;************BAUTROISAO,MASAUTIAAM,MASAUTIADUONG,MAHOASEN2,AMDUONG4,
;MAHOASEN1,MAHINHVAN,XOEDUOICONG2,MAXOEDUOICONG,MMAMOTVONG,MABAVONG,HINH_CARO
;TIA16NHANH:;17,BONCANHTIA5NHANH,BATPHONG,BATIAVONGCUNG,
;HOABONCANH,HINHAMDUONG,TIABONCANH,BACANHQUAT,MAKHONGTEN,CHAMDANGSONG
;*******************************

;*******************************

;*******************************
;*******************************
DELAYLED:		 PUSH 03H
	             PUSH 04H
             D2: MOV R3,#3;
             D1: MOV R4,#200                 
                 DJNZ R4,$       
                 DJNZ R3,D1
				 POP 04H
	             POP 03H	
;***************	   
        	               
 XUNGSAU :        	               
      CLR SCK                  
      NOP 
      SETB SCK
	  NOP
      CLR RCK 
      RET
;********************  
;***************************;***********
MAHANG:DB 0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH,7FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,0FFH
;***************************;***********
madond:db 0x7f,0x3f,0x1f,0x0f,0x07,0x03,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
madont:db 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0x7f,0x3f,0x1f,0x0f,0x07,0x03,0x01,0x00
;*******************************
;************
maxoa:db  0xff,0x7f,0x3f,0x1f,0x0f,0x07,0x03,0x01,0x00,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff
maxoat:db 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0x7f,0x3f,0x1f,0x0f,0x07,0x03,0x01,0x00

;************HINH_CARO
HINH_CARO:
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
db 077h,077h
db 0DDh,0DDh
;**************88
;=================AM DUONG======
AMDUONG4:
db 00Eh,00Eh
db 01Ch,01Ch
db 038h,038h
db 070h,070h
db 0E0h,0E0h
db 0C1h,0C1h
db 083h,083h
db 007h,007h
db 00Eh,00Eh
db 01Ch,01Ch
db 038h,038h
db 070h,070h
db 0E0h,0E0h
db 0C1h,0C1h
db 083h,083h
db 007h,007h
db 00Eh,00Eh
db 01Ch,01Ch
db 038h,038h
db 070h,070h
db 0E0h,0E0h
db 0C1h,0C1h
db 083h,083h
db 007h,007h
db 00Eh,00Eh
db 01Ch,01Ch
db 038h,038h
db 070h,070h
db 0E0h,0E0h
db 0C1h,0C1h
db 083h,083h
db 007h,007h
;

;**********************MA BA VONG
MABAVONG:;1
db 07Fh,0FFh
db 07Fh,0FFh
db 0BFh,0FFh
db 0DFh,0FFh
db 0EFh,0FFh
db 077h,0FFh
db 0BBh,0FFh
db 0DDh,0FFh
db 0EEh,0FFh
db 0F7h,07Fh
db 07Bh,0BFh
db 0BDh,0DFh
db 0DEh,0EFh
db 0EFh,077h
db 0F7h,0BBh
db 0FBh,0DDh
db 0F8h,06Eh
db 0FBh,0DDh
db 0F7h,0BBh
db 0EFh,077h
db 0DEh,0EFh
db 0BDh,0DFh
db 07Bh,0BFh
db 0F7h,07Fh
db 0EEh,0FFh
db 0DDh,0FFh
db 0BBh,0FFh
db 077h,0FFh
db 0EFh,0FFh
db 0DFh,0FFh
db 0BFh,0FFh
db 07Fh,0FFh
;****************MA MOT VONG
MAMOTVONG:;2
db 07Fh,0FFh
db 07Fh,0FFh
db 0BFh,0FFh
db 09Fh,0FFh
db 08Fh,0FFh
db 0C7h,0FFh
db 0E3h,0FFh
db 0F1h,0FFh
db 0F8h,0FFh
db 0FCh,07Fh
db 0FEh,03Fh
db 0FFh,01Fh
db 0FFh,08Fh
db 0FFh,0C7h
db 0FFh,0E3h
db 0FFh,0F1h
db 0FFh,0F8h
db 0FFh,0F1h
db 0FFh,0E3h
db 0FFh,0C7h
db 0FFh,08Fh
db 0FFh,01Fh
db 0FEh,03Fh
db 0FCh,07Fh
db 0F8h,0FFh
db 0F1h,0FFh
db 0E3h,0FFh
db 0C7h,0FFh
db 08Fh,0FFh
db 09Fh,0FFh
db 0BFh,0FFh
db 07Fh,0FFh
; 
MAXOEDUOICONG:;3
db 07Fh,0FFh
db 07Fh,0FFh
db 07Fh,0FFh
db 03Fh,0FFh
db 01Fh,0FFh
db 00Fh,0FFh
db 007h,0FFh
db 003h,0FFh
db 001h,0FFh
db 000h,0FFh
db 000h,07Fh
db 080h,03Fh
db 0C0h,01Fh
db 0E0h,00Fh
db 0F0h,007h
db 0F8h,003h
db 0FCh,001h
db 0F8h,003h
db 0F0h,007h
db 0E0h,00Fh
db 0C0h,01Fh
db 080h,03Fh
db 000h,07Fh
db 000h,0FFh
db 001h,0FFh
db 003h,0FFh
db 007h,0FFh
db 00Fh,0FFh
db 01Fh,0FFh
db 03Fh,0FFh
db 07Fh,0FFh
db 07Fh,0FFh
; 
XOEDUOICONG2:;4
db 07Fh,0FFh
db 07Fh,0FFh
db 03Fh,0FFh
db 01Fh,0FFh
db 00Fh,0FFh
db 007h,0FFh
db 003h,0FFh
db 001h,0FFh
db 000h,0FFh
db 000h,07Fh
db 000h,03Fh
db 000h,01Fh
db 000h,00Fh
db 000h,007h
db 000h,003h
db 000h,001h
db 000h,000h
db 000h,001h
db 000h,003h
db 000h,007h
db 000h,00Fh
db 000h,01Fh
db 000h,03Fh
db 000h,07Fh
db 000h,0FFh
db 001h,0FFh
db 003h,0FFh
db 007h,0FFh
db 00Fh,0FFh
db 01Fh,0FFh
db 03Fh,0FFh
db 07Fh,0FFh
;
MAHINHVAN:;5
db 000h,00Fh
db 000h,00Fh
db 07Fh,0C7h
db 03Fh,0E3h
db 07Fh,0FCh
db 03Fh,0FFh
db 07Fh,0FFh
db 000h,00Fh
db 000h,00Fh
db 000h,00Fh
db 07Fh,0C7h
db 03Fh,0E3h
db 07Fh,0FCh
db 03Fh,0FFh
db 07Fh,0FFh
db 000h,00Fh
db 000h,00Fh
db 000h,00Fh
db 07Fh,0C7h
db 03Fh,0E3h
db 07Fh,0FCh
db 03Fh,0FFh
db 07Fh,0FFh
db 000h,00Fh
db 000h,00Fh
db 000h,00Fh
db 07Fh,0C7h
db 03Fh,0E3h
db 07Fh,0FCh
db 03Fh,0FFh
db 07Fh,0FFh
db 000h,00Fh
;
MAHOASEN1:;6
db 0EDh,0FFh
db 076h,0FFh
db 0BBh,07Fh
db 0DDh,0BFh
db 0EEh,0DFh
db 077h,06Fh
db 0BBh,087h
db 0DDh,0DFh
db 06Eh,00Fh
db 0B7h,07Fh
db 0DBh,0BFh
db 0ECh,01Fh
db 0F6h,0FFh
db 0FBh,07Fh
db 0FDh,0BFh
db 0FEh,0DFh
db 0FFh,06Fh
db 0FEh,0DFh
db 0FDh,0BFh
db 0FBh,07Fh
db 0F6h,0FFh
db 0ECh,01Fh
db 0DBh,0BFh
db 0B7h,07Fh
db 06Eh,00Fh
db 0DDh,0DFh
db 0BBh,087h
db 077h,06Fh
db 0EEh,0DFh
db 0DDh,0BFh
db 0BBh,07Fh
db 076h,0FFh
;
MAHOASEN2:;7
db 0EFh,0F7h
db 077h,0DDh
db 0BBh,0F7h
db 0DDh,0DDh
db 0EEh,0F7h
db 0F7h,05Dh
db 0FBh,0B7h
db 0FDh,0DDh
db 0DEh,0EDh
db 0CFh,007h
db 0D7h,0BFh
db 0D8h,01Fh
db 0DDh,0FFh
db 0DEh,0FFh
db 0DFh,07Fh
db 0DFh,0BFh
db 0DFh,0DFh
db 0DFh,0BFh
db 0DFh,07Fh
db 0DEh,0FFh
db 0DDh,0FFh
db 0D8h,01Fh
db 0D7h,0BFh
db 0CFh,007h
db 0DEh,0EFh
db 0FDh,0DDh
db 0FBh,0B7h
db 0F7h,05Dh
db 0EEh,0F7h
db 0DDh,0DDh
db 0BBh,0F7h
db 077h,0DDh
;
MASAUTIADUONG:;8
db 080h,000h
db 0C0h,007h
db 0C0h,03Fh
db 0C1h,0FFh
db 0FFh,0FFh
db 0C1h,0FFh
db 0C0h,03Fh
db 0C0h,007h
db 080h,000h
db 0C0h,007h
db 0C0h,03Fh
db 0C1h,0FFh
db 0FFh,0FFh
db 0C1h,0FFh
db 0C0h,03Fh
db 0C0h,007h
db 080h,000h
db 0C0h,007h
db 0C0h,03Fh
db 0C1h,0FFh
db 0FFh,0FFh
db 0C1h,0FFh
db 0C0h,03Fh
db 0C0h,007h
db 080h,000h
db 0C0h,007h
db 0C0h,03Fh
db 0C1h,0FFh
db 0FFh,0FFh
db 0C1h,0FFh
db 0C0h,03Fh
db 0C0h,007h
;
MASAUTIAAM:;9
db 0FFh,0E0h
db 0FFh,01Fh
db 0F8h,0FFh
db 0C7h,0FFh
db 03Fh,0FFh
db 0C7h,0FFh
db 0F8h,0FFh
db 0FFh,01Fh
db 0FFh,0E0h
db 0FFh,01Fh
db 0F8h,0FFh
db 0C7h,0FFh
db 03Fh,0FFh
db 0C7h,0FFh
db 0F8h,0FFh
db 0FFh,01Fh
db 0FFh,0E0h
db 0FFh,01Fh
db 0F8h,0FFh
db 0C7h,0FFh
db 03Fh,0FFh
db 0C7h,0FFh
db 0F8h,0FFh
db 0FFh,01Fh
db 0FFh,0E0h
db 0FFh,01Fh
db 0F8h,0FFh
db 0C7h,0FFh
db 03Fh,0FFh
db 0C7h,0FFh
db 0F8h,0FFh
db 0FFh,01Fh
;
BAUTROISAO:;10
db 0FFh,0BFh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
db 0FFh,0BBh
db 0FEh,0EEh
db 0FFh,0BBh
db 0FCh,0EEh
;
CHAMDANGSONG:;11
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 099h,099h
db 0CCh,0CCh
db 099h,099h
db 033h,033h
db 0DDh,099h
;
MAKHONGTEN:;12
db 077h,0FFh
db 0D7h,0FFh
db 073h,0FFh
db 0D3h,0FFh
db 073h,0FFh
db 0D3h,0FFh
db 073h,0FFh
db 0D1h,0FFh
db 070h,0FFh
db 0D8h,07Fh
db 04Ch,03Fh
db 0C6h,01Fh
db 0C3h,00Fh
db 061h,087h
db 030h,0C3h
db 018h,061h
db 00Ch,030h
db 018h,061h
db 030h,0C3h
db 061h,087h
db 0C3h,00Fh
db 0C6h,01Fh
db 04Ch,03Fh
db 0D8h,07Fh
db 070h,0FFh
db 0D1h,0FFh
db 073h,0FFh
db 0D3h,0FFh
db 073h,0FFh
db 0D3h,0FFh
db 073h,0FFh
db 0D7h,0FFh
;
BACANHQUAT:;13
db 040h,03Fh
db 080h,07Fh
db 040h,0FFh
db 081h,0FFh
db 040h,000h
db 080h,001h
db 040h,003h
db 080h,007h
db 040h,00Fh
db 080h,01Fh
db 040h,03Fh
db 080h,07Fh
db 040h,0FFh
db 081h,0FFh
db 043h,0FFh
db 080h,000h
db 040h,001h
db 080h,003h
db 040h,007h
db 080h,00Fh
db 040h,01Fh
db 080h,03Fh
db 040h,07Fh
db 080h,0FFh
db 041h,0FFh
db 083h,0FFh
db 080h,000h
db 040h,001h
db 080h,003h
db 040h,007h
db 080h,00Fh
db 040h,01Fh
;
TIABONCANH:;XOAY VONG;14
db 000h,0FFh
db 083h,03Fh
db 00Fh,0FFh
db 0BFh,0CFh
db 07Fh,0FFh
db 0BFh,0CFh
db 00Fh,0FFh
db 083h,03Fh
db 000h,0FFh
db 083h,03Fh
db 00Fh,0FFh
db 0BFh,0CFh
db 07Fh,0FFh
db 0BFh,0CFh
db 00Fh,0FFh
db 083h,03Fh
db 000h,0FFh
db 083h,03Fh
db 00Fh,0FFh
db 0BFh,0CFh
db 07Fh,0FFh
db 0BFh,0CFh
db 00Fh,0FFh
db 083h,03Fh
db 000h,0FFh
db 083h,03Fh
db 00Fh,0FFh
db 0BFh,0CFh
db 07Fh,0FFh
db 0BFh,0CFh
db 00Fh,0FFh
db 083h,03Fh
;
TIA16NHANH:;17
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
db 0FFh,040h
db 000h,0BFh
;
HINHAMDUONG:;18 xoay vòng
db 000h,000h
db 0FFh,0FEh
db 0FFh,0FCh
db 0FFh,0F8h
db 0FFh,0F0h
db 0FFh,0E0h
db 0FFh,0C0h
db 0FFh,080h
db 0FFh,000h
db 0FEh,000h
db 0FCh,000h
db 0F8h,000h
db 0F0h,000h
db 0E0h,000h
db 0C0h,000h
db 080h,000h
db 000h,000h
db 0FFh,0FEh
db 0FFh,0FCh
db 0FFh,0F8h
db 0FFh,0F0h
db 0FFh,0E0h
db 0FFh,0C0h
db 0FFh,080h
db 0FFh,000h
db 0FEh,000h
db 0FCh,000h
db 0F8h,000h
db 0F0h,000h
db 0E0h,000h
db 0C0h,000h
db 080h,000h
;
HOABONCANH:;19
db 0FCh,000h
db 010h,003h
db 008h,00Ch
db 013h,030h
db 000h,0C0h
db 013h,030h
db 008h,00Ch
db 010h,003h
db 0C0h,000h
db 010h,003h
db 008h,00Ch
db 013h,030h
db 000h,0C0h
db 013h,030h
db 008h,00Ch
db 010h,003h
db 0C0h,000h
db 010h,003h
db 008h,00Ch
db 013h,030h
db 000h,0C0h
db 013h,030h
db 008h,00Ch
db 010h,003h
db 0C0h,000h
db 010h,003h
db 008h,00Ch
db 013h,030h
db 000h,0C0h
db 013h,030h
db 008h,00Ch
db 0D0h,003h
;
BATIAVONGCUNG:;xoay vong;20
db 0A0h,000h
db 05Fh,0F9h
db 0BFh,0F3h
db 05Fh,0E7h
db 0BFh,0CFh
db 05Fh,09Fh
db 0BFh,03Fh
db 05Eh,07Fh
db 0BCh,0FFh
db 059h,0FFh
db 0B3h,0FFh
db 040h,000h
db 0BFh,0F9h
db 05Fh,0F3h
db 0BFh,0E7h
db 05Fh,0CFh
db 0BFh,09Fh
db 05Fh,03Fh
db 0BEh,07Fh
db 05Ch,0FFh
db 0B9h,0FFh
db 053h,0FFh
db 0A0h,000h
db 05Fh,0F9h
db 0BFh,0F3h
db 05Fh,0E7h
db 0BFh,0CFh
db 05Fh,09Fh
db 0BFh,03Fh
db 05Eh,07Fh
db 0BCh,0FFh
db 059h,0FFh
;
BONCANHTIA5NHANH:;xoay vong;21
db 080h,000h
db 040h,003h
db 0A0h,00Fh
db 05Fh,0FFh
db 0BFh,0FFh
db 05Fh,0FFh
db 0A0h,00Fh
db 040h,003h
db 080h,000h
db 040h,003h
db 0A0h,00Fh
db 05Fh,0FFh
db 0BFh,0FFh
db 05Fh,0FFh
db 0A0h,00Fh
db 040h,003h
db 080h,000h
db 040h,003h
db 0A0h,00Fh
db 05Fh,0FFh
db 0BFh,0FFh
db 05Fh,0FFh
db 0A0h,00Fh
db 040h,003h
db 080h,000h
db 040h,003h
db 0A0h,00Fh
db 05Fh,0FFh
db 0BFh,0FFh
db 05Fh,0FFh
db 0A0h,00Fh
db 040h,003h
;
BATPHONG:;22
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h
db 0A2h,080h
db 043h,081h
db 0A2h,083h
db 040h,007h			  
;
HAIVONG8TIA:; 24 MA12TIA:  ;25 BANHXE6:   ;26
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
db 000h,000h
db 0FDh,0FEh
db 07Bh,0FEh
db 0FDh,0FEh
;
MAVONGCON:  ;25 BANHXE6:   ;26
db 03Eh,01Eh
db 05Dh,0EEh
db 03Bh,0F6h
db 05Ah,066h
db 039h,096h
db 05Bh,0F6h
db 03Dh,0EEh
db 05Eh,01Eh
db 03Eh,01Eh
db 05Dh,0EEh
db 03Bh,0F6h
db 05Ah,066h
db 039h,096h
db 05Bh,0F6h
db 03Dh,0EEh
db 05Eh,01Eh
db 03Eh,01Eh
db 05Dh,0EEh
db 03Bh,0F6h
db 05Ah,066h
db 039h,096h
db 05Bh,0F6h
db 03Dh,0EEh
db 05Eh,01Eh
db 03Eh,01Eh
db 05Dh,0EEh
db 03Bh,0F6h
db 05Ah,066h
db 039h,096h
db 05Bh,0F6h
db 03Dh,0EEh
db 05Eh,01Eh
;
BANHXE6:   ;26
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
db 080h,000h
db 000h,000h
db 0BFh,0FEh
db 03Fh,0FEh
;
CHAMHAI:
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
db 08Eh,038h
db 071h,0C7h
;
MA12VONG:
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh
db 0BFh,0FBh
db 000h,000h
db 0BFh,0FBh


		
END