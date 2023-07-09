
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _current_state=R5
	.DEF _height_from_ground=R4
	.DEF _current_floor=R7
	.DEF _door_open_degree=R6
	.DEF _open_door_wait=R9
	.DEF _inferared_trigered=R8
	.DEF _heavy_weight=R11
	.DEF _alarm=R10
	.DEF _destination_height=R13
	.DEF _destination_set=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x3,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x1E

_0x3:
	.DB  0x0,0xA,0x14,0x1E
_0x4:
	.DB  0x1
_0x5:
	.DB  0x3F,0x6,0x5B,0x4F

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _destination_heights
	.DW  _0x3*2

	.DW  0x01
	.DW  _monitor_on
	.DW  _0x4*2

	.DW  0x04
	.DW  _seg_code
	.DW  _0x5*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define OFF 0
;#define UP 1
;#define DOWN 2
;#define OPEN 1
;#define CLOSE 2
;
;#define NOT_BLINKING 0
;#define BLINKING 1
;
;unsigned char current_state = 3;
;//0: door should open
;//1: waiting before door close
;//2: closing the door
;//3: waiting for request
;//4: moving to request
;
;unsigned char height_from_ground = 0;
;unsigned char current_floor = 0;
;unsigned char door_open_degree = 0; // 0: close 20:full open
;unsigned char open_door_wait = 0;
;
;unsigned char inferared_trigered = 0;
;unsigned char heavy_weight = 0;
;unsigned char alarm = 0;
;
;unsigned char destination_heights[4] = {0, 10, 20, 30};

	.DSEG
;char destination_height = 30;
;char destination_set = 0;
;
;unsigned char current_door_motor_mode = OFF;
;unsigned char current_elevator_motor_mode = OFF;
;unsigned char monitor_blinking = NOT_BLINKING;
;unsigned char monitor_on = 1;
;unsigned char blink_time = 0;
;
;unsigned char requested[4] = {0, 0, 0, 0};
;unsigned char seg_code[4] = {0b00111111, 0b00000110, 0b01011011, 0b01001111};
;
;void read_inferared(){
; 0000 0029 void read_inferared(){

	.CSEG
_read_inferared:
; .FSTART _read_inferared
; 0000 002A     if (PINA.0 == 0){
	SBIC 0x19,0
	RJMP _0x6
; 0000 002B         inferared_trigered = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 002C     }
; 0000 002D }
_0x6:
	RET
; .FEND
;
;void read_alarm(){
; 0000 002F void read_alarm(){
_read_alarm:
; .FSTART _read_alarm
; 0000 0030     if (PINA.1 == 0){
	SBIC 0x19,1
	RJMP _0x7
; 0000 0031         alarm = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0032     }
; 0000 0033 }
_0x7:
	RET
; .FEND
;
;void read_heavyweight(){
; 0000 0035 void read_heavyweight(){
_read_heavyweight:
; .FSTART _read_heavyweight
; 0000 0036     if (PINA.2 == 0){
	SBIC 0x19,2
	RJMP _0x8
; 0000 0037         heavy_weight = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0038     }
; 0000 0039 }
_0x8:
	RET
; .FEND
;
;void read_buttons(){
; 0000 003B void read_buttons(){
_read_buttons:
; .FSTART _read_buttons
; 0000 003C     if (PINC.0 == 0 || PINC.1 == 0 || PINC.2 == 0 || PINC.3 == 0){
	SBIS 0x13,0
	RJMP _0xA
	SBIS 0x13,1
	RJMP _0xA
	SBIS 0x13,2
	RJMP _0xA
	SBIC 0x13,3
	RJMP _0x9
_0xA:
; 0000 003D         if (PINC.0 == 0){
	SBIC 0x13,0
	RJMP _0xC
; 0000 003E             requested[0] = 1;
	LDI  R30,LOW(1)
	STS  _requested,R30
; 0000 003F         }
; 0000 0040         if (PINC.1 == 0){
_0xC:
	SBIC 0x13,1
	RJMP _0xD
; 0000 0041             requested[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,1
; 0000 0042         }
; 0000 0043         if (PINC.2 == 0){
_0xD:
	SBIC 0x13,2
	RJMP _0xE
; 0000 0044             requested[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,2
; 0000 0045         }
; 0000 0046         if (PINC.3 == 0){
_0xE:
	SBIC 0x13,3
	RJMP _0xF
; 0000 0047             requested[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,3
; 0000 0048         }
; 0000 0049     }
_0xF:
; 0000 004A     else {
	RJMP _0x10
_0x9:
; 0000 004B         if (PINC.4 == 0){
	SBIC 0x13,4
	RJMP _0x11
; 0000 004C             requested[0] = 1;
	LDI  R30,LOW(1)
	STS  _requested,R30
; 0000 004D         }
; 0000 004E         if (PINC.5 == 0){
_0x11:
	SBIC 0x13,5
	RJMP _0x12
; 0000 004F             requested[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,1
; 0000 0050         }
; 0000 0051         if (PINC.6 == 0){
_0x12:
	SBIC 0x13,6
	RJMP _0x13
; 0000 0052             requested[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,2
; 0000 0053         }
; 0000 0054         if (PINC.7 == 0){
_0x13:
	SBIC 0x13,7
	RJMP _0x14
; 0000 0055             requested[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _requested,3
; 0000 0056         }
; 0000 0057     }
_0x14:
_0x10:
; 0000 0058 }
	RET
; .FEND
;
;void elevator_motor(int mode){
; 0000 005A void elevator_motor(int mode){
_elevator_motor:
; .FSTART _elevator_motor
; 0000 005B     unsigned char a;
; 0000 005C     unsigned char b;
; 0000 005D     if (mode == OFF){
	RCALL SUBOPT_0x0
;	mode -> Y+2
;	a -> R17
;	b -> R16
	BRNE _0x15
; 0000 005E         a = 0;
	LDI  R17,LOW(0)
; 0000 005F         b = 0;
	LDI  R16,LOW(0)
; 0000 0060     }
; 0000 0061     else{
	RJMP _0x16
_0x15:
; 0000 0062         if (mode == UP){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x17
; 0000 0063             height_from_ground++;
	INC  R4
; 0000 0064             a = 1;
	LDI  R17,LOW(1)
; 0000 0065             b = 0;
	LDI  R16,LOW(0)
; 0000 0066         }
; 0000 0067         else{
	RJMP _0x18
_0x17:
; 0000 0068              if (mode == DOWN){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x19
; 0000 0069                 height_from_ground--;
	DEC  R4
; 0000 006A                 a = 0;
	LDI  R17,LOW(0)
; 0000 006B                 a = 1;
	LDI  R17,LOW(1)
; 0000 006C             }
; 0000 006D         }
_0x19:
_0x18:
; 0000 006E     }
_0x16:
; 0000 006F 
; 0000 0070     if (current_elevator_motor_mode != mode){
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_current_elevator_motor_mode
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1A
; 0000 0071         PORTD.0 = a;
	CPI  R17,0
	BRNE _0x1B
	CBI  0x12,0
	RJMP _0x1C
_0x1B:
	SBI  0x12,0
_0x1C:
; 0000 0072         PORTD.1 = b;
	CPI  R16,0
	BRNE _0x1D
	CBI  0x12,1
	RJMP _0x1E
_0x1D:
	SBI  0x12,1
_0x1E:
; 0000 0073         current_elevator_motor_mode = mode;
	LDD  R30,Y+2
	STS  _current_elevator_motor_mode,R30
; 0000 0074     }
; 0000 0075 }
_0x1A:
	RJMP _0x2000002
; .FEND
;
;void door_motor(int mode){
; 0000 0077 void door_motor(int mode){
_door_motor:
; .FSTART _door_motor
; 0000 0078     unsigned char a;
; 0000 0079     unsigned char b;
; 0000 007A     if (mode == OFF){
	RCALL SUBOPT_0x0
;	mode -> Y+2
;	a -> R17
;	b -> R16
	BRNE _0x1F
; 0000 007B         a = 0;
	LDI  R17,LOW(0)
; 0000 007C         b = 0;
	LDI  R16,LOW(0)
; 0000 007D     }
; 0000 007E     else{
	RJMP _0x20
_0x1F:
; 0000 007F          if (mode == OPEN){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x21
; 0000 0080             door_open_degree++;
	INC  R6
; 0000 0081             a = 1;
	LDI  R17,LOW(1)
; 0000 0082             b = 0;
	LDI  R16,LOW(0)
; 0000 0083         }
; 0000 0084         else {
	RJMP _0x22
_0x21:
; 0000 0085                 if (mode == CLOSE){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x23
; 0000 0086                 door_open_degree--;
	DEC  R6
; 0000 0087                 a = 0;
	LDI  R17,LOW(0)
; 0000 0088                 b = 1;
	LDI  R16,LOW(1)
; 0000 0089             }
; 0000 008A         }
_0x23:
_0x22:
; 0000 008B     }
_0x20:
; 0000 008C 
; 0000 008D     if (current_door_motor_mode != mode){
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_current_door_motor_mode
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x24
; 0000 008E         PORTD.2 = a;
	CPI  R17,0
	BRNE _0x25
	CBI  0x12,2
	RJMP _0x26
_0x25:
	SBI  0x12,2
_0x26:
; 0000 008F         PORTD.3 = b;
	CPI  R16,0
	BRNE _0x27
	CBI  0x12,3
	RJMP _0x28
_0x27:
	SBI  0x12,3
_0x28:
; 0000 0090         current_door_motor_mode = mode;
	LDD  R30,Y+2
	STS  _current_door_motor_mode,R30
; 0000 0091     }
; 0000 0092 }
_0x24:
_0x2000002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void update_seven_segment(){
; 0000 0094 void update_seven_segment(){
_update_seven_segment:
; .FSTART _update_seven_segment
; 0000 0095     if (monitor_blinking == NOT_BLINKING){
	LDS  R30,_monitor_blinking
	CPI  R30,0
	BRNE _0x29
; 0000 0096         monitor_on = 1;
	LDI  R30,LOW(1)
	STS  _monitor_on,R30
; 0000 0097         blink_time = 0;
	LDI  R30,LOW(0)
	RJMP _0x56
; 0000 0098     }
; 0000 0099     else{
_0x29:
; 0000 009A         if (blink_time == 3){
	LDS  R26,_blink_time
	CPI  R26,LOW(0x3)
	BRNE _0x2B
; 0000 009B             blink_time = 0;
	LDI  R30,LOW(0)
	STS  _blink_time,R30
; 0000 009C             monitor_on = !monitor_on;
	LDS  R30,_monitor_on
	CALL __LNEGB1
	STS  _monitor_on,R30
; 0000 009D         }
; 0000 009E         else {
	RJMP _0x2C
_0x2B:
; 0000 009F             blink_time++;
	LDS  R30,_blink_time
	SUBI R30,-LOW(1)
_0x56:
	STS  _blink_time,R30
; 0000 00A0         }
_0x2C:
; 0000 00A1     }
; 0000 00A2 
; 0000 00A3 
; 0000 00A4     if (monitor_on){
	LDS  R30,_monitor_on
	CPI  R30,0
	BREQ _0x2D
; 0000 00A5         PORTB = seg_code[current_floor];
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_seg_code)
	SBCI R31,HIGH(-_seg_code)
	LD   R30,Z
	RJMP _0x57
; 0000 00A6     }
; 0000 00A7     else{
_0x2D:
; 0000 00A8         PORTB = 0x00;
	LDI  R30,LOW(0)
_0x57:
	OUT  0x18,R30
; 0000 00A9     }
; 0000 00AA }
	RET
; .FEND
;
;// do
;void set_destination(){
; 0000 00AD void set_destination(){
_set_destination:
; .FSTART _set_destination
; 0000 00AE     signed int i_best;
; 0000 00AF     signed int d = 1000;
; 0000 00B0     signed int dtemp;
; 0000 00B1     signed int found = 0;
; 0000 00B2 
; 0000 00B3     unsigned char i;
; 0000 00B4     for (i=0; i<4; i++){
	SBIW R28,3
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	CALL __SAVELOCR6
;	i_best -> R16,R17
;	d -> R18,R19
;	dtemp -> R20,R21
;	found -> Y+7
;	i -> Y+6
	__GETWRN 18,19,1000
	STD  Y+6,R30
_0x30:
	LDD  R26,Y+6
	CPI  R26,LOW(0x4)
	BRSH _0x31
; 0000 00B5         if (requested[i]){
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_requested)
	SBCI R31,HIGH(-_requested)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x32
; 0000 00B6             if (height_from_ground < destination_heights[i]){
	RCALL SUBOPT_0x1
	LD   R30,Z
	CP   R4,R30
	BRSH _0x33
; 0000 00B7                 dtemp = destination_heights[i] - height_from_ground;
	RCALL SUBOPT_0x1
	LD   R26,Z
	LDI  R27,0
	MOV  R30,R4
	RJMP _0x58
; 0000 00B8             }
; 0000 00B9             else {
_0x33:
; 0000 00BA                 dtemp = height_from_ground - destination_heights[i];
	MOV  R26,R4
	CLR  R27
	RCALL SUBOPT_0x1
	LD   R30,Z
_0x58:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
; 0000 00BB             }
; 0000 00BC 
; 0000 00BD             if (dtemp < d){
	__CPWRR 20,21,18,19
	BRGE _0x35
; 0000 00BE                 found = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+7,R30
	STD  Y+7+1,R31
; 0000 00BF                 i_best = i;
	LDD  R16,Y+6
	CLR  R17
; 0000 00C0                 d = dtemp;
	MOVW R18,R20
; 0000 00C1             }
; 0000 00C2         }
_0x35:
; 0000 00C3     }
_0x32:
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x30
_0x31:
; 0000 00C4     if (found == 1){
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SBIW R26,1
	BRNE _0x36
; 0000 00C5         destination_height = destination_heights[i_best];
	LDI  R26,LOW(_destination_heights)
	LDI  R27,HIGH(_destination_heights)
	ADD  R26,R16
	ADC  R27,R17
	LD   R13,X
; 0000 00C6         destination_set = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 00C7         return;
; 0000 00C8     }
; 0000 00C9 }
_0x36:
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,9
	RET
; .FEND
;
;unsigned char closest_floor_height(){
; 0000 00CB unsigned char closest_floor_height(){
_closest_floor_height:
; .FSTART _closest_floor_height
; 0000 00CC     unsigned char result = (height_from_ground / 10)*10;
; 0000 00CD     if (height_from_ground < destination_height){
	ST   -Y,R17
;	result -> R17
	RCALL SUBOPT_0x2
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R17,R30
	CP   R4,R13
	BRSH _0x37
; 0000 00CE         result += 10;
	SUBI R17,-LOW(10)
; 0000 00CF     }
; 0000 00D0     return result;
_0x37:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00D1 }
; .FEND
;
;void time_interupt(){
; 0000 00D3 void time_interupt(){
_time_interupt:
; .FSTART _time_interupt
; 0000 00D4     update_seven_segment();
	RCALL _update_seven_segment
; 0000 00D5 
; 0000 00D6     // door opening
; 0000 00D7     if (current_state == 0){
	TST  R5
	BRNE _0x38
; 0000 00D8         monitor_blinking = BLINKING;
	LDI  R30,LOW(1)
	STS  _monitor_blinking,R30
; 0000 00D9         if (door_open_degree < 20){
	LDI  R30,LOW(20)
	CP   R6,R30
	BRSH _0x39
; 0000 00DA             door_motor(OPEN);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _door_motor
; 0000 00DB         }
; 0000 00DC         else{
	RJMP _0x3A
_0x39:
; 0000 00DD             door_motor(OFF);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _door_motor
; 0000 00DE             open_door_wait = 10;
	LDI  R30,LOW(10)
	MOV  R9,R30
; 0000 00DF             current_state = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00E0         }
_0x3A:
; 0000 00E1         return;
	RET
; 0000 00E2     }
; 0000 00E3 
; 0000 00E4     // waiting door opened
; 0000 00E5     if (current_state == 1){
_0x38:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x3B
; 0000 00E6         if (open_door_wait > 0){
	LDI  R30,LOW(0)
	CP   R30,R9
	BRSH _0x3C
; 0000 00E7             open_door_wait--;
	DEC  R9
; 0000 00E8         }
; 0000 00E9         else{
	RJMP _0x3D
_0x3C:
; 0000 00EA             current_state = 2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 00EB         }
_0x3D:
; 0000 00EC         return;
	RET
; 0000 00ED     }
; 0000 00EE 
; 0000 00EF     // door closing
; 0000 00F0     if (current_state == 2){
_0x3B:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x3E
; 0000 00F1         read_inferared();
	RCALL _read_inferared
; 0000 00F2         if (inferared_trigered == 1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x3F
; 0000 00F3             inferared_trigered = 0;
	CLR  R8
; 0000 00F4             current_state = 0;
	CLR  R5
; 0000 00F5         }
; 0000 00F6         else {
	RJMP _0x40
_0x3F:
; 0000 00F7             if(door_open_degree > 0){
	LDI  R30,LOW(0)
	CP   R30,R6
	BRSH _0x41
; 0000 00F8                 door_motor(CLOSE);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _door_motor
; 0000 00F9             }
; 0000 00FA             else {
	RJMP _0x42
_0x41:
; 0000 00FB                 door_motor(OFF);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _door_motor
; 0000 00FC                 current_state = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 00FD             }
_0x42:
; 0000 00FE         }
_0x40:
; 0000 00FF         return;
	RET
; 0000 0100     }
; 0000 0101 
; 0000 0102     // choosing next destination
; 0000 0103     if (current_state == 3){
_0x3E:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x43
; 0000 0104         read_alarm();
	RCALL _read_alarm
; 0000 0105         read_heavyweight();
	RCALL _read_heavyweight
; 0000 0106         monitor_blinking = NOT_BLINKING;
	LDI  R30,LOW(0)
	STS  _monitor_blinking,R30
; 0000 0107         if (alarm == 1 || heavy_weight == 1){
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x45
	CP   R30,R11
	BRNE _0x44
_0x45:
; 0000 0108             destination_height = height_from_ground;
	MOV  R13,R4
; 0000 0109             destination_set = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 010A             current_state = 4;
	RJMP _0x59
; 0000 010B         }
; 0000 010C         else {
_0x44:
; 0000 010D             if (!destination_set){
	TST  R12
	BRNE _0x48
; 0000 010E                 read_buttons();
	RCALL _read_buttons
; 0000 010F                 set_destination();
	RCALL _set_destination
; 0000 0110                 current_state = 3;
	LDI  R30,LOW(3)
	RJMP _0x5A
; 0000 0111             }
; 0000 0112             else{
_0x48:
; 0000 0113                 current_state = 4;
_0x59:
	LDI  R30,LOW(4)
_0x5A:
	MOV  R5,R30
; 0000 0114             }
; 0000 0115         }
; 0000 0116         return;
	RET
; 0000 0117     }
; 0000 0118 
; 0000 0119     // moving to next destination
; 0000 011A     if (current_state == 4){
_0x43:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x4A
; 0000 011B         read_alarm();
	RCALL _read_alarm
; 0000 011C         read_heavyweight();
	RCALL _read_heavyweight
; 0000 011D         // update current floor
; 0000 011E         if (height_from_ground % 10 == 0){
	MOV  R26,R4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x4B
; 0000 011F             current_floor = height_from_ground / 10;
	RCALL SUBOPT_0x2
	MOV  R7,R30
; 0000 0120         }
; 0000 0121 
; 0000 0122         if (heavy_weight == 1){
_0x4B:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x4C
; 0000 0123             heavy_weight = 0;
	CLR  R11
; 0000 0124             alarm = 1;
	MOV  R10,R30
; 0000 0125         }
; 0000 0126 
; 0000 0127         if (alarm == 1){
_0x4C:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x4D
; 0000 0128             destination_height = closest_floor_height();
	RCALL _closest_floor_height
	MOV  R13,R30
; 0000 0129             alarm = 0;
	CLR  R10
; 0000 012A         }
; 0000 012B 
; 0000 012C         if (height_from_ground < destination_height){
_0x4D:
	CP   R4,R13
	BRSH _0x4E
; 0000 012D             elevator_motor(UP);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _elevator_motor
; 0000 012E         }
; 0000 012F         else{
	RJMP _0x4F
_0x4E:
; 0000 0130              if (height_from_ground > destination_height){
	CP   R13,R4
	BRSH _0x50
; 0000 0131                 elevator_motor(DOWN);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _elevator_motor
; 0000 0132             }
; 0000 0133             else {
	RJMP _0x51
_0x50:
; 0000 0134                 elevator_motor(OFF);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _elevator_motor
; 0000 0135                 requested[height_from_ground/10] = 0;// removing request
	RCALL SUBOPT_0x2
	SUBI R30,LOW(-_requested)
	SBCI R31,HIGH(-_requested)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0136                 destination_set = 0;// removing destination
	CLR  R12
; 0000 0137                 current_state = 0;
	CLR  R5
; 0000 0138             }
_0x51:
; 0000 0139         }
_0x4F:
; 0000 013A         return;
	RET
; 0000 013B     }
; 0000 013C }
_0x4A:
	RET
; .FEND
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 013F interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0140 // Reinitialize Timer 0 value
; 0000 0141    TCNT0=0x9E;
	LDI  R30,LOW(158)
	OUT  0x32,R30
; 0000 0142    time_interupt();
	RCALL _time_interupt
; 0000 0143 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;void main(void)
; 0000 0147 {
_main:
; .FSTART _main
; 0000 0148 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0149 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 014A 
; 0000 014B DDRB=0xff;
	OUT  0x17,R30
; 0000 014C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 014D 
; 0000 014E DDRC=0x00;
	OUT  0x14,R30
; 0000 014F PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0150 
; 0000 0151 DDRD=0xff;
	OUT  0x11,R30
; 0000 0152 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0153 
; 0000 0154 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0155 TCNT0=0x9E;
	LDI  R30,LOW(158)
	OUT  0x32,R30
; 0000 0156 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0157 
; 0000 0158 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0159 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 015A 
; 0000 015B // Global enable interrupts
; 0000 015C #asm("sei")
	sei
; 0000 015D 
; 0000 015E while (1){
_0x52:
; 0000 015F }
	RJMP _0x52
; 0000 0160 }
_0x55:
	RJMP _0x55
; .FEND

	.DSEG
_destination_heights:
	.BYTE 0x4
_current_door_motor_mode:
	.BYTE 0x1
_current_elevator_motor_mode:
	.BYTE 0x1
_monitor_blinking:
	.BYTE 0x1
_monitor_on:
	.BYTE 0x1
_blink_time:
	.BYTE 0x1
_requested:
	.BYTE 0x4
_seg_code:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_destination_heights)
	SBCI R31,HIGH(-_destination_heights)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
