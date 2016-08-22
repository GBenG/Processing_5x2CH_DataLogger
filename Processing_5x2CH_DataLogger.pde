import java.io.BufferedWriter; //<>//
import java.io.FileWriter;
import processing.serial.*;
import controlP5.*;
/////////////////////////////////////////////////////////////////////////////////////////////////
ControlP5 cp5;
Chart DataChart;
Chart TempChart;
Println console;
Textarea myTextarea;
//-----------------------------------------------------------------------------------------------
String[]   sensors = {                 //  Массив обрабатываемых детекторов
                      "GET_CH_1",
                      "GET_CH_2",
                      "GET_CH_3",
                      "GET_CH_4",
                      "GET_CH_5",
                      "GET_TEMP",
                      };
int        get_ch   = 0;                // Номер канала для запроса
int        t_time   = 10;               // Таймаут между отсылкой запросов (#DEFINE)
int        timeout  = t_time;           // Таймаут между отсылкой запросов
//-----------------------------------------------------------------------------------------------
Serial serial_port = null;              // the serial port
String  serial_list;                    // list of serial ports
int     serial_list_index = 0;          // currently selected serial port 
int     num_serial_ports = 0;           // number of serial ports in the l
//-----------------------------------------------------------------------------------------------
PImage   img;
PFont    font1;                         // Шрифты
//-----------------------------------------------------------------------------------------------
color   bgcolor = color(0,20,45);       //Основной фон

color   sColor_ch1 = color(200,50,50,150);
color   tColor_ch1 = color(200,50,50,75);
color   sColor_ch2 = color(0,200,100,150);
color   tColor_ch2 = color(0,200,100,75);
color   sColor_ch3 = color(100,200,255,150);
color   tColor_ch3 = color(100,200,255,75);
color   sColor_ch4 = color(255,255,100,150);
color   tColor_ch4 = color(255,255,100,75);
color   sColor_ch5 = color(200,100,200,150);
color   tColor_ch5 = color(200,100,200,75);

//-----------------------------------------------------------------------------------------------
int grx_1 = 020; int gry_1;
int grx_2 = 170; int gry_2;
int grx_3 = 320; int gry_3;
int grx_4 = 470; int gry_4;
int grx_5 = 620; int gry_5;
int grx_t = 770; int gry_t;

int grBuf = 100;                        // Кол-во точек хранимых графиком
//-----------------------------------------------------------------------------------------------
String    data = "";                    //хранит строку целиком
int       index = 0;                    //задается позиция где будет стоять разделитель
//boolean   update=false;
int       coordID = 0;                  // Позиция в буфере графика

int       ch_ID;                        // Полученный идентификатор канала

float[]   voltage = new float[6];       // Массив-буфер для принятых значений напряжений по каналам
float[]   tempere = new float[6];       // Массив-буфер для принятых значений температуры по каналам
float     temperature;                  // Значение независимого температурного датчика


float[]   sen_ch1 = new float[grBuf];   // Массив-буфер данных графика данных датчика
float[]   tmp_ch1 = new float[grBuf];   // Массив-буфер данных графика температры датчика
float[]   sen_ch2 = new float[grBuf];   // Массив-буфер данных графика данных датчика
float[]   tmp_ch2 = new float[grBuf];   // Массив-буфер данных графика температры датчика
float[]   sen_ch3 = new float[grBuf];   // Массив-буфер данных графика данных датчика
float[]   tmp_ch3 = new float[grBuf];   // Массив-буфер данных графика температры датчика
float[]   sen_ch4 = new float[grBuf];   // Массив-буфер данных графика данных датчика
float[]   tmp_ch4 = new float[grBuf];   // Массив-буфер данных графика температры датчика
float[]   sen_ch5 = new float[grBuf];   // Массив-буфер данных графика данных датчика
float[]   tmp_ch5 = new float[grBuf];   // Массив-буфер данных графика температры датчика
float[]   temperb = new float[grBuf];   // Буфер значение независимого температурного датчика


int[]   sen_scal = new int[6];          // Массив установок по масштабированию каналов данных сенсоров
int[]   sen_vpos = new int[6];          // Массив установок по вертикальной позиции каналов данных сенсоров
int[]   tmp_scal = new int[6];          // Массив установок по масштабированию каналов температуры сенсоров
int[]   tmp_vpos = new int[6];          // Массив установок по вертикальной позиции каналов температуры сенсоров

boolean[]   sen_status = new boolean[6];       // Массив видимости каналов данных
boolean[]   tmp_status = new boolean[6];       // Массив видимости каналов температуры


int     ext_tmp_scal=1;             // Значение установки по масштабированию независимого температурного датчика
int     ext_tmp_vpos=0;             // Значение установки по вертикальной позиции независимого температурного датчика
//-----------------------------------------------------------------------------------------------
String outFilename = "log.txt";
//-----------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// SETUP ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
//---------------------------------------------------------------------------   
  size(1000,700);
//---------------------------------------------------------------------------  
  gry_1 = height-140;
  gry_2 = height-140;
  gry_3 = height-140;
  gry_4 = height-140;
  gry_5 = height-140;
  gry_t = height-140;
//---------------------------------------------------------------------------  
  font1 = loadFont("Impact-12.vlw");          // Подключаем шрифт
  img = loadImage("logo2.png");
//---------------------------------------------------------------------------
  serial_list = Serial.list()[serial_list_index];
  num_serial_ports = Serial.list().length;
//---------------------------------------------------------------------------  
    CColor butcol = new CColor();
    butcol.setForeground(bgcolor);
    butcol.setActive(bgcolor);
    butcol.setBackground(color(255,200));
//---------------------------------------------------------------------------

  cp5 = new ControlP5(this);
  
//------------------------------------------------------------------ CH1
  cp5.addIcon("vis_sen_ch1",10)
      .setPosition(grx_1+30,gry_1)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch1",10)
     .setPosition(grx_1,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch1",10)
     .setPosition(grx_1,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch1",10)
     .setPosition(grx_1+30,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch1",10)
     .setPosition(grx_1+30,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch1",10)
      .setPosition(70+grx_1+30,gry_1)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_tmp_ch1",10)
     .setPosition(70+grx_1,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch1",10)
     .setPosition(70+grx_1,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch1",10)
     .setPosition(70+grx_1+30,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch1",10)
     .setPosition(70+grx_1+30,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch1",10)
     .setPosition(70+grx_1+30,gry_1-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f090).setScale(0.9,1).setColor(butcol).showBackground()
     ;     
//------------------------------------------------------------------ CH2
  cp5.addIcon("vis_sen_ch2",10)
      .setPosition(grx_2+30,gry_2)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch2",10)
     .setPosition(grx_2,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch2",10)
     .setPosition(grx_2,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch2",10)
     .setPosition(grx_2+30,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch2",10)
     .setPosition(grx_2+30,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch2",10)
      .setPosition(70+grx_2+30,gry_2)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_tmp_ch2",10)
     .setPosition(70+grx_2,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch2",10)
     .setPosition(70+grx_2,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch2",10)
     .setPosition(70+grx_2+30,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch2",10)
     .setPosition(70+grx_2+30,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch2",10)
     .setPosition(70+grx_2+30,gry_2-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f090).setScale(0.9,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH3
  cp5.addIcon("vis_sen_ch3",10)
      .setPosition(grx_3+30,gry_3)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch3",10)
     .setPosition(grx_3,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch3",10)
     .setPosition(grx_3,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch3",10)
     .setPosition(grx_3+30,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch3",10)
     .setPosition(grx_3+30,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch3",10)
      .setPosition(70+grx_3+30,gry_3)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_tmp_ch3",10)
     .setPosition(70+grx_3,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch3",10)
     .setPosition(70+grx_3,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch3",10)
     .setPosition(70+grx_3+30,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch3",10)
     .setPosition(70+grx_3+30,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch3",10)
     .setPosition(70+grx_3+30,gry_3-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f090).setScale(0.9,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH4
  cp5.addIcon("vis_sen_ch4",10)
      .setPosition(grx_4+30,gry_4)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch4",10)
     .setPosition(grx_4,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch4",10)
     .setPosition(grx_4,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch4",10)
     .setPosition(grx_4+30,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch4",10)
     .setPosition(grx_4+30,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch4",10)
      .setPosition(70+grx_4+30,gry_4)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_tmp_ch4",10)
     .setPosition(70+grx_4,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch4",10)
     .setPosition(70+grx_4,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch4",10)
     .setPosition(70+grx_4+30,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch4",10)
     .setPosition(70+grx_4+30,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch4",10)
     .setPosition(70+grx_4+30,gry_4-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f090).setScale(0.9,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH5
  cp5.addIcon("vis_sen_ch5",10)
      .setPosition(grx_5+30,gry_5)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch5",10)
     .setPosition(grx_5,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch5",10)
     .setPosition(grx_5,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch5",10)
     .setPosition(grx_5+30,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch5",10)
     .setPosition(grx_5+30,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch5",10)
      .setPosition(70+grx_5+30,gry_5)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E, #00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_tmp_ch5",10)
     .setPosition(70+grx_5,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch5",10)
     .setPosition(70+grx_5,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch5",10)
     .setPosition(70+grx_5+30,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch5",10)
     .setPosition(70+grx_5+30,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch5",10)
     .setPosition(70+grx_5+30,gry_5-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f090).setScale(0.9,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ TEMPERATURE
  cp5.addIcon("plus_sen_t",10)
     .setPosition(grx_t,gry_t+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_t",10)
     .setPosition(grx_t,gry_t+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_t",10)
     .setPosition(grx_t+30,gry_t+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_t",10)
     .setPosition(grx_t+30,gry_t+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f103).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//------------------------------------------------------------------ TEMPERATURE
  cp5.addIcon("up_serial",10)
     .setPosition(63,height-18)
     .setSize(14,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(#00f054).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_serial",10)
     .setPosition(5,height-18)
     .setSize(14,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(#00f053).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("connect_serial",10)
     .setPosition(85,height-18)
     .setSize(30,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(#00f074).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("disconnect_serial",10)
     .setPosition(120,height-18)
     .setSize(30,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(#00f127).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
//################################################################################################  
  cp5.addTextfield("in_1")
     .setPosition(grx_1,gry_1-30)
     .setSize(92,20)
     .setFont(font1)
     .setColorCursor(color(255)) 
     .setColor(color(255))
     .setColorCaptionLabel(bgcolor)
     ;
  cp5.addTextfield("in_2")
     .setPosition(grx_2,gry_2-30)
     .setSize(92,20)
     .setFont(font1)
     .setColorCursor(color(255)) 
     .setColor(color(255))
     .setColorCaptionLabel(bgcolor)
     ;
  cp5.addTextfield("in_3")
     .setPosition(grx_3,gry_3-30)
     .setSize(92,20)
     .setFont(font1)
     .setColorCursor(color(255)) 
     .setColor(color(255))
     .setColorCaptionLabel(bgcolor)
     ;
  cp5.addTextfield("in_4")
     .setPosition(grx_4,gry_4-30)
     .setSize(92,20)
     .setFont(font1)
     .setColorCursor(color(255)) 
     .setColor(color(255))
     .setColorCaptionLabel(bgcolor)
     ;
  cp5.addTextfield("in_5")
     .setPosition(grx_5,gry_5-30)
     .setSize(92,20)
     .setFont(font1)
     .setColorCursor(color(255)) 
     .setColor(color(255))
     .setColorCaptionLabel(bgcolor)
     ;
//################################################################################################ DATAFLOW    
     DataChart = cp5.addChart("dataflow")
             .setPosition(15, 20)
             .setSize(968, 370)
             .setRange(0, 100)
             .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
             .setStrokeWeight(8)
             .setColorCaptionLabel(bgcolor)
             .setColorBackground(color(255,10))
             ;
  
    DataChart.addDataSet("sen_CH1");
    DataChart.setData("sen_CH1", new float[grBuf]);
    DataChart.setColors("sen_CH1", sColor_ch1);
    DataChart.addDataSet("TMP_CH1");
    DataChart.setData("TMP_CH1", new float[grBuf]);
    DataChart.setColors("TMP_CH1", tColor_ch1);
    
    DataChart.addDataSet("sen_CH2");
    DataChart.setData("sen_CH2", new float[grBuf]);
    DataChart.setColors("sen_CH2", sColor_ch2);
    DataChart.addDataSet("TMP_CH2");
    DataChart.setData("TMP_CH2", new float[grBuf]);
    DataChart.setColors("TMP_CH2", tColor_ch2);
    
    DataChart.addDataSet("sen_CH3");
    DataChart.setData("sen_CH3", new float[grBuf]);
    DataChart.setColors("sen_CH3", sColor_ch3);
    DataChart.addDataSet("TMP_CH3");
    DataChart.setData("TMP_CH3", new float[grBuf]);
    DataChart.setColors("TMP_CH3", tColor_ch3);
    
    DataChart.addDataSet("sen_CH4");
    DataChart.setData("sen_CH4", new float[grBuf]);
    DataChart.setColors("sen_CH4", sColor_ch4);
    DataChart.addDataSet("TMP_CH4");
    DataChart.setData("TMP_CH4", new float[grBuf]);
    DataChart.setColors("TMP_CH4", tColor_ch4);
    
    DataChart.addDataSet("sen_CH5");
    DataChart.setData("sen_CH5", new float[grBuf]);
    DataChart.setColors("sen_CH5", sColor_ch5);
    DataChart.addDataSet("TMP_CH5");
    DataChart.setData("TMP_CH5", new float[grBuf]);
    DataChart.setColors("TMP_CH5", tColor_ch5);
//--------------------------------------------------------------    

    TempChart = cp5.addChart("tempflow")
       .setPosition(15, height-290)
       .setSize(968, 75)
       .setRange(0, 100)
       .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
       .setStrokeWeight(8)
       .setColorCaptionLabel(bgcolor)
       .setColorBackground(color(255,10));
       ;
  
    TempChart.addDataSet("temp");
    TempChart.setData("temp", new float[grBuf]);
    TempChart.setColors("temp", color(255));
//################################################################################################ 
  for(int i=1;i<=5;i++){sen_scal[i]=1; tmp_scal[i]=1;}  // Все масштабы начинаются с 1
  for(int i=1;i<=5;i++){sen_vpos[i]=50;}  // Все масштабы начинаются с 1
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// DRAW ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(bgcolor);
  image(img, 840, 500);
//---------------------------------------------------------------------------------------------------------------------- 
 if (serial_port != null && timeout ==0){
    serial_port.write(sensors[get_ch]);
    if(get_ch<5){get_ch++;}else{get_ch=0;}
    timeout  =  t_time;
 }else{ if (serial_port != null){timeout--;}}
//---------------------------------------------------------------------------------------------------------------------- 

  draw_ch_label(1, grx_1, gry_1, sColor_ch1, "CH1");
  draw_ch_label(2, grx_2, gry_2, sColor_ch2, "CH2");
  draw_ch_label(3, grx_3, gry_3, sColor_ch3, "CH3");
  draw_ch_label(4, grx_4, gry_4, sColor_ch4, "CH4");
  draw_ch_label(5, grx_5, gry_5, sColor_ch5, "CH5");
  
  for(int i=0;i<grBuf;i++){
    if(sen_status[1]==true){DataChart.push("sen_CH1", sen_ch1[i]*sen_scal[1]+sen_vpos[1]);
    }else{DataChart.push("sen_CH1", 0);}
    if(tmp_status[1]==true){DataChart.push("TMP_CH1", tmp_ch1[i]*(tmp_scal[1]*0.1)+tmp_vpos[1]);
    }else{DataChart.push("TMP_CH1", 0);}
    
    if(sen_status[2]==true){DataChart.push("sen_CH2", sen_ch2[i]*sen_scal[2]+sen_vpos[2]);
    }else{DataChart.push("sen_CH2", 0);}
    if(tmp_status[2]==true){DataChart.push("TMP_CH2", tmp_ch2[i]*(tmp_scal[2]*0.1)+tmp_vpos[2]);
    }else{DataChart.push("TMP_CH2", 0);}
    
    if(sen_status[3]==true){DataChart.push("sen_CH3", sen_ch3[i]*sen_scal[3]+sen_vpos[3]);
    }else{DataChart.push("sen_CH3", 0);}
    if(tmp_status[3]==true){DataChart.push("TMP_CH3", tmp_ch3[i]*(tmp_scal[3]*0.1)+tmp_vpos[3]);
    }else{DataChart.push("TMP_CH3", 0);}
    
    if(sen_status[4]==true){DataChart.push("sen_CH4", sen_ch4[i]*sen_scal[4]+sen_vpos[4]);
    }else{DataChart.push("sen_CH4", 0);}
    if(tmp_status[4]==true){DataChart.push("TMP_CH4", tmp_ch4[i]*(tmp_scal[4]*0.1)+tmp_vpos[4]);
    }else{DataChart.push("TMP_CH4", 0);}
    
    if(sen_status[5]==true){DataChart.push("sen_CH5", sen_ch5[i]*sen_scal[5]+sen_vpos[5]);
    }else{DataChart.push("sen_CH5", 0);}
    if(tmp_status[5]==true){DataChart.push("TMP_CH5", tmp_ch5[i]*(tmp_scal[5]*0.1)+tmp_vpos[5]);
    }else{DataChart.push("TMP_CH5", 0);}
    
    draw_temp_label(grx_t, gry_t);
    TempChart.push("temp", (temperb[i]*ext_tmp_scal+ext_tmp_vpos));

  }
  /*
  Draw_triangles(1, sColor_ch1, tColor_ch1);
  Draw_triangles(2, sColor_ch2, tColor_ch2);
  Draw_triangles(3, sColor_ch3, tColor_ch3);
  Draw_triangles(4, sColor_ch4, tColor_ch4);
  Draw_triangles(5, sColor_ch5, tColor_ch5);
  */

  
  //println((sin(frameCount*0.1)*10)+70+"\t"+(sin(frameCount*0.1)*10)+7);
//----------------------------------------------------------------------------------------------------------------------  
  fill(255);
  stroke(255);                                                // Отрисовываем линии разделения
  line(0,height-22,width,height-22);     
  line(175,height,185,height-22);   
  line(width-120,height,width-110,height-22);   
  textAlign(RIGHT);
  text(serial_list,55,height-6); 
  text(":: SPS TECH :: 2016 ::",width-4,height-5);            // Отрисовываем логотип
  textAlign(LEFT);
  noStroke();
//---------------------------------------------------------------------------------------------------------------------- 
  
  if (serial_port != null){fill(0,255,0,100);}else{fill(255,0,0,100);}
  rect(155,height-18, 15, 15,5);
//----------------------------------------------------------------------------------------------------------------------  
 //delay(100);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
  *************************************************************************************************
  * @brief      draw_ch_label
  * @details    Draw labels for different channel control groups
  * @param      n  - number of channel
  * @param      x  - coordinates of labels position
  * @param      y  - coordinates of labels position
  * @param      lcolor  - color of label sticker
  * @param      label  - caption
  * @return     void
  *************************************************************************************************
 */
void draw_ch_label(int n, int x, int y, color lcolor, String label)
{
  textFont(font1);
  fill(255,200);
  text("SEN",x+2,y+15);
  text("tmp",70+x+2,y+15);
  fill(255,75);
  textAlign(CENTER);
  text(voltage[n]+"v",x+25,y+105);
  text(round(tempere[n])+"\u00B0C",x+100,y+105);
  textAlign(LEFT);
  fill(lcolor);
  rect(x,y-60,122,22,5);
  fill(bgcolor);
  text(label,x+54,y-44);
  stroke(255,200);
  line(x+60,y+0,x+60,y+82);
  noStroke();
}

/**
  *************************************************************************************************
  * @brief      draw_temp_label
  * @details    Draw label for temperature channel control groups
  * @param      x  - coordinates of labels position
  * @param      y  - coordinates of labels position
  * @return     void
  *************************************************************************************************
 */
void draw_temp_label(int x, int y)
{
  textFont(font1);
  fill(255,75);
  text("0.00\u00B0C",x+14,y+105);
  fill(color(255,200));
  rect(x,y-60,52,82,5);
  fill(bgcolor);
  text("TEMP"+"\u00B0",x+12,y-15);
}
/**
  *************************************************************************************************
  * @brief      draw_triangles
  * @details    Draw triangles for channels in graf
  * @param      n  - number of channel
  * @param      sCol  - color of main data sensor channel
  * @param      tCol  - color of temperature of sensor channel
  * @return     void
  *************************************************************************************************
 */
void Draw_triangles(int n, color sCol, color tCol)
{
  fill(sCol);triangle(820, 430-sen_vpos[n], 830, 430-sen_vpos[n]+5, 830, 430-sen_vpos[n]-5);
  fill(tCol);triangle(820, 430-tmp_vpos[n], 830, 430-tmp_vpos[n]+5, 830, 430-tmp_vpos[n]-5);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void serialEvent (Serial port)
{
   data = port.readStringUntil ('\n');
   String[] list = split(data, '\u0009');
  
//  index = data.indexOf("\n");
//  ch_ID = int(data.substring(0, index));
//===========================================// 
  if(list.length==3)
  {
    ch_ID = int(list[0]);
    voltage[ch_ID] = float(list[1]);
    tempere[ch_ID] = float(list[2]);
  }
//===========================================// 
  if(list.length==2)
  {
    temperature = float(list[1]);
  }
//===========================================// 

  sen_ch1[coordID] = voltage[1];
  tmp_ch1[coordID] = tempere[1]; 
  sen_ch2[coordID] = voltage[2];
  tmp_ch2[coordID] = tempere[2]; 
  sen_ch3[coordID] = voltage[3];
  tmp_ch3[coordID] = tempere[3]; 
  sen_ch4[coordID] = voltage[4];
  tmp_ch4[coordID] = tempere[4]; 
  sen_ch5[coordID] = voltage[5];
  tmp_ch5[coordID] = tempere[5]; 
  temperb[coordID] = temperature;
    
      coordID++;
      if(coordID>grBuf-1)
      {
        coordID=grBuf-1;
        for(int i =0;i<grBuf-1;i++)
        {
          sen_ch1[i]=sen_ch1[i+1];
          tmp_ch1[i]=tmp_ch1[i+1];
          sen_ch2[i]=sen_ch2[i+1];
          tmp_ch2[i]=tmp_ch2[i+1];
          sen_ch3[i]=sen_ch3[i+1];
          tmp_ch3[i]=tmp_ch3[i+1];
          sen_ch4[i]=sen_ch4[i+1];
          tmp_ch4[i]=tmp_ch4[i+1];
          sen_ch5[i]=sen_ch5[i+1];
          tmp_ch5[i]=tmp_ch5[i+1];
          temperb[i]=temperb[i+1];
        }
      }
  
      appendTextToFile(outFilename, hour() + ":" + minute() + ":" + second()
      + "\u0009" + voltage[1]+ "\u0009" + tempere[1]
      + "\u0009" + voltage[2]+ "\u0009" + tempere[2]
      + "\u0009" + voltage[3]+ "\u0009" + tempere[3]
      + "\u0009" + voltage[4]+ "\u0009" + tempere[4]
      + "\u0009" + voltage[5]+ "\u0009" + tempere[5]
      + "\u0009" + temperature
      );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CREATE LOG FILE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mouse button clicked
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void up_serial() {
  if (serial_list_index < (num_serial_ports - 1)) {
    serial_list_index++;
    serial_list = Serial.list()[serial_list_index];      // move one position down in the list of serial ports
  }
} 
void down_serial() {
  if (serial_list_index > 0) {      
    serial_list_index--;
    serial_list = Serial.list()[serial_list_index];      // move one position up in the list of serial ports
  }
} 
void connect_serial() {
  if (serial_port == null) {
    serial_port = new Serial(this, Serial.list()[serial_list_index], 9600);       // connect to the selected serial port
    serial_port.bufferUntil('\n');
  }
} 
void disconnect_serial() {
    serial_port.clear();
    serial_port.stop();
    serial_port = null;
} 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//===================================================== CH1
void vis_sen_ch1(boolean Status) {
  sen_status[1]=Status;
}
void plus_sen_ch1() {
  sen_scal[1]++;
}
void minus_sen_ch1() {
  if(sen_scal[1]>1)sen_scal[1]--;
}
void up_sen_ch1() {
  if(sen_vpos[1]<410)sen_vpos[1]+=10;
}
void down_sen_ch1() {
  sen_vpos[1]-=10;
}
//-----------------------------------------

void vis_tmp_ch1(boolean Status) {
  tmp_status[1]=Status; 
}
void plus_tmp_ch1() {
  tmp_scal[1]++;
}
void minus_tmp_ch1() {
  if(tmp_scal[1]>1)tmp_scal[1]--;
}
void up_tmp_ch1() {
  if(tmp_vpos[1]<410)tmp_vpos[1]+=10;
}
void down_tmp_ch1() {
  tmp_vpos[1]-=10;
}
//===================================================== CH2
void vis_sen_ch2(boolean Status) {
  sen_status[2]=Status;
}
void plus_sen_ch2() {
  sen_scal[2]++;
}
void minus_sen_ch2() {
  if(sen_scal[2]>1)sen_scal[2]--;
}
void up_sen_ch2() {
  if(sen_vpos[2]<410)sen_vpos[2]+=10;
}
void down_sen_ch2() {
  sen_vpos[2]-=10;
}
//-----------------------------------------

void vis_tmp_ch2(boolean Status) {
  tmp_status[2]=Status; 
}
void plus_tmp_ch2() {
  tmp_scal[2]++;
}
void minus_tmp_ch2() {
  if(tmp_scal[2]>1)tmp_scal[2]--;
}
void up_tmp_ch2() {
  if(tmp_vpos[2]<410)tmp_vpos[2]+=10;
}
void down_tmp_ch2() {
  tmp_vpos[2]-=10;
}
//===================================================== CH3
void vis_sen_ch3(boolean Status) {
  sen_status[3]=Status;
}
void plus_sen_ch3() {
  sen_scal[3]++;
}
void minus_sen_ch3() {
  if(sen_scal[3]>1)sen_scal[3]--;
}
void up_sen_ch3() {
  if(sen_vpos[3]<410)sen_vpos[3]+=10;
}
void down_sen_ch3() {
  sen_vpos[3]-=10;
}
//-----------------------------------------

void vis_tmp_ch3(boolean Status) {
  tmp_status[3]=Status; 
}
void plus_tmp_ch3() {
  tmp_scal[3]++;
}
void minus_tmp_ch3() {
  if(tmp_scal[3]>1)tmp_scal[3]--;
}
void up_tmp_ch3() {
  if(tmp_vpos[3]<410)tmp_vpos[3]+=10;
}
void down_tmp_ch3() {
  tmp_vpos[3]-=10;
}
//===================================================== CH4
void vis_sen_ch4(boolean Status) {
  sen_status[4]=Status;
}
void plus_sen_ch4() {
  sen_scal[4]++;
}
void minus_sen_ch4() {
  if(sen_scal[4]>1)sen_scal[4]--;
}
void up_sen_ch4() {
  if(sen_vpos[4]<410)sen_vpos[4]+=10;
}
void down_sen_ch4() {
  sen_vpos[4]-=10;
}
//-----------------------------------------

void vis_tmp_ch4(boolean Status) {
  tmp_status[4]=Status; 
}
void plus_tmp_ch4() {
  tmp_scal[4]++;
}
void minus_tmp_ch4() {
  if(tmp_scal[4]>1)tmp_scal[4]--;
}
void up_tmp_ch4() {
  if(tmp_vpos[4]<410)tmp_vpos[4]+=10;
}
void down_tmp_ch4() {
  tmp_vpos[4]-=10;
}
//===================================================== CH5
void vis_sen_ch5(boolean Status) {
  sen_status[5]=Status;
}
void plus_sen_ch5() {
  sen_scal[5]++;
}
void minus_sen_ch5() {
  if(sen_scal[5]>1)sen_scal[5]--;
}
void up_sen_ch5() {
  if(sen_vpos[5]<410)sen_vpos[5]+=10;
}
void down_sen_ch5() {
  sen_vpos[5]-=10;
}
//-----------------------------------------

void vis_tmp_ch5(boolean Status) {
  tmp_status[5]=Status; 
}
void plus_tmp_ch5() {
  tmp_scal[5]++;
}
void minus_tmp_ch5() {
  if(tmp_scal[5]>1)tmp_scal[5]--;
}
void up_tmp_ch5() {
  if(sen_vpos[1]<410)tmp_vpos[5]+=10;
}
void down_tmp_ch5() {
  tmp_vpos[5]-=10;
}
//===================================================== EXT TEMPERATURE
void plus_sen_t() {
  ext_tmp_scal++;
}
void minus_sen_t() {
  if(ext_tmp_scal>1)ext_tmp_scal--;
}
void up_sen_t() {
  if(ext_tmp_vpos<410)ext_tmp_vpos+=10;
}
void down_sen_t() {
  ext_tmp_vpos-=10;
}
//=======================================================================
//===================================================== INPUTs ==========
void store_ch1() {
  serial_port.write(cp5.get(Textfield.class,"in_1").getText());
}
void store_ch2() {
  serial_port.write(cp5.get(Textfield.class,"in_2").getText());
}
void store_ch3() {
  serial_port.write(cp5.get(Textfield.class,"in_3").getText());
}
void store_ch4() {
  serial_port.write(cp5.get(Textfield.class,"in_4").getText());
}
void store_ch5() {
  serial_port.write(cp5.get(Textfield.class,"in_5").getText());
}