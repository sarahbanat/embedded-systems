
_myDelay:

;FinalCode_LockDoorSystem.c,24 :: 		void myDelay(unsigned int x){  //this delay will give delays in seconds depending on value (x) sent to it
;FinalCode_LockDoorSystem.c,25 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;FinalCode_LockDoorSystem.c,26 :: 		for(tick=0;tick<x;tick++) {
	CLRF       _tick+0
	CLRF       _tick+1
L_myDelay0:
	MOVF       FARG_myDelay_x+1, 0
	SUBWF      _tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay89
	MOVF       FARG_myDelay_x+0, 0
	SUBWF      _tick+0, 0
L__myDelay89:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay1
;FinalCode_LockDoorSystem.c,27 :: 		for (count8=0;count8<2000;count8++);
	CLRF       _count8+0
	CLRF       _count8+1
	CLRF       _count8+2
	CLRF       _count8+3
L_myDelay3:
	MOVLW      0
	SUBWF      _count8+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay90
	MOVLW      0
	SUBWF      _count8+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay90
	MOVLW      7
	SUBWF      _count8+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay90
	MOVLW      208
	SUBWF      _count8+0, 0
L__myDelay90:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay4
	MOVF       _count8+0, 0
	MOVWF      R0+0
	MOVF       _count8+1, 0
	MOVWF      R0+1
	MOVF       _count8+2, 0
	MOVWF      R0+2
	MOVF       _count8+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _count8+0
	MOVF       R0+1, 0
	MOVWF      _count8+1
	MOVF       R0+2, 0
	MOVWF      _count8+2
	MOVF       R0+3, 0
	MOVWF      _count8+3
	GOTO       L_myDelay3
L_myDelay4:
;FinalCode_LockDoorSystem.c,26 :: 		for(tick=0;tick<x;tick++) {
	INCF       _tick+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick+1, 1
;FinalCode_LockDoorSystem.c,28 :: 		}
	GOTO       L_myDelay0
L_myDelay1:
;FinalCode_LockDoorSystem.c,29 :: 		}
L_end_myDelay:
	RETURN
; end of _myDelay

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;FinalCode_LockDoorSystem.c,30 :: 		void interrupt(void){
;FinalCode_LockDoorSystem.c,47 :: 		if(PIR1&0x04){//CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt6
;FinalCode_LockDoorSystem.c,48 :: 		if(HL){ //high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
;FinalCode_LockDoorSystem.c,49 :: 		CCPR1H= angle >>8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;FinalCode_LockDoorSystem.c,50 :: 		CCPR1L= angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;FinalCode_LockDoorSystem.c,51 :: 		HL=0;//next time low
	CLRF       _HL+0
;FinalCode_LockDoorSystem.c,52 :: 		CCP1CON=0x09;//next time Falling edge
	MOVLW      9
	MOVWF      CCP1CON+0
;FinalCode_LockDoorSystem.c,53 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode_LockDoorSystem.c,54 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode_LockDoorSystem.c,55 :: 		}
	GOTO       L_interrupt8
L_interrupt7:
;FinalCode_LockDoorSystem.c,57 :: 		CCPR1H= (40000 - angle) >>8;
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;FinalCode_LockDoorSystem.c,58 :: 		CCPR1L= (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;FinalCode_LockDoorSystem.c,59 :: 		CCP1CON=0x08; //next time rising edge
	MOVLW      8
	MOVWF      CCP1CON+0
;FinalCode_LockDoorSystem.c,60 :: 		HL=1; //next time High
	MOVLW      1
	MOVWF      _HL+0
;FinalCode_LockDoorSystem.c,61 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode_LockDoorSystem.c,62 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode_LockDoorSystem.c,64 :: 		}
L_interrupt8:
;FinalCode_LockDoorSystem.c,65 :: 		PIR1=PIR1&0xFB; //CLEAR CCP1 Interrupt Flag
	MOVLW      251
	ANDWF      PIR1+0, 1
;FinalCode_LockDoorSystem.c,66 :: 		}
L_interrupt6:
;FinalCode_LockDoorSystem.c,68 :: 		}
L_end_interrupt:
L__interrupt92:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_LCDdata:

;FinalCode_LockDoorSystem.c,71 :: 		void LCDdata(char data1)
;FinalCode_LockDoorSystem.c,73 :: 		PORTD = data1;
	MOVF       FARG_LCDdata_data1+0, 0
	MOVWF      PORTD+0
;FinalCode_LockDoorSystem.c,74 :: 		PORTC= PORTC | 0x20;//RS=01;
	BSF        PORTC+0, 5
;FinalCode_LockDoorSystem.c,75 :: 		PORTC = PORTC & 0xBF;//RW=00;
	MOVLW      191
	ANDWF      PORTC+0, 1
;FinalCode_LockDoorSystem.c,76 :: 		PORTC = PORTC | 0x80;//EN=01;
	BSF        PORTC+0, 7
;FinalCode_LockDoorSystem.c,77 :: 		myDelay(500);
	MOVLW      244
	MOVWF      FARG_myDelay_x+0
	MOVLW      1
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,78 :: 		PORTC = PORTC & 0x7F;//EN=00;
	MOVLW      127
	ANDWF      PORTC+0, 1
;FinalCode_LockDoorSystem.c,79 :: 		}
L_end_LCDdata:
	RETURN
; end of _LCDdata

_LCDcommand:

;FinalCode_LockDoorSystem.c,80 :: 		void LCDcommand(unsigned char command)
;FinalCode_LockDoorSystem.c,82 :: 		PORTD=command;
	MOVF       FARG_LCDcommand_command+0, 0
	MOVWF      PORTD+0
;FinalCode_LockDoorSystem.c,83 :: 		PORTC = PORTC & 0xDF;//RS=0;
	MOVLW      223
	ANDWF      PORTC+0, 1
;FinalCode_LockDoorSystem.c,84 :: 		PORTC = PORTC & 0xBF;//RW=00;
	MOVLW      191
	ANDWF      PORTC+0, 1
;FinalCode_LockDoorSystem.c,85 :: 		PORTC = PORTC | 0x80;//EN=01;
	BSF        PORTC+0, 7
;FinalCode_LockDoorSystem.c,86 :: 		myDelay(500);
	MOVLW      244
	MOVWF      FARG_myDelay_x+0
	MOVLW      1
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,87 :: 		PORTC = PORTC & 0x7F;//EN=00;
	MOVLW      127
	ANDWF      PORTC+0, 1
;FinalCode_LockDoorSystem.c,88 :: 		}
L_end_LCDcommand:
	RETURN
; end of _LCDcommand

_LCDout:

;FinalCode_LockDoorSystem.c,89 :: 		void LCDout(const unsigned char *string, unsigned char length)
;FinalCode_LockDoorSystem.c,92 :: 		for(k=0;k<length;k++)
	CLRF       LCDout_k_L0+0
L_LCDout9:
	MOVF       FARG_LCDout_length+0, 0
	SUBWF      LCDout_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_LCDout10
;FinalCode_LockDoorSystem.c,94 :: 		LCDdata(string[k]);
	MOVF       LCDout_k_L0+0, 0
	ADDWF      FARG_LCDout_string+0, 0
	MOVWF      R0+0
	MOVF       FARG_LCDout_string+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_LCDdata_data1+0
	CALL       _LCDdata+0
;FinalCode_LockDoorSystem.c,92 :: 		for(k=0;k<length;k++)
	INCF       LCDout_k_L0+0, 1
;FinalCode_LockDoorSystem.c,95 :: 		}
	GOTO       L_LCDout9
L_LCDout10:
;FinalCode_LockDoorSystem.c,96 :: 		}
L_end_LCDout:
	RETURN
; end of _LCDout

_LCDinit:

;FinalCode_LockDoorSystem.c,97 :: 		void LCDinit()
;FinalCode_LockDoorSystem.c,99 :: 		LCDcommand(0x38);   //2 lines and 5*7 matrix
	MOVLW      56
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,100 :: 		LCDcommand(0x06);   // Shift cursor to right
	MOVLW      6
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,101 :: 		LCDcommand(0x0C);   // Force cursor to begin on the second line
	MOVLW      12
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,102 :: 		LCDcommand(0x01);   // Shift cursor position to left
	MOVLW      1
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,103 :: 		}
L_end_LCDinit:
	RETURN
; end of _LCDinit

_resetpass:

;FinalCode_LockDoorSystem.c,108 :: 		int resetpass()
;FinalCode_LockDoorSystem.c,111 :: 		LCDinit();
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,112 :: 		LCDcommand(0x80);
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,113 :: 		LCDout("RESET...", 8);
	MOVLW      ?lstr_1_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_1_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      8
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,114 :: 		myDelay(3);
	MOVLW      3
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,115 :: 		asm goto 0x00;
	GOTO       0
;FinalCode_LockDoorSystem.c,117 :: 		return 0;
	CLRF       R0+0
	CLRF       R0+1
;FinalCode_LockDoorSystem.c,118 :: 		}
L_end_resetpass:
	RETURN
; end of _resetpass

_doorcontrol:

;FinalCode_LockDoorSystem.c,120 :: 		void doorcontrol()
;FinalCode_LockDoorSystem.c,122 :: 		TMR0 = 248;
	MOVLW      248
	MOVWF      TMR0+0
;FinalCode_LockDoorSystem.c,125 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode_LockDoorSystem.c,126 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode_LockDoorSystem.c,128 :: 		HL=1; //start high
	MOVLW      1
	MOVWF      _HL+0
;FinalCode_LockDoorSystem.c,129 :: 		CCP1CON=0x08;//
	MOVLW      8
	MOVWF      CCP1CON+0
;FinalCode_LockDoorSystem.c,131 :: 		T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;FinalCode_LockDoorSystem.c,133 :: 		INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
	MOVLW      240
	MOVWF      INTCON+0
;FinalCode_LockDoorSystem.c,134 :: 		PIE1=PIE1|0x04;// Enable CCP1 interrupts
	BSF        PIE1+0, 2
;FinalCode_LockDoorSystem.c,135 :: 		CCPR1H=2000>>8;
	MOVLW      7
	MOVWF      CCPR1H+0
;FinalCode_LockDoorSystem.c,136 :: 		CCPR1L=2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;FinalCode_LockDoorSystem.c,138 :: 		angle=1100;
	MOVLW      76
	MOVWF      _angle+0
	MOVLW      4
	MOVWF      _angle+1
;FinalCode_LockDoorSystem.c,139 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,140 :: 		angle=3600;
	MOVLW      16
	MOVWF      _angle+0
	MOVLW      14
	MOVWF      _angle+1
;FinalCode_LockDoorSystem.c,142 :: 		}
L_end_doorcontrol:
	RETURN
; end of _doorcontrol

_checkpass:

;FinalCode_LockDoorSystem.c,144 :: 		void checkpass()
;FinalCode_LockDoorSystem.c,146 :: 		if(pass[0]=='1' && pass[1]=='2' && pass[2]=='3' && pass[3]=='4')
	MOVF       _pass+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_checkpass14
	MOVF       _pass+1, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_checkpass14
	MOVF       _pass+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_checkpass14
	MOVF       _pass+3, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_checkpass14
L__checkpass77:
;FinalCode_LockDoorSystem.c,149 :: 		LCDinit(); //initialize LCD screen
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,150 :: 		LCDcommand(0x80);    //Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,151 :: 		LCDout("DOOR IS OPENED", 14);
	MOVLW      ?lstr_2_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_2_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      14
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,152 :: 		PORTA=0x04; //turn on green led
	MOVLW      4
	MOVWF      PORTA+0
;FinalCode_LockDoorSystem.c,154 :: 		doorcontrol();
	CALL       _doorcontrol+0
;FinalCode_LockDoorSystem.c,155 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,156 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,159 :: 		asm goto 0x00;
	GOTO       0
;FinalCode_LockDoorSystem.c,161 :: 		}
	GOTO       L_checkpass15
L_checkpass14:
;FinalCode_LockDoorSystem.c,165 :: 		{   count++;    //count=count+1 (each time an entered password is incorrect)
	INCF       _count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _count+1, 1
;FinalCode_LockDoorSystem.c,170 :: 		if (count%4==0 )   // check if password was enterred incorrectly for 3 times, each time
	MOVLW      3
	ANDWF      _count+0, 0
	MOVWF      R1+0
	MOVF       _count+1, 0
	MOVWF      R1+1
	MOVLW      0
	ANDWF      R1+1, 1
	MOVLW      0
	XORWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass100
	MOVLW      0
	XORWF      R1+0, 0
L__checkpass100:
	BTFSS      STATUS+0, 2
	GOTO       L_checkpass16
;FinalCode_LockDoorSystem.c,171 :: 		{   LCDinit();  //initialize LED screen
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,172 :: 		LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,173 :: 		LCDout("processing",10);
	MOVLW      ?lstr_3_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_3_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      10
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,174 :: 		for(k=0;k<1000;k++)
	CLRF       _k+0
	CLRF       _k+1
L_checkpass17:
	MOVLW      3
	SUBWF      _k+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass101
	MOVLW      232
	SUBWF      _k+0, 0
L__checkpass101:
	BTFSC      STATUS+0, 0
	GOTO       L_checkpass18
;FinalCode_LockDoorSystem.c,176 :: 		if (INTCON & 0x04) {  // check if the interrupt was caused by RB0
	BTFSS      INTCON+0, 2
	GOTO       L_checkpass20
;FinalCode_LockDoorSystem.c,178 :: 		LCDinit();  //initialize LED screen
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,179 :: 		LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,180 :: 		LCDout("ALARM ON", 8);          //if PIR((RA5)==1 check touch sensor and password was entered incorrectly 3 times
	MOVLW      ?lstr_4_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_4_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      8
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,182 :: 		PORTA=0x03; //turn on buzzer and red led
	MOVLW      3
	MOVWF      PORTA+0
;FinalCode_LockDoorSystem.c,184 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,186 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,188 :: 		INTCON &= ~(0x04);  // clear the interrupt flag
	BCF        INTCON+0, 2
;FinalCode_LockDoorSystem.c,189 :: 		asm goto 0x00;
	GOTO       0
;FinalCode_LockDoorSystem.c,190 :: 		}
L_checkpass20:
;FinalCode_LockDoorSystem.c,191 :: 		for(v=0;v<1000;v++)
	CLRF       _v+0
	CLRF       _v+1
L_checkpass21:
	MOVLW      3
	SUBWF      _v+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass102
	MOVLW      232
	SUBWF      _v+0, 0
L__checkpass102:
	BTFSC      STATUS+0, 0
	GOTO       L_checkpass22
;FinalCode_LockDoorSystem.c,194 :: 		if (INTCON & 0x04) {  // check if the interrupt was caused by RB0
	BTFSS      INTCON+0, 2
	GOTO       L_checkpass24
;FinalCode_LockDoorSystem.c,196 :: 		LCDinit();  //initialize LED screen
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,197 :: 		LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,198 :: 		LCDout("ALARM ON", 8);          //if PIR((RA5)==1 check touch sensor and password was entered incorrectly 3 times
	MOVLW      ?lstr_5_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_5_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      8
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,200 :: 		PORTA=0x03; //turn on buzzer and red led
	MOVLW      3
	MOVWF      PORTA+0
;FinalCode_LockDoorSystem.c,202 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,204 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,206 :: 		INTCON &= ~(0x04);  // clear the interrupt flag
	BCF        INTCON+0, 2
;FinalCode_LockDoorSystem.c,207 :: 		asm goto 0x00;
	GOTO       0
;FinalCode_LockDoorSystem.c,208 :: 		}
L_checkpass24:
;FinalCode_LockDoorSystem.c,191 :: 		for(v=0;v<1000;v++)
	INCF       _v+0, 1
	BTFSC      STATUS+0, 2
	INCF       _v+1, 1
;FinalCode_LockDoorSystem.c,209 :: 		}
	GOTO       L_checkpass21
L_checkpass22:
;FinalCode_LockDoorSystem.c,174 :: 		for(k=0;k<1000;k++)
	INCF       _k+0, 1
	BTFSC      STATUS+0, 2
	INCF       _k+1, 1
;FinalCode_LockDoorSystem.c,210 :: 		}
	GOTO       L_checkpass17
L_checkpass18:
;FinalCode_LockDoorSystem.c,212 :: 		LCDinit();
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,213 :: 		LCDcommand(0x80); // Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,214 :: 		LCDout("INCORRECT", 9);
	MOVLW      ?lstr_6_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_6_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      9
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,215 :: 		for(k=0;k<10;k++)
	CLRF       _k+0
	CLRF       _k+1
L_checkpass25:
	MOVLW      0
	SUBWF      _k+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass103
	MOVLW      10
	SUBWF      _k+0, 0
L__checkpass103:
	BTFSC      STATUS+0, 0
	GOTO       L_checkpass26
;FinalCode_LockDoorSystem.c,217 :: 		PORTA=0x02;
	MOVLW      2
	MOVWF      PORTA+0
;FinalCode_LockDoorSystem.c,218 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,219 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,215 :: 		for(k=0;k<10;k++)
	INCF       _k+0, 1
	BTFSC      STATUS+0, 2
	INCF       _k+1, 1
;FinalCode_LockDoorSystem.c,220 :: 		}
	GOTO       L_checkpass25
L_checkpass26:
;FinalCode_LockDoorSystem.c,222 :: 		asm goto 0x00;
	GOTO       0
;FinalCode_LockDoorSystem.c,226 :: 		}
	GOTO       L_checkpass28
L_checkpass16:
;FinalCode_LockDoorSystem.c,227 :: 		else if(count%3!=0)
	MOVLW      3
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _count+0, 0
	MOVWF      R0+0
	MOVF       _count+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass104
	MOVLW      0
	XORWF      R0+0, 0
L__checkpass104:
	BTFSC      STATUS+0, 2
	GOTO       L_checkpass29
;FinalCode_LockDoorSystem.c,229 :: 		LCDinit();
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,230 :: 		LCDcommand(0x80); // Force cursor to the beginning ( 1st line)
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,231 :: 		LCDout("INCORRECT", 9);
	MOVLW      ?lstr_7_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_7_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      9
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,232 :: 		for(k=0;k<10;k++)
	CLRF       _k+0
	CLRF       _k+1
L_checkpass30:
	MOVLW      0
	SUBWF      _k+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkpass105
	MOVLW      10
	SUBWF      _k+0, 0
L__checkpass105:
	BTFSC      STATUS+0, 0
	GOTO       L_checkpass31
;FinalCode_LockDoorSystem.c,234 :: 		PORTA=0x02;
	MOVLW      2
	MOVWF      PORTA+0
;FinalCode_LockDoorSystem.c,235 :: 		myDelay(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_x+0
	MOVLW      19
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,236 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,232 :: 		for(k=0;k<10;k++)
	INCF       _k+0, 1
	BTFSC      STATUS+0, 2
	INCF       _k+1, 1
;FinalCode_LockDoorSystem.c,237 :: 		}
	GOTO       L_checkpass30
L_checkpass31:
;FinalCode_LockDoorSystem.c,239 :: 		myDelay(2000);
	MOVLW      208
	MOVWF      FARG_myDelay_x+0
	MOVLW      7
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,241 :: 		asm goto 0x00
	GOTO       0
;FinalCode_LockDoorSystem.c,244 :: 		}
L_checkpass29:
L_checkpass28:
;FinalCode_LockDoorSystem.c,246 :: 		}
L_checkpass15:
;FinalCode_LockDoorSystem.c,247 :: 		}
L_end_checkpass:
	RETURN
; end of _checkpass

_key:

;FinalCode_LockDoorSystem.c,250 :: 		unsigned char key() {
;FinalCode_LockDoorSystem.c,252 :: 		PORTB=0X00;
	CLRF       PORTB+0
;FinalCode_LockDoorSystem.c,255 :: 		while(COL1&&COL2&&COL3);
L_key33:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_key34
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_key34
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_key34
L__key87:
	GOTO       L_key33
L_key34:
;FinalCode_LockDoorSystem.c,258 :: 		while(!COL1||!COL2||!COL3) { //is checking if any of the column pins (COL1, COL2, COL3) are low. This means that if any of the column pins are connected to a button that is being pressed, the loop will continue to execute.
L_key37:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key86
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key86
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key86
	GOTO       L_key38
L__key86:
;FinalCode_LockDoorSystem.c,260 :: 		ROW1=0;
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
;FinalCode_LockDoorSystem.c,261 :: 		ROW2=ROW3=ROW4=1;
	BSF        RB7_bit+0, BitPos(RB7_bit+0)
	BTFSC      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L__key107
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key108
L__key107:
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
L__key108:
	BTFSC      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key109
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key110
L__key109:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__key110:
;FinalCode_LockDoorSystem.c,263 :: 		if(!COL1||!COL2||!COL3) {
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key85
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key85
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key85
	GOTO       L_key43
L__key85:
;FinalCode_LockDoorSystem.c,264 :: 		myDelay(0.1);
	CLRF       FARG_myDelay_x+0
	CLRF       FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,266 :: 		rownum=0;
	CLRF       _rownum+0
;FinalCode_LockDoorSystem.c,267 :: 		break;
	GOTO       L_key38
;FinalCode_LockDoorSystem.c,268 :: 		}
L_key43:
;FinalCode_LockDoorSystem.c,270 :: 		ROW2=0;ROW1=ROW3=ROW4=1;
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	BSF        RB7_bit+0, BitPos(RB7_bit+0)
	BTFSC      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L__key111
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key112
L__key111:
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
L__key112:
	BTFSC      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key113
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key114
L__key113:
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
L__key114:
;FinalCode_LockDoorSystem.c,272 :: 		if(!COL1||!COL2||!COL3) {
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key84
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key84
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key84
	GOTO       L_key46
L__key84:
;FinalCode_LockDoorSystem.c,273 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,275 :: 		rownum=1;
	MOVLW      1
	MOVWF      _rownum+0
;FinalCode_LockDoorSystem.c,276 :: 		break;
	GOTO       L_key38
;FinalCode_LockDoorSystem.c,277 :: 		}
L_key46:
;FinalCode_LockDoorSystem.c,279 :: 		ROW3=0;ROW2=ROW1=ROW4=1;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
	BSF        RB7_bit+0, BitPos(RB7_bit+0)
	BTFSC      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L__key115
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key116
L__key115:
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
L__key116:
	BTFSC      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key117
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key118
L__key117:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__key118:
;FinalCode_LockDoorSystem.c,281 :: 		if(!COL1||!COL2||!COL3) {
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key83
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key83
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key83
	GOTO       L_key49
L__key83:
;FinalCode_LockDoorSystem.c,282 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,284 :: 		rownum=2;
	MOVLW      2
	MOVWF      _rownum+0
;FinalCode_LockDoorSystem.c,285 :: 		break;
	GOTO       L_key38
;FinalCode_LockDoorSystem.c,286 :: 		}
L_key49:
;FinalCode_LockDoorSystem.c,288 :: 		ROW4=0; ROW1=ROW2=ROW3=1;
	BCF        RB7_bit+0, BitPos(RB7_bit+0)
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
	BTFSC      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key119
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key120
L__key119:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__key120:
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key121
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key122
L__key121:
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
L__key122:
;FinalCode_LockDoorSystem.c,290 :: 		if(!COL1||!COL2||!COL3){
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key82
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key82
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key82
	GOTO       L_key52
L__key82:
;FinalCode_LockDoorSystem.c,291 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,293 :: 		rownum=3;
	MOVLW      3
	MOVWF      _rownum+0
;FinalCode_LockDoorSystem.c,294 :: 		break;
	GOTO       L_key38
;FinalCode_LockDoorSystem.c,295 :: 		}
L_key52:
;FinalCode_LockDoorSystem.c,296 :: 		}
	GOTO       L_key37
L_key38:
;FinalCode_LockDoorSystem.c,299 :: 		if(COL1==0&&COL2!=0&&COL3!=0)//if COL1 is pressed
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_key55
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_key55
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_key55
L__key81:
;FinalCode_LockDoorSystem.c,301 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,303 :: 		colnum=0;
	CLRF       _colnum+0
;FinalCode_LockDoorSystem.c,304 :: 		}
	GOTO       L_key56
L_key55:
;FinalCode_LockDoorSystem.c,305 :: 		else if(COL1!=0&&COL2==0&&COL3!=0)//if COL2 is pressed
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_key59
	BTFSC      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_key59
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_key59
L__key80:
;FinalCode_LockDoorSystem.c,307 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,309 :: 		colnum=1;
	MOVLW      1
	MOVWF      _colnum+0
;FinalCode_LockDoorSystem.c,310 :: 		}
	GOTO       L_key60
L_key59:
;FinalCode_LockDoorSystem.c,311 :: 		else if(COL1!=0&&COL2!=0&&COL3==0)//if COL3 is pressed
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_key63
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_key63
	BTFSC      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_key63
L__key79:
;FinalCode_LockDoorSystem.c,313 :: 		myDelay(100);
	MOVLW      100
	MOVWF      FARG_myDelay_x+0
	MOVLW      0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,315 :: 		colnum=2;
	MOVLW      2
	MOVWF      _colnum+0
;FinalCode_LockDoorSystem.c,316 :: 		}
L_key63:
L_key60:
L_key56:
;FinalCode_LockDoorSystem.c,319 :: 		while(COL1==0||COL2==0||COL3==0);//to prevent from debouncing to filter out unwanted signals and ensure that only one button press is registered.
L_key64:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key78
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key78
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key78
	GOTO       L_key65
L__key78:
	GOTO       L_key64
L_key65:
;FinalCode_LockDoorSystem.c,321 :: 		return (keypad[rownum][colnum]);
	MOVLW      3
	MOVWF      R0+0
	MOVF       _rownum+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      _keypad+0
	ADDWF      R0+0, 1
	MOVF       _colnum+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
;FinalCode_LockDoorSystem.c,322 :: 		}
L_end_key:
	RETURN
; end of _key

_main:

;FinalCode_LockDoorSystem.c,325 :: 		void main()
;FinalCode_LockDoorSystem.c,327 :: 		TRISB = 0x0F;  // set RB0 and rows of keypad (RB4,RB5,RB6,RB7) as outputs while coloumns of keypad (RB0,RB1,RB2) are set as inputs
	MOVLW      15
	MOVWF      TRISB+0
;FinalCode_LockDoorSystem.c,328 :: 		INTCON =0xD0;  // enable external interrupts on RB0
	MOVLW      208
	MOVWF      INTCON+0
;FinalCode_LockDoorSystem.c,329 :: 		TRISD=0x00;              //set LCD data pins as output "0"
	CLRF       TRISD+0
;FinalCode_LockDoorSystem.c,330 :: 		TRISA=0x20; //set buzzer (RA0) and LED lights (RA1/RA2) as outputs "0"  and PIR as input
	MOVLW      32
	MOVWF      TRISA+0
;FinalCode_LockDoorSystem.c,331 :: 		TRISC=0x00;     //set LCD command RC-7 as output and servo motor RC2 "0"
	CLRF       TRISC+0
;FinalCode_LockDoorSystem.c,332 :: 		PORTD=0X00;
	CLRF       PORTD+0
;FinalCode_LockDoorSystem.c,333 :: 		ADCON1=0x06;//make PORTA Digital
	MOVLW      6
	MOVWF      ADCON1+0
;FinalCode_LockDoorSystem.c,334 :: 		option_reg = option_reg&0x7F;
	MOVLW      127
	ANDWF      OPTION_REG+0, 1
;FinalCode_LockDoorSystem.c,335 :: 		PORTA=0;
	CLRF       PORTA+0
;FinalCode_LockDoorSystem.c,338 :: 		LCDinit();
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,339 :: 		LCDcommand(0x80);
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,340 :: 		LCDout("HELLO", 5);
	MOVLW      ?lstr_8_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_8_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      5
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,341 :: 		myDelay(2000);
	MOVLW      208
	MOVWF      FARG_myDelay_x+0
	MOVLW      7
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;FinalCode_LockDoorSystem.c,342 :: 		LCDinit();
	CALL       _LCDinit+0
;FinalCode_LockDoorSystem.c,343 :: 		LCDcommand(0x80);
	MOVLW      128
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,344 :: 		LCDout("ENTER PASSWORD", 14);
	MOVLW      ?lstr_9_FinalCode_LockDoorSystem+0
	MOVWF      FARG_LCDout_string+0
	MOVLW      hi_addr(?lstr_9_FinalCode_LockDoorSystem+0)
	MOVWF      FARG_LCDout_string+1
	MOVLW      14
	MOVWF      FARG_LCDout_length+0
	CALL       _LCDout+0
;FinalCode_LockDoorSystem.c,345 :: 		LCDcommand(0xC0);
	MOVLW      192
	MOVWF      FARG_LCDcommand_command+0
	CALL       _LCDcommand+0
;FinalCode_LockDoorSystem.c,346 :: 		while(1) // loop indefinitely
L_main68:
;FinalCode_LockDoorSystem.c,349 :: 		for(i=0;i<5;i++)
	CLRF       _i+0
	CLRF       _i+1
L_main70:
	MOVLW      0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVLW      5
	SUBWF      _i+0, 0
L__main124:
	BTFSC      STATUS+0, 0
	GOTO       L_main71
;FinalCode_LockDoorSystem.c,352 :: 		kp=key();
	CALL       _key+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;FinalCode_LockDoorSystem.c,353 :: 		if(kp=='#')
	MOVF       R0+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main73
;FinalCode_LockDoorSystem.c,354 :: 		{ checkpass();
	CALL       _checkpass+0
;FinalCode_LockDoorSystem.c,355 :: 		}
	GOTO       L_main74
L_main73:
;FinalCode_LockDoorSystem.c,356 :: 		else if (kp=='*')
	MOVF       _kp+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main75
;FinalCode_LockDoorSystem.c,358 :: 		resetpass();
	CALL       _resetpass+0
;FinalCode_LockDoorSystem.c,359 :: 		}
	GOTO       L_main76
L_main75:
;FinalCode_LockDoorSystem.c,363 :: 		pass[i]=kp;
	MOVF       _i+0, 0
	ADDLW      _pass+0
	MOVWF      FSR
	MOVF       _kp+0, 0
	MOVWF      INDF+0
;FinalCode_LockDoorSystem.c,364 :: 		LCDdata(pass[i]);
	MOVF       _i+0, 0
	ADDLW      _pass+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_LCDdata_data1+0
	CALL       _LCDdata+0
;FinalCode_LockDoorSystem.c,365 :: 		}
L_main76:
L_main74:
;FinalCode_LockDoorSystem.c,349 :: 		for(i=0;i<5;i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;FinalCode_LockDoorSystem.c,366 :: 		}
	GOTO       L_main70
L_main71:
;FinalCode_LockDoorSystem.c,368 :: 		}
	GOTO       L_main68
;FinalCode_LockDoorSystem.c,369 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
