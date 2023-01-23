#line 1 "C:/Users/LENOVO/OneDrive/Desktop/embedded systems/final project/FinalCode_LockDoorSystem.c"










char pass[4];
unsigned int i,v,a,k,count,count1=0;
unsigned int tick;
unsigned char kp;
unsigned long int count8;


unsigned int angle;

unsigned char HL;
unsigned char keypad[4][3]={{'1','2','3'},{'4','5','6'},{'7','8','9'},{'*','0','#'}};
unsigned char rownum,colnum;

 void myDelay(unsigned int x){
 tick=0;
 for(tick=0;tick<x;tick++) {
 for (count8=0;count8<2000;count8++);
 }
 }
void interrupt(void){
#line 47 "C:/Users/LENOVO/OneDrive/Desktop/embedded systems/final project/FinalCode_LockDoorSystem.c"
 if(PIR1&0x04){
 if(HL){
 CCPR1H= angle >>8;
 CCPR1L= angle;
 HL=0;
 CCP1CON=0x09;
 TMR1H=0;
 TMR1L=0;
 }
 else{
 CCPR1H= (40000 - angle) >>8;
 CCPR1L= (40000 - angle);
 CCP1CON=0x08;
 HL=1;
 TMR1H=0;
 TMR1L=0;

 }
 PIR1=PIR1&0xFB;
 }

}


void LCDdata(char data1)
{
PORTD = data1;
PORTC= PORTC | 0x20;
PORTC = PORTC & 0xBF;
PORTC = PORTC | 0x80;
myDelay(500);
PORTC = PORTC & 0x7F;
}
void LCDcommand(unsigned char command)
{
PORTD=command;
PORTC = PORTC & 0xDF;
PORTC = PORTC & 0xBF;
PORTC = PORTC | 0x80;
myDelay(500);
PORTC = PORTC & 0x7F;
}
void LCDout(const unsigned char *string, unsigned char length)
{
char k;
for(k=0;k<length;k++)
{
LCDdata(string[k]);
}
}
void LCDinit()
{
LCDcommand(0x38);
LCDcommand(0x06);
LCDcommand(0x0C);
LCDcommand(0x01);
}




int resetpass()
{

LCDinit();
LCDcommand(0x80);
LCDout("RESET...", 8);
myDelay(3);
asm goto 0x00;

return 0;
}

void doorcontrol()
{
TMR0 = 248;


 TMR1H=0;
 TMR1L=0;

 HL=1;
 CCP1CON=0x08;

 T1CON=0x01;

 INTCON=0xF0;
 PIE1=PIE1|0x04;
 CCPR1H=2000>>8;
 CCPR1L=2000;

 angle=1100;
 myDelay(5000);
 angle=3600;

}

void checkpass()
{
if(pass[0]=='1' && pass[1]=='2' && pass[2]=='3' && pass[3]=='4')
{

 LCDinit();
 LCDcommand(0x80);
 LCDout("DOOR IS OPENED", 14);
 PORTA=0x04;

 doorcontrol();
 myDelay(5000);
 PORTA=0;


 asm goto 0x00;

 }

else

{ count++;




 if (count%4==0 )
 { LCDinit();
 LCDcommand(0x80);
 LCDout("processing",10);
 for(k=0;k<1000;k++)
 {
 if (INTCON & 0x04) {

 LCDinit();
 LCDcommand(0x80);
 LCDout("ALARM ON", 8);

 PORTA=0x03;

 myDelay(5000);

 PORTA=0;

 INTCON &= ~(0x04);
 asm goto 0x00;
 }
 for(v=0;v<1000;v++)
 {

 if (INTCON & 0x04) {

 LCDinit();
 LCDcommand(0x80);
 LCDout("ALARM ON", 8);

 PORTA=0x03;

 myDelay(5000);

 PORTA=0;

 INTCON &= ~(0x04);
 asm goto 0x00;
 }
 }
 }

 LCDinit();
 LCDcommand(0x80);
 LCDout("INCORRECT", 9);
 for(k=0;k<10;k++)
 {
 PORTA=0x02;
 myDelay(5000);
 PORTA=0;
 }

 asm goto 0x00;



 }
 else if(count%3!=0)
 {
 LCDinit();
 LCDcommand(0x80);
 LCDout("INCORRECT", 9);
 for(k=0;k<10;k++)
 {
 PORTA=0x02;
 myDelay(5000);
 PORTA=0;
 }

 myDelay(2000);

 asm goto 0x00


 }

}
}


unsigned char key() {

 PORTB=0X00;


 while( RB1_bit && RB2_bit && RB3_bit );


 while(! RB1_bit ||! RB2_bit ||! RB3_bit ) {

  RB4_bit =0;
  RB5_bit = RB6_bit = RB7_bit =1;

 if(! RB1_bit ||! RB2_bit ||! RB3_bit ) {
 myDelay(0.1);

 rownum=0;
 break;
 }

  RB5_bit =0; RB4_bit = RB6_bit = RB7_bit =1;

 if(! RB1_bit ||! RB2_bit ||! RB3_bit ) {
 myDelay(100);

 rownum=1;
 break;
 }

  RB6_bit =0; RB5_bit = RB4_bit = RB7_bit =1;

 if(! RB1_bit ||! RB2_bit ||! RB3_bit ) {
 myDelay(100);

 rownum=2;
 break;
 }

  RB7_bit =0;  RB4_bit = RB5_bit = RB6_bit =1;

 if(! RB1_bit ||! RB2_bit ||! RB3_bit ){
 myDelay(100);

 rownum=3;
 break;
 }
 }


 if( RB1_bit ==0&& RB2_bit !=0&& RB3_bit !=0)
 {
 myDelay(100);

 colnum=0;
 }
 else if( RB1_bit !=0&& RB2_bit ==0&& RB3_bit !=0)
 {
 myDelay(100);

 colnum=1;
 }
 else if( RB1_bit !=0&& RB2_bit !=0&& RB3_bit ==0)
 {
 myDelay(100);

 colnum=2;
 }


 while( RB1_bit ==0|| RB2_bit ==0|| RB3_bit ==0);

 return (keypad[rownum][colnum]);
}


void main()
{
TRISB = 0x0F;
INTCON =0xD0;
TRISD=0x00;
TRISA=0x20;
TRISC=0x00;
PORTD=0X00;
ADCON1=0x06;
option_reg = option_reg&0x7F;
PORTA=0;


LCDinit();
LCDcommand(0x80);
LCDout("HELLO", 5);
myDelay(2000);
LCDinit();
LCDcommand(0x80);
LCDout("ENTER PASSWORD", 14);
LCDcommand(0xC0);
while(1)
{

 for(i=0;i<5;i++)
 {

 kp=key();
 if(kp=='#')
 { checkpass();
 }
 else if (kp=='*')
 {
 resetpass();
 }

 else {

 pass[i]=kp;
 LCDdata(pass[i]);
 }
 }

 }
}
