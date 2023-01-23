#define ROW1 RB4_bit
#define ROW2 RB5_bit
#define ROW3 RB6_bit
#define ROW4 RB7_bit
#define COL1 RB1_bit
#define COL2 RB2_bit
#define COL3 RB3_bit



char pass[4];   //password entered from keypad will be saved in this array
unsigned int i,v,a,k,count,count1=0;  //these will be used as counters for different for loops in the code
unsigned int tick;
unsigned char kp;
unsigned long  int count8;


unsigned int angle;

unsigned char HL;//High Low
unsigned char keypad[4][3]={{'1','2','3'},{'4','5','6'},{'7','8','9'},{'*','0','#'}};
unsigned char rownum,colnum;

   void myDelay(unsigned int x){  //this delay will give delays in seconds depending on value (x) sent to it
     tick=0;
      for(tick=0;tick<x;tick++) {
      for (count8=0;count8<2000;count8++);
      }
    }
void interrupt(void){



//The program uses a variable called HL to keep track of whether the edge of the servo signal is currently high or low.
//If HL is set to 1, it means the edge is high, and if it is set to 0, it means the edge is low.
//When the interrupt is triggered and HL is set to 1, the code inside the if-block is executed.
//The first thing that happens is that the servo angle is set by writing the value of the angle variable to the CCPR1H
// and CCPR1L registers. The angle variable is shifted right by 8 bits before being written to the CCPR1H register.
 //This is done to separate the most significant 8 bits of the angle value and write them to the CCPR1H register.
 // The least significant 8 bits of the angle value are written to the CCPR1L register.

//Next, the HL variable is set to 0, indicating that the next edge of the servo signal will be low.
//The CCP1CON register is set to 0x09, which configures the CCP1 module to detect a falling edge on the CCP1 pin.
// The TMR1H and TMR1L registers are then reset to zero.

//In summary, this block of code sets the servo angle and configure the CCP1 module to detect a falling edge on the CCP1 pin, the TMR1 is reset to zero.
 if(PIR1&0x04){//CCP1 interrupt
   if(HL){ //high
     CCPR1H= angle >>8;
     CCPR1L= angle;
     HL=0;//next time low
     CCP1CON=0x09;//next time Falling edge
     TMR1H=0;
     TMR1L=0;
   }
   else{  //low
     CCPR1H= (40000 - angle) >>8;
     CCPR1L= (40000 - angle);
     CCP1CON=0x08; //next time rising edge
     HL=1; //next time High
     TMR1H=0;
     TMR1L=0;

   }
 PIR1=PIR1&0xFB; //CLEAR CCP1 Interrupt Flag
 }

}


void LCDdata(char data1)
{
PORTD = data1;
PORTC= PORTC | 0x20;//RS=01;
PORTC = PORTC & 0xBF;//RW=00;
PORTC = PORTC | 0x80;//EN=01;
myDelay(500);
PORTC = PORTC & 0x7F;//EN=00;
}
void LCDcommand(unsigned char command)
{
PORTD=command;
PORTC = PORTC & 0xDF;//RS=0;
PORTC = PORTC & 0xBF;//RW=00;
PORTC = PORTC | 0x80;//EN=01;
myDelay(500);
PORTC = PORTC & 0x7F;//EN=00;
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
LCDcommand(0x38);   //2 lines and 5*7 matrix
LCDcommand(0x06);   // Shift cursor to right
LCDcommand(0x0C);   // Force cursor to begin on the second line
LCDcommand(0x01);   // Shift cursor position to left
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

     HL=1; //start high
     CCP1CON=0x08;//

     T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms

     INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
     PIE1=PIE1|0x04;// Enable CCP1 interrupts
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

  LCDinit(); //initialize LCD screen
  LCDcommand(0x80);    //Force cursor to the beginning ( 1st line)
  LCDout("DOOR IS OPENED", 14);
  PORTA=0x04; //turn on green led
  //code to open servo
  doorcontrol();
  myDelay(5000);
  PORTA=0;


      asm goto 0x00;

 }

else

{   count++;    //count=count+1 (each time an entered password is incorrect)




  if (count%4==0 )   // check if password was enterred incorrectly for 3 times, each time
  {   LCDinit();  //initialize LED screen
    LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
    LCDout("processing",10);
  for(k=0;k<1000;k++)
  {
   if (INTCON & 0x04) {  // check if the interrupt was caused by RB0

    LCDinit();  //initialize LED screen
    LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
    LCDout("ALARM ON", 8);          //if PIR((RA5)==1 check touch sensor and password was entered incorrectly 3 times

     PORTA=0x03; //turn on buzzer and red led

     myDelay(5000);

    PORTA=0;

    INTCON &= ~(0x04);  // clear the interrupt flag
    asm goto 0x00;
  }
  for(v=0;v<1000;v++)
  {

  if (INTCON & 0x04) {  // check if the interrupt was caused by RB0

    LCDinit();  //initialize LED screen
    LCDcommand(0x80); //Force cursor to the beginning ( 1st line)
    LCDout("ALARM ON", 8);          //if PIR((RA5)==1 check touch sensor and password was entered incorrectly 3 times

     PORTA=0x03; //turn on buzzer and red led

     myDelay(5000);

    PORTA=0;

    INTCON &= ~(0x04);  // clear the interrupt flag
    asm goto 0x00;
    }
    }
    }
    // if count<3 and pir sensor=0 display that password entered is incorrect
    LCDinit();
    LCDcommand(0x80); // Force cursor to the beginning ( 1st line)
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
  { // if count<3 and pir sensor=0 display that password entered is incorrect
    LCDinit();
    LCDcommand(0x80); // Force cursor to the beginning ( 1st line)
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
    //set all bits in PORTB to 0
    PORTB=0X00;

    //wait for a key press
    while(COL1&&COL2&&COL3);

    //scan the keypad for a specific key press
    while(!COL1||!COL2||!COL3) { //is checking if any of the column pins (COL1, COL2, COL3) are low. This means that if any of the column pins are connected to a button that is being pressed, the loop will continue to execute.
        //set ROW1 to 0, ROW2, ROW3, ROW4 to 1
        ROW1=0;
        ROW2=ROW3=ROW4=1;
        //check if a key press is detected on ROW1
        if(!COL1||!COL2||!COL3) {
        myDelay(100);
            //set rownum to indicate key press on ROW1
            rownum=0;
            break;
        }
        //set ROW2 to 0, ROW1, ROW3, ROW4 to 1
        ROW2=0;ROW1=ROW3=ROW4=1;
        //check if a key press is detected on ROW2
        if(!COL1||!COL2||!COL3) {
        myDelay(100);
            //set rownum to indicate key press on ROW2
            rownum=1;
            break;
        }
        //set ROW3 to 0, ROW1, ROW2, ROW4 to 1
        ROW3=0;ROW2=ROW1=ROW4=1;
        //check if a key press is detected on ROW3
        if(!COL1||!COL2||!COL3) {
        myDelay(100);
            //set rownum to indicate key press on ROW3
            rownum=2;
            break;
        }
        //set ROW4 to 0, ROW1, ROW2, ROW3 to 1
        ROW4=0; ROW1=ROW2=ROW3=1;
        //check if a key press is detected on ROW4
        if(!COL1||!COL2||!COL3){
        myDelay(100);
            //set rownum to indicate key press on ROW4
            rownum=3;
            break;
        }
    }

    //check which column the key press was detected on
    if(COL1==0&&COL2!=0&&COL3!=0)//if COL1 is pressed
    {
            myDelay(100);
            //set colnum to indicate key press on COL1
            colnum=0;
    }
    else if(COL1!=0&&COL2==0&&COL3!=0)//if COL2 is pressed
    {
            myDelay(100);
            //set colnum to indicate key press on COL2
            colnum=1;
    }
    else if(COL1!=0&&COL2!=0&&COL3==0)//if COL3 is pressed
    {
            myDelay(100);
            //set colnum to indicate key press on COL3
            colnum=2;
    }

    //wait for key press to be released
    while(COL1==0||COL2==0||COL3==0);//to prevent from debouncing to filter out unwanted signals and ensure that only one button press is registered.
    //return the value of the keypad at the position indicated by the rownum and colnum variables
    return (keypad[rownum][colnum]);
}


void main()
{
TRISB = 0x0F;  // set RB0 and rows of keypad (RB4,RB5,RB6,RB7) as outputs while coloumns of keypad (RB0,RB1,RB2) are set as inputs
INTCON =0xD0;  // enable external interrupts on RB0
TRISD=0x00;              //set LCD data pins as output "0"
TRISA=0x20; //set buzzer (RA0) and LED lights (RA1/RA2) as outputs "0"  and PIR as input
TRISC=0x00;     //set LCD command RC-7 as output and servo motor RC2 "0"
PORTD=0X00;
ADCON1=0x06;//make PORTA Digital
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
while(1) // loop indefinitely
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