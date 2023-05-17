#include<LiquidCrystal.h>
int buzzerPin = 12;
int notaSayisi = 8;
int kdo = 262;
int re = 294;
int mi = 330;
int fa = 349;
int sol = 392;
int la = 440;
int si = 494;
int ido = 523;
int cmd = -1;
int flag = 0;
int ledPin = 13;


LiquidCrystal lcd(8, 7, 6, 5, 4, 3);
void setup() {
    Serial.begin(9600);
    lcd.begin(16,2);
    
    BLEserial.begin(9600);
    pinMode(13,OUTPUT);
    
}

void loop() {
 String outMsg;
  int incomingByte;
  byte byteCounter = 0;
  byte words[64];
  if(BLEserial.available()>0){
   
    
    
    flag = 1;
    
    }
    cmd = BLEserial.read();
   if(flag == 1){
    
 
   if(cmd == '2'){
    tone(buzzerPin,kdo);

    }
    else if(cmd == '3'){
      tone(buzzerPin,re);
    
      }
       else if(cmd == '4'){
      tone(buzzerPin,mi);
      
      }
        else if(cmd == '5'){
      tone(buzzerPin,fa);
      }
        else if(cmd == '6'){
      tone(buzzerPin,sol);
      }
        else if(cmd == '7'){
      tone(buzzerPin,la);
      }
        else if(cmd == '8'){
      tone(buzzerPin,si);
      } else if(cmd == '9'){
      tone(buzzerPin,ido);
      }else if(cmd == '1'){
       noTone(buzzerPin);
      }else if(cmd == 'a'){
        digitalWrite(ledPin,HIGH);
        }else if(cmd == 'k'){
          digitalWrite(ledPin,LOW);
         
          }else if(cmd == 't'){
            lcd.clear();
            }
        

 BLEserial.println("got data"); 
    incomingByte = BLEserial.read();
    while (incomingByte > 0){
        words[byteCounter++] = incomingByte;
        BLEserial.print(incomingByte,DEC);    
        incomingByte = BLEserial.read();
        BLEserial.print(" ");
      } // while
      BLEserial.println("");
      for (int x = 0; x < byteCounter; x++){
        
        outMsg += char(words[x]);
        
      } // for
    
lcd.print(outMsg);

















    
    } else{
      BLEserial.print("unknown command: ");
      BLEserial.write(cmd);
      BLEserial.print(" (");
      BLEserial.print(cmd, DEC);
      BLEserial.print(")");

      BLEserial.println();
      }
flag = 0;    
cmd = 65;
}
