import java.io.BufferedWriter;
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
Serial serial_port = null;         // the serial port
String  serial_list;                // list of serial ports
int     serial_list_index = 0;      // currently selected serial port 
int     num_serial_ports = 0;       // number of serial ports in the l
//-----------------------------------------------------------------------------------------------
PImage img;
PFont   font1;                          // Шрифты
//-----------------------------------------------------------------------------------------------
//color   bgcolor = color(10,30,50);    //Основной фон
color   bgcolor = color(0,20,45);       //Основной фон
//-----------------------------------------------------------------------------------------------
int grx_1 = 020; int gry_1;
int grx_2 = 170; int gry_2;
int grx_3 = 320; int gry_3;
int grx_4 = 470; int gry_4;
int grx_5 = 620; int gry_5;
int grx_t = 770; int gry_t;

int grBuf = 500;
//-----------------------------------------------------------------------------------------------
String  data = "";                  //хранит строку целиком
int     index = 0;                  //задается позиция где будет стоять разделитель

int[]   voltage = new int[6];       // Массив-буфер для принятых значений напряжений по каналам
int[]   tempere = new int[6];       // Массив-буфер для принятых значений температуры по каналам

int[]   sen_scal = new int[6];      // Массив установок по масштабированию каналов данных сенсоров
int[]   sen_vpos = new int[6];      // Массив установок по вертикальной позиции каналов данных сенсоров
int[]   tmp_scal = new int[6];      // Массив установок по масштабированию каналов температуры сенсоров
int[]   tmp_vpos = new int[6];      // Массив установок по вертикальной позиции каналов температуры сенсоров

boolean[]   sen_status = new boolean[6];       // Массив видимости каналов данных
boolean[]   tmp_status = new boolean[6];       // Массив видимости каналов температуры

int     temperature;                // Значение независимого температурного датчика
//-----------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// SETUP ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
//---------------------------------------------------------------------------   
  size(838,740);
//---------------------------------------------------------------------------  
  gry_1 = height-140;
  gry_2 = height-140;
  gry_3 = height-140;
  gry_4 = height-140;
  gry_5 = height-140;
  gry_t = height-140;
//---------------------------------------------------------------------------  
  font1 = loadFont("Impact-12.vlw");          // Подключаем шрифт
  img = loadImage("logo.png");
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
//################################################################################################ DATAFLOW    
     DataChart = cp5.addChart("dataflow")
             .setPosition(15, 20)
             .setSize(805, 410)
             .setRange(0, 120)
             .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
             .setStrokeWeight(8)
             .setColorCaptionLabel(bgcolor)
             .setColorBackground(color(255,10));
             ;
  
    DataChart.addDataSet("sen_CH1");
    DataChart.setData("sen_CH1", new float[grBuf]);
    DataChart.setColors("sen_CH1", color(200,50,50,150));
    DataChart.addDataSet("TMP_CH1");
    DataChart.setData("TMP_CH1", new float[grBuf]);
    DataChart.setColors("TMP_CH1", color(200,50,50,75));
    
    DataChart.addDataSet("sen_CH2");
    DataChart.setData("sen_CH2", new float[grBuf]);
    DataChart.setColors("sen_CH2", color(0,200,100,150));
    DataChart.addDataSet("TMP_CH2");
    DataChart.setData("TMP_CH2", new float[grBuf]);
    DataChart.setColors("TMP_CH2", color(0,200,100,75));
    
    DataChart.addDataSet("sen_CH3");
    DataChart.setData("sen_CH3", new float[grBuf]);
    DataChart.setColors("sen_CH3", color(100,200,255,150)/*color(0,100,255)*/);
    DataChart.addDataSet("TMP_CH3");
    DataChart.setData("TMP_CH3", new float[grBuf]);
    DataChart.setColors("TMP_CH3", color(100,200,255,75)/*color(0,100,255)*/);
    
    DataChart.addDataSet("sen_CH4");
    DataChart.setData("sen_CH4", new float[grBuf]);
    DataChart.setColors("sen_CH4", color(255,255,100,150)/*color(255,255,0,150)*/);
    DataChart.addDataSet("TMP_CH4");
    DataChart.setData("TMP_CH4", new float[grBuf]);
    DataChart.setColors("TMP_CH4", color(255,255,100,75)/*color(255,255,0,150)*/);
    
    DataChart.addDataSet("sen_CH5");
    DataChart.setData("sen_CH5", new float[grBuf]);
    DataChart.setColors("sen_CH5", color(200,100,200,150));
    DataChart.addDataSet("TMP_CH5");
    DataChart.setData("TMP_CH5", new float[grBuf]);
    DataChart.setColors("TMP_CH5", color(200,100,200,75));
//--------------------------------------------------------------    

    TempChart = cp5.addChart("tempflow")
       .setPosition(15, height-290)
       .setSize(805, 100)
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
 /*
  myTextarea = cp5.addTextarea("txt")
                  .setPosition(400, 280)
                  .setSize(200, 100)
                  .setFont(createFont("", 10))
                  .setLineHeight(14)
                  .setColor(color(200))
                  .setColorBackground(color(0, 100))
                  .setColorForeground(color(255, 100));
  ;

  console = cp5.addConsole(myTextarea);//
  */
//################################################################################################ 
}
/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// DRAW ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(bgcolor);
  image(img, 100, 125);
//----------------------------------------------------------------------------------------------------------------------   
  draw_ch_label(grx_1, gry_1, color(200,50,50,150), "CH1");
  draw_ch_label(grx_2, gry_2, color(0,200,100,150), "CH2");
  draw_ch_label(grx_3, gry_3, color(100,200,255,150), "CH3");
  draw_ch_label(grx_4, gry_4, color(255,255,100,150), "CH4");
  draw_ch_label(grx_5, gry_5, color(200,100,200,150), "CH5");
  
  DataChart.push("sen_CH1", (sin(frameCount*0.1)*2)+25+random(1)+sen_vpos[1]);
  DataChart.push("TMP_CH1", (sin(frameCount*0.2)*2)+30+random(1)+tmp_vpos[1]);
  fill(200,50,50,150);triangle(820, 340-sen_vpos[1], 830, 345-sen_vpos[1], 830, 335-sen_vpos[1]);
  fill(200,50,50,75);triangle(820, 320-tmp_vpos[1], 830, 315-tmp_vpos[1], 830, 325-tmp_vpos[1]);
  
  DataChart.push("sen_CH2", (sin(frameCount*0.1)*2)+45+random(1));
  DataChart.push("TMP_CH2", (sin(frameCount*0.2)*2)+50+random(1));
  
  DataChart.push("sen_CH3", (sin(frameCount*0.1)*2)+65+random(1));
  DataChart.push("TMP_CH3", (sin(frameCount*0.2)*2)+70+random(1));
  
  DataChart.push("sen_CH4", (sin(frameCount*0.1)*2)+85+random(1));
  DataChart.push("TMP_CH4", (sin(frameCount*0.2)*2)+90+random(1));
  
  DataChart.push("sen_CH5", (sin(frameCount*0.1)*2)+105+random(1));
  DataChart.push("TMP_CH5", (sin(frameCount*0.2)*2)+110+random(1));
  
  draw_temp_label(grx_t, gry_t);
  TempChart.push("temp", (sin(frameCount*0.01)*20)+20+random(3));
  
  //println((sin(frameCount*0.1)*10)+70+"\t"+(sin(frameCount*0.1)*10)+7);
  //if (cp5.isMouseOver()){  println(cp5.getWindow().getMouseOverList());}
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
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
  *************************************************************************************************
  * @brief      draw_ch_label
  * @details    Draw labels for different channel control groups
  * @param      x  - coordinates of labels position
  * @param      y  - coordinates of labels position
  * @param      lcolor  - color of label sticker
  * @param      label  - caption
  * @return     void
  *************************************************************************************************
 */
void draw_ch_label(int x, int y, color lcolor, String label)
{
  textFont(font1);
  fill(255,200);
  text("SEN",x+2,y+15);
  text("tmp",70+x+2,y+15);
  fill(255,75);
  text("0.00000v",x+5,y+105);
  text("0.00\u00B0C",x+82,y+105);
  fill(lcolor);
  rect(x,y-30,122,22,5);
  fill(bgcolor);
  text(label,x+54,y-14);
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
  rect(x,y-30,52,52,5);
  fill(bgcolor);
  text("TEMP"+"\u00B0",x+12,y);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void serialEvent (Serial port)
{
  
  data = port.readStringUntil ('\n');
  data = data.substring(0, data.length() - 2);
  
/*  
  index = data.indexOf("\u0009");

  voltage = data.substring(0, index);
  temper = data.substring(index+1, data.length());
  
  coordsV[coordID] = float(voltage);
  coordsT[coordID] = float(temper);
      appendTextToFile(outFilename, hour() + ":" + minute() + ":" + second()+ "\u0009" + voltage+ "\u0009" + temper);
      coordID++;
      if(coordID>grBuf-1)
      {
        coordID=grBuf-1;
        for(int i =0;i<grBuf-1;i++)
        {
          coordsV[i]=coordsV[i+1];
          coordsT[i]=coordsT[i+1];
        }
      }
      */
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
  if(sen_scal[1]>0)sen_scal[1]--;
}
void up_sen_ch1() {
  sen_vpos[1]++;
}
void down_sen_ch1() {
  if(sen_vpos[1]>0)sen_vpos[1]--;
}
//--------------------------------------

void vis_tmp_ch1(boolean Status) {
  tmp_status[1]=Status; 
}
void plus_tmp_ch1() {
  tmp_scal[1]++;
}
void minus_tmp_ch1() {
  if(tmp_scal[1]>0)tmp_scal[1]--;
}
void up_tmp_ch1() {
  tmp_vpos[1]++;
}
void down_tmp_ch1() {
  if(tmp_vpos[1]>0)tmp_vpos[1]--;
}