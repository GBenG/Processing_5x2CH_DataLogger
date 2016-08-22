#include <string.h>
////////////////////////////////////////////////////////////////////////////////////////////////
  int i=0;
  char buffer[32];
  char data_in[32];
////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////
void loop() {
  if(Serial.available()){                   //если есть данные - читаем
    delay(50);
    while( Serial.available() && i< 99) {     //загоняем прочитанное в буфер
      buffer[i++] = Serial.read();
    }
    buffer[i++]='\0';                         //закрываем массив
  }
 
  if(i>0){                                  //если буфер наполнен
    sscanf(buffer, "%s", &data_in);         //разбераем его на части
    i=0;
    
    if((String)data_in == "GET_CH_1"){Serial.print('1');Serial.print('\t');Serial.print(random(1,10));Serial.print('\t');Serial.print(random(50,80));Serial.print('\n');}
    if((String)data_in == "GET_CH_2"){Serial.print('2');Serial.print('\t');Serial.print(random(1,10));Serial.print('\t');Serial.print(random(50,80));Serial.print('\n');}
    if((String)data_in == "GET_CH_3"){Serial.print('3');Serial.print('\t');Serial.print(random(1,10));Serial.print('\t');Serial.print(random(50,80));Serial.print('\n');}
    if((String)data_in == "GET_CH_4"){Serial.print('4');Serial.print('\t');Serial.print(random(1,10));Serial.print('\t');Serial.print(random(50,80));Serial.print('\n');}
    if((String)data_in == "GET_CH_5"){Serial.print('5');Serial.print('\t');Serial.print(random(1,10));Serial.print('\t');Serial.print(random(50,80));Serial.print('\n');}
    if((String)data_in == "GET_TEMP"){Serial.print('T');Serial.print('\t');Serial.print(random(25,35));Serial.print('\n');}
    
    for(int i=0;i<32;i++){data_in[i]='\0';}
  }

  delay(10);
}
////////////////////////////////////////////////////////////////////////////////////////////////

