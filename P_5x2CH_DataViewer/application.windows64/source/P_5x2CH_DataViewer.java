import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.BufferedWriter; 
import java.io.FileWriter; 
import processing.serial.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P_5x2CH_DataViewer extends PApplet {

 //<>// //<>//



/////////////////////////////////////////////////////////////////////////////////////////////////
ControlP5 cp5;
Chart DataChart;
Chart TempChart;
Println console;
Textarea myTextarea;
Table table;

int SLpos=0;
int SLscal=1;
//-----------------------------------------------------------------------------------------------
String[]   sensors = {                 //  \u041c\u0430\u0441\u0441\u0438\u0432 \u043e\u0431\u0440\u0430\u0431\u0430\u0442\u044b\u0432\u0430\u0435\u043c\u044b\u0445 \u0434\u0435\u0442\u0435\u043a\u0442\u043e\u0440\u043e\u0432
                      "GET_CH_1 ",
                      "GET_CH_2 ",
                      "GET_CH_3 ",
                      "GET_CH_4 ",
                      "GET_CH_5 ",
                      "GET_TEMP ",
                      };
int        get_ch   = 0;                // \u041d\u043e\u043c\u0435\u0440 \u043a\u0430\u043d\u0430\u043b\u0430 \u0434\u043b\u044f \u0437\u0430\u043f\u0440\u043e\u0441\u0430
int        t_time   = 2;               // \u0422\u0430\u0439\u043c\u0430\u0443\u0442 \u043c\u0435\u0436\u0434\u0443 \u043e\u0442\u0441\u044b\u043b\u043a\u043e\u0439 \u0437\u0430\u043f\u0440\u043e\u0441\u043e\u0432 (#DEFINE)
int        timeout  = t_time;           // \u0422\u0430\u0439\u043c\u0430\u0443\u0442 \u043c\u0435\u0436\u0434\u0443 \u043e\u0442\u0441\u044b\u043b\u043a\u043e\u0439 \u0437\u0430\u043f\u0440\u043e\u0441\u043e\u0432
//-----------------------------------------------------------------------------------------------
Serial serial_port = null;              // the serial port
String  serial_list;                    // list of serial ports
int     serial_list_index = 0;          // currently selected serial port 
int     num_serial_ports = 0;           // number of serial ports in the l
//-----------------------------------------------------------------------------------------------
PImage   img;
PFont    font1,font2;                   // \u0428\u0440\u0438\u0444\u0442\u044b
//-----------------------------------------------------------------------------------------------
//color   bgcolor = color(0,20,45);       //\u041e\u0441\u043d\u043e\u0432\u043d\u043e\u0439 \u0444\u043e\u043d
int   bgcolor = color(0,2,4);       //\u041e\u0441\u043d\u043e\u0432\u043d\u043e\u0439 \u0444\u043e\u043d

int   sColor_ch1 = color(200,50,50,150);
int   tColor_ch1 = color(200,50,50,75);
int   sColor_ch2 = color(0,200,100,150);
int   tColor_ch2 = color(0,200,100,75);
int   sColor_ch3 = color(100,200,255,150);
int   tColor_ch3 = color(100,200,255,75);
int   sColor_ch4 = color(255,255,100,150);
int   tColor_ch4 = color(255,255,100,75);
int   sColor_ch5 = color(200,100,200,150);
int   tColor_ch5 = color(200,100,200,75);

//-----------------------------------------------------------------------------------------------
int grx_1 = 020; int gry_1;
int grx_2 = 170; int gry_2;
int grx_3 = 320; int gry_3;
int grx_4 = 470; int gry_4;
int grx_5 = 620; int gry_5;
int grx_t = 770; int gry_t;

int grBuf = 500;                        // \u041a\u043e\u043b-\u0432\u043e \u0442\u043e\u0447\u0435\u043a \u0445\u0440\u0430\u043d\u0438\u043c\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u043e\u043c
//-----------------------------------------------------------------------------------------------
String    data = "";                    //\u0445\u0440\u0430\u043d\u0438\u0442 \u0441\u0442\u0440\u043e\u043a\u0443 \u0446\u0435\u043b\u0438\u043a\u043e\u043c
int       index = 0;                    //\u0437\u0430\u0434\u0430\u0435\u0442\u0441\u044f \u043f\u043e\u0437\u0438\u0446\u0438\u044f \u0433\u0434\u0435 \u0431\u0443\u0434\u0435\u0442 \u0441\u0442\u043e\u044f\u0442\u044c \u0440\u0430\u0437\u0434\u0435\u043b\u0438\u0442\u0435\u043b\u044c
int       coordID = 0;                  // \u041f\u043e\u0437\u0438\u0446\u0438\u044f \u0432 \u0431\u0443\u0444\u0435\u0440\u0435 \u0433\u0440\u0430\u0444\u0438\u043a\u0430

int       ch_ID;                        // \u041f\u043e\u043b\u0443\u0447\u0435\u043d\u043d\u044b\u0439 \u0438\u0434\u0435\u043d\u0442\u0438\u0444\u0438\u043a\u0430\u0442\u043e\u0440 \u043a\u0430\u043d\u0430\u043b\u0430

float[]   voltage = new float[6];       // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u043b\u044f \u043f\u0440\u0438\u043d\u044f\u0442\u044b\u0445 \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u0439 \u043d\u0430\u043f\u0440\u044f\u0436\u0435\u043d\u0438\u0439 \u043f\u043e \u043a\u0430\u043d\u0430\u043b\u0430\u043c
float[]   tempere = new float[6];       // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u043b\u044f \u043f\u0440\u0438\u043d\u044f\u0442\u044b\u0445 \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u0439 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u044b \u043f\u043e \u043a\u0430\u043d\u0430\u043b\u0430\u043c
float     temperature;                  // \u0417\u043d\u0430\u0447\u0435\u043d\u0438\u0435 \u043d\u0435\u0437\u0430\u0432\u0438\u0441\u0438\u043c\u043e\u0433\u043e \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u043d\u043e\u0433\u043e \u0434\u0430\u0442\u0447\u0438\u043a\u0430


float[]   sen_ch1 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u0430\u043d\u043d\u044b\u0445 \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   tmp_ch1 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0440\u044b \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   sen_ch2 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u0430\u043d\u043d\u044b\u0445 \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   tmp_ch2 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0440\u044b \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   sen_ch3 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u0430\u043d\u043d\u044b\u0445 \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   tmp_ch3 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0440\u044b \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   sen_ch4 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u0430\u043d\u043d\u044b\u0445 \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   tmp_ch4 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0440\u044b \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   sen_ch5 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u0430\u043d\u043d\u044b\u0445 \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   tmp_ch5 = new float[grBuf];   // \u041c\u0430\u0441\u0441\u0438\u0432-\u0431\u0443\u0444\u0435\u0440 \u0434\u0430\u043d\u043d\u044b\u0445 \u0433\u0440\u0430\u0444\u0438\u043a\u0430 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0440\u044b \u0434\u0430\u0442\u0447\u0438\u043a\u0430
float[]   temperb = new float[grBuf];   // \u0411\u0443\u0444\u0435\u0440 \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u0435 \u043d\u0435\u0437\u0430\u0432\u0438\u0441\u0438\u043c\u043e\u0433\u043e \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u043d\u043e\u0433\u043e \u0434\u0430\u0442\u0447\u0438\u043a\u0430

String[]   time = new String[grBuf];


int[]        sen_scal = new int[6];          // \u041c\u0430\u0441\u0441\u0438\u0432 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043e\u043a \u043f\u043e \u043c\u0430\u0441\u0448\u0442\u0430\u0431\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u044e \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0434\u0430\u043d\u043d\u044b\u0445 \u0441\u0435\u043d\u0441\u043e\u0440\u043e\u0432
int[]        sen_vpos = new int[6];          // \u041c\u0430\u0441\u0441\u0438\u0432 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043e\u043a \u043f\u043e \u0432\u0435\u0440\u0442\u0438\u043a\u0430\u043b\u044c\u043d\u043e\u0439 \u043f\u043e\u0437\u0438\u0446\u0438\u0438 \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0434\u0430\u043d\u043d\u044b\u0445 \u0441\u0435\u043d\u0441\u043e\u0440\u043e\u0432
int[]        tmp_scal = new int[6];          // \u041c\u0430\u0441\u0441\u0438\u0432 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043e\u043a \u043f\u043e \u043c\u0430\u0441\u0448\u0442\u0430\u0431\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u044e \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u044b \u0441\u0435\u043d\u0441\u043e\u0440\u043e\u0432
int[]        tmp_vpos = new int[6];          // \u041c\u0430\u0441\u0441\u0438\u0432 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043e\u043a \u043f\u043e \u0432\u0435\u0440\u0442\u0438\u043a\u0430\u043b\u044c\u043d\u043e\u0439 \u043f\u043e\u0437\u0438\u0446\u0438\u0438 \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u044b \u0441\u0435\u043d\u0441\u043e\u0440\u043e\u0432

boolean[]    sen_status = new boolean[6];    // \u041c\u0430\u0441\u0441\u0438\u0432 \u0432\u0438\u0434\u0438\u043c\u043e\u0441\u0442\u0438 \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0434\u0430\u043d\u043d\u044b\u0445
boolean[]    tmp_status = new boolean[6];    // \u041c\u0430\u0441\u0441\u0438\u0432 \u0432\u0438\u0434\u0438\u043c\u043e\u0441\u0442\u0438 \u043a\u0430\u043d\u0430\u043b\u043e\u0432 \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u044b

int          ext_tmp_scal=1;                 // \u0417\u043d\u0430\u0447\u0435\u043d\u0438\u0435 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0438 \u043f\u043e \u043c\u0430\u0441\u0448\u0442\u0430\u0431\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u044e \u043d\u0435\u0437\u0430\u0432\u0438\u0441\u0438\u043c\u043e\u0433\u043e \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u043d\u043e\u0433\u043e \u0434\u0430\u0442\u0447\u0438\u043a\u0430
int          ext_tmp_vpos=0;                 // \u0417\u043d\u0430\u0447\u0435\u043d\u0438\u0435 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0438 \u043f\u043e \u0432\u0435\u0440\u0442\u0438\u043a\u0430\u043b\u044c\u043d\u043e\u0439 \u043f\u043e\u0437\u0438\u0446\u0438\u0438 \u043d\u0435\u0437\u0430\u0432\u0438\u0441\u0438\u043c\u043e\u0433\u043e \u0442\u0435\u043c\u043f\u0435\u0440\u0430\u0442\u0443\u0440\u043d\u043e\u0433\u043e \u0434\u0430\u0442\u0447\u0438\u043a\u0430

boolean      inf_status=false;               // \u041f\u043e\u043a\u0430\u0437\u044b\u0432\u0430\u0442\u044c \u043b\u0438 \u0440\u0430\u0437\u0432\u0435\u0440\u043d\u0443\u0442\u0443\u044e \u0438\u043d\u0444\u0443?
//-----------------------------------------------------------------------------------------------
int  shx = 90;                              // \u0414\u0435\u0444\u0430\u0439\u043d\u044b \u0434\u043e\u043f \u0438\u043d\u0444\u044b
int  shy = 25;
int  pvx = 840;
int  pvy = 520;
//-----------------------------------------------------------------------------------------------
String outFilename = "log.txt";
//-----------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// SETUP ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
public void setup() {
//---------------------------------------------------------------------------   
  
//---------------------------------------------------------------------------  
  gry_1 = height-140;
  gry_2 = height-140;
  gry_3 = height-140;
  gry_4 = height-140;
  gry_5 = height-140;
  gry_t = height-140;
//---------------------------------------------------------------------------  
  font1 = loadFont("Impact-12.vlw");          // \u041f\u043e\u0434\u043a\u043b\u044e\u0447\u0430\u0435\u043c \u0448\u0440\u0438\u0444\u0442
  font2 = loadFont("Impact-18.vlw");          // \u041f\u043e\u0434\u043a\u043b\u044e\u0447\u0430\u0435\u043c \u0448\u0440\u0438\u0444\u0442
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

    table = loadTable("log.tsv", "header");
    println(table.getRowCount() + " total rows in table"); 
//---------------------------------------------------------------------------
  cp5 = new ControlP5(this);
  
//------------------------------------------------------------------ CH1
  cp5.addIcon("vis_sen_ch1",10)
      .setPosition(grx_1+30,gry_1)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch1",10)
     .setPosition(grx_1,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch1",10)
     .setPosition(grx_1,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch1",10)
     .setPosition(grx_1+30,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch1",10)
     .setPosition(grx_1+30,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch1",10)
      .setPosition(70+grx_1+30,gry_1)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOff()
     ;   
  cp5.addIcon("plus_tmp_ch1",10)
     .setPosition(70+grx_1,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch1",10)
     .setPosition(70+grx_1,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch1",10)
     .setPosition(70+grx_1+30,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch1",10)
     .setPosition(70+grx_1+30,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch1",10)
     .setPosition(70+grx_1+30,gry_1-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f090).setScale(0.9f,1).setColor(butcol).showBackground()
     ;     
//------------------------------------------------------------------ CH2
  cp5.addIcon("vis_sen_ch2",10)
      .setPosition(grx_2+30,gry_2)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch2",10)
     .setPosition(grx_2,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch2",10)
     .setPosition(grx_2,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch2",10)
     .setPosition(grx_2+30,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch2",10)
     .setPosition(grx_2+30,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch2",10)
      .setPosition(70+grx_2+30,gry_2)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOff()
     ;   
  cp5.addIcon("plus_tmp_ch2",10)
     .setPosition(70+grx_2,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch2",10)
     .setPosition(70+grx_2,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch2",10)
     .setPosition(70+grx_2+30,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch2",10)
     .setPosition(70+grx_2+30,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch2",10)
     .setPosition(70+grx_2+30,gry_2-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f090).setScale(0.9f,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH3
  cp5.addIcon("vis_sen_ch3",10)
      .setPosition(grx_3+30,gry_3)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch3",10)
     .setPosition(grx_3,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch3",10)
     .setPosition(grx_3,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch3",10)
     .setPosition(grx_3+30,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch3",10)
     .setPosition(grx_3+30,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch3",10)
      .setPosition(70+grx_3+30,gry_3)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOff()
     ;   
  cp5.addIcon("plus_tmp_ch3",10)
     .setPosition(70+grx_3,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch3",10)
     .setPosition(70+grx_3,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch3",10)
     .setPosition(70+grx_3+30,gry_3+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch3",10)
     .setPosition(70+grx_3+30,gry_3+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch3",10)
     .setPosition(70+grx_3+30,gry_3-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f090).setScale(0.9f,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH4
  cp5.addIcon("vis_sen_ch4",10)
      .setPosition(grx_4+30,gry_4)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch4",10)
     .setPosition(grx_4,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch4",10)
     .setPosition(grx_4,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch4",10)
     .setPosition(grx_4+30,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch4",10)
     .setPosition(grx_4+30,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch4",10)
      .setPosition(70+grx_4+30,gry_4)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOff()
     ;   
  cp5.addIcon("plus_tmp_ch4",10)
     .setPosition(70+grx_4,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch4",10)
     .setPosition(70+grx_4,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch4",10)
     .setPosition(70+grx_4+30,gry_4+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch4",10)
     .setPosition(70+grx_4+30,gry_4+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch4",10)
     .setPosition(70+grx_4+30,gry_4-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f090).setScale(0.9f,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ CH5
  cp5.addIcon("vis_sen_ch5",10)
      .setPosition(grx_5+30,gry_5)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_sen_ch5",10)
     .setPosition(grx_5,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_ch5",10)
     .setPosition(grx_5,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_ch5",10)
     .setPosition(grx_5+30,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_ch5",10)
     .setPosition(grx_5+30,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//   
  cp5.addIcon("vis_tmp_ch5",10)
      .setPosition(70+grx_5+30,gry_5)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f06E, 0xff00f070).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOff()
     ;   
  cp5.addIcon("plus_tmp_ch5",10)
     .setPosition(70+grx_5,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_tmp_ch5",10)
     .setPosition(70+grx_5,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_tmp_ch5",10)
     .setPosition(70+grx_5+30,gry_5+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_tmp_ch5",10)
     .setPosition(70+grx_5+30,gry_5+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//***********************************//      
  cp5.addIcon("store_ch5",10)
     .setPosition(70+grx_5+30,gry_5-30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f090).setScale(0.9f,1).setColor(butcol).showBackground()
     ;    
//------------------------------------------------------------------ TEMPERATURE
  cp5.addIcon("plus_sen_t",10)
     .setPosition(grx_t,gry_t+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f067).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_sen_t",10)
     .setPosition(grx_t,gry_t+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f068).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_sen_t",10)
     .setPosition(grx_t+30,gry_t+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f102).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_sen_t",10)
     .setPosition(grx_t+30,gry_t+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(0xff00f103).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//------------------------------------------------------------------ TEMPERATURE
  cp5.addIcon("up_serial",10)
     .setPosition(63,height-18)
     .setSize(14,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(0xff00f054).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_serial",10)
     .setPosition(5,height-18)
     .setSize(14,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(0xff00f053).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("connect_serial",10)
     .setPosition(85,height-18)
     .setSize(30,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(0xff00f074).setScale(0.9f,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("disconnect_serial",10)
     .setPosition(120,height-18)
     .setSize(30,14).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 12))
     .setFontIcon(0xff00f127).setScale(0.9f,1).setColor(butcol).showBackground()
     ; 
//------------------------------------------------------------------ SET INFO
  cp5.addIcon("info",10)
      .setPosition(grx_t,gry_t-60)
     .setSize(52,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(0xff00f05E, 0xff00f0AE).setScale(0.9f,1).setSwitch(true).setColor(butcol).showBackground().setOn()
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
       .setPosition(15, height-280)
       .setSize(968, 65)
       .setRange(0, 100)
       .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
       .setStrokeWeight(8)
       .setColorCaptionLabel(bgcolor)
       .setColorBackground(color(255,10));
       ;
  
    TempChart.addDataSet("temp");
    TempChart.setData("temp", new float[grBuf]);
    TempChart.setColors("temp", color(255));
//################################################################################################ SLIDER        
  cp5.addSlider("SL")
     .setRange(0, table.getRowCount()-grBuf)
     .setValue(0)
     .setPosition(15, 400)
     .setSize(width-102, 10)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  cp5.getController("SL").getValueLabel().setVisible(false);
  cp5.getController("SL").getCaptionLabel().setVisible(false);
  //################################################################################################ SCALER       
  cp5.addSlider("SC")
     .setRange(1, 10)
     .setValue(1)
     .setPosition(width-80, 400)
     .setSize(62, 10)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  cp5.getController("SC").getValueLabel().setVisible(false);
  cp5.getController("SC").getCaptionLabel().setVisible(false);
//################################################################################################ 
  for(int i=1;i<=5;i++){sen_scal[i]=1; tmp_scal[i]=1;}  // \u0412\u0441\u0435 \u043c\u0430\u0441\u0448\u0442\u0430\u0431\u044b \u043d\u0430\u0447\u0438\u043d\u0430\u044e\u0442\u0441\u044f \u0441 1
  for(int i=1;i<=5;i++){sen_vpos[i]=0;tmp_vpos[i]=0;}  // \u0412\u0441\u0435 \u043f\u043e\u0437\u0438\u0446\u0438\u0438 \u043d\u0430\u0447\u0438\u043d\u0430\u044e\u0442\u0441\u044f \u0441 1
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// DRAW ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void draw() {
  background(bgcolor);
  if(inf_status==false)image(img, 840, 500);
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
  draw_temp_label(grx_t, gry_t);
  
//----------------------------------------------------------------------------------------------------------------------  

  for(int i=0;i<grBuf;i++){
    if(sen_status[1]==true){DataChart.push("sen_CH1", sen_ch1[i]*sen_scal[1]+sen_vpos[1]);
    }else{DataChart.push("sen_CH1", 0);}
    if(tmp_status[1]==true){DataChart.push("TMP_CH1", tmp_ch1[i]*(tmp_scal[1]*0.1f)+tmp_vpos[1]);
    }else{DataChart.push("TMP_CH1", 0);}
    
    if(sen_status[2]==true){DataChart.push("sen_CH2", sen_ch2[i]*sen_scal[2]+sen_vpos[2]);
    }else{DataChart.push("sen_CH2", 0);}
    if(tmp_status[2]==true){DataChart.push("TMP_CH2", tmp_ch2[i]*(tmp_scal[2]*0.1f)+tmp_vpos[2]);
    }else{DataChart.push("TMP_CH2", 0);}
    
    if(sen_status[3]==true){DataChart.push("sen_CH3", sen_ch3[i]*sen_scal[3]+sen_vpos[3]);
    }else{DataChart.push("sen_CH3", 0);}
    if(tmp_status[3]==true){DataChart.push("TMP_CH3", tmp_ch3[i]*(tmp_scal[3]*0.1f)+tmp_vpos[3]);
    }else{DataChart.push("TMP_CH3", 0);}
    
    if(sen_status[4]==true){DataChart.push("sen_CH4", sen_ch4[i]*sen_scal[4]+sen_vpos[4]);
    }else{DataChart.push("sen_CH4", 0);}
    if(tmp_status[4]==true){DataChart.push("TMP_CH4", tmp_ch4[i]*(tmp_scal[4]*0.1f)+tmp_vpos[4]);
    }else{DataChart.push("TMP_CH4", 0);}
    
    if(sen_status[5]==true){DataChart.push("sen_CH5", sen_ch5[i]*sen_scal[5]+sen_vpos[5]);
    }else{DataChart.push("sen_CH5", 0);}
    if(tmp_status[5]==true){DataChart.push("TMP_CH5", tmp_ch5[i]*(tmp_scal[5]*0.1f)+tmp_vpos[5]);
    }else{DataChart.push("TMP_CH5", 0);}
    
    //TempChart.push("temp", (temperb[i]*ext_tmp_scal+ext_tmp_vpos));

  }
//----------------------------------------------------------------------------------------------------------------------    
  Draw_triangles(1, sColor_ch1, tColor_ch1);
  Draw_triangles(2, sColor_ch2, tColor_ch2);
  Draw_triangles(3, sColor_ch3, tColor_ch3);
  Draw_triangles(4, sColor_ch4, tColor_ch4);
  Draw_triangles(5, sColor_ch5, tColor_ch5);
//----------------------------------------------------------------------------------------------------------------------  

  stroke(255,20);
  if(mouseX >15 && mouseX < width-20 && mouseY > 20 && mouseY < height-310){     // \u041e\u0442\u0440\u0438\u0441\u043e\u0432\u0443\u0435\u043c \u043a\u0443\u0440\u0441\u043e\u0440\u043d\u0443\u044e \u043b\u0438\u043d\u0438\u044e \u0438 \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u044f \u0438\u0437\u043c\u0435\u0440\u0435\u043d\u0438\u0439
    line(mouseX,20,mouseX,height-310);
    line(mouseX,height-290,mouseX,height-215);
    
    if(inf_status == true){
      textFont(font2);
      fill(sColor_ch1);
      text(nf(sen_ch1[PApplet.parseInt(map(mouseX-15,0,968,0,grBuf))],1,2)+" ppm"      ,  pvx,      pvy+shy*0);
      //text(nf(tmp_ch1[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*0);
      fill(sColor_ch2);
      text(nf(sen_ch2[PApplet.parseInt(map(mouseX-15,0,968,0,grBuf))],1,2)+" ppm"      ,  pvx,      pvy+shy*1);
      //text(nf(tmp_ch2[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*1);
      fill(sColor_ch3);
      text(nf(sen_ch3[PApplet.parseInt(map(mouseX-15,0,968,0,grBuf))],1,2)+" ppm"      ,  pvx,      pvy+shy*2);
      //text(nf(tmp_ch3[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*2);
      fill(sColor_ch4);
      text(nf(sen_ch4[PApplet.parseInt(map(mouseX-15,0,968,0,grBuf))],1,2)+" ppm"      ,  pvx,      pvy+shy*3);
      //text(nf(tmp_ch4[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*3);
      fill(sColor_ch5);
      text(nf(sen_ch5[PApplet.parseInt(map(mouseX-15,0,968,0,grBuf))],1,2)+" ppm"      ,  pvx,      pvy+shy*4);
      //text(nf(tmp_ch5[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*4);
      fill(255,75);
      //text(nf(temperb[int(map(mouseX-15,0,968,0,grBuf))],2,1)+" \u00B0C",  pvx+shx,  pvy+shy*5);
      
      fill(255,200);
      textFont(font2);
      textAlign(CENTER);
      //text(time[int(map(mouseX-15,0,968,0,grBuf))],  width/2,45);
    }
  }else{
   if(inf_status == true){
      textFont(font2);
      fill(tColor_ch1);
      text(nf(voltage[1],1,2)+" ppm"      ,  pvx,      pvy+shy*0);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*0);
      fill(tColor_ch2);
      text(nf(voltage[2],1,2)+" ppm"      ,  pvx,      pvy+shy*1);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*1);
      fill(tColor_ch3);
      text(nf(voltage[3],1,2)+" ppm"      ,  pvx,      pvy+shy*2);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*2);
      fill(tColor_ch4);
      text(nf(voltage[4],1,2)+" ppm"      ,  pvx,      pvy+shy*3);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*3);
      fill(tColor_ch5);
      text(nf(voltage[5],1,2)+" ppm"      ,  pvx,      pvy+shy*4);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*4);
      fill(255,75);
      //text("00.0 \u00B0C",  pvx+shx,  pvy+shy*5);
   }
  }
//----------------------------------------------------------------------------------------------------------------------   
if (serial_port == null && (table.getRowCount()-SLpos)>grBuf*SLscal-1){
   int  j=0;
   for(int i=0;i<grBuf*SLscal;i+=SLscal){
      
    TableRow row = table.getRow(i+SLpos);
    
    String date = row.getString("time");
    
    String se1 = row.getString("se1");
    String tm1 = row.getString("tm1");
    
    String se2 = row.getString("se2");
    String tm2 = row.getString("tm2");
    
    String se3 = row.getString("se3");
    String tm3 = row.getString("tm3");
    
    String se4 = row.getString("se4");
    String tm4 = row.getString("tm4");
    
    String se5 = row.getString("se5");
    String tm5 = row.getString("tm5");
    
    String tmp = row.getString("tmp");

    sen_ch1[j] = PApplet.parseFloat(se1);
    sen_ch2[j] = PApplet.parseFloat(se2);
    sen_ch3[j] = PApplet.parseFloat(se3);
    sen_ch4[j] = PApplet.parseFloat(se4);
    sen_ch5[j] = PApplet.parseFloat(se5);
    
    tmp_ch1[j] = PApplet.parseFloat(tm1);
    tmp_ch2[j] = PApplet.parseFloat(tm2);
    tmp_ch3[j] = PApplet.parseFloat(tm3);
    tmp_ch4[j] = PApplet.parseFloat(tm4);
    tmp_ch5[j] = PApplet.parseFloat(tm5);
    
    temperb[j] = PApplet.parseFloat(tmp);
    
    time[j]  =  date;
    
    j++;
  } 
}

  
//----------------------------------------------------------------------------------------------------------------------  
  fill(255);
  stroke(255);                                                // \u041e\u0442\u0440\u0438\u0441\u043e\u0432\u044b\u0432\u0430\u0435\u043c \u043b\u0438\u043d\u0438\u0438 \u0440\u0430\u0437\u0434\u0435\u043b\u0435\u043d\u0438\u044f
  textFont(font1);
  line(0,height-22,width,height-22);     
  line(175,height,185,height-22);   
  line(width-120,height,width-110,height-22);   
  textAlign(RIGHT);
  text(serial_list,55,height-6); 
  text(":: SPS TECH :: 2016 ::",width-4,height-5);            // \u041e\u0442\u0440\u0438\u0441\u043e\u0432\u044b\u0432\u0430\u0435\u043c \u043b\u043e\u0433\u043e\u0442\u0438\u043f
  text("-^-^- DATA VIEWER -^-^- (Beta version)", width/2+60,height-5);            // \u041e\u0442\u0440\u0438\u0441\u043e\u0432\u044b\u0432\u0430\u0435\u043c \u043b\u043e\u0433\u043e\u0442\u0438\u043f
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
/***************************************************************************************************/
public void SL(float slider) {
  SLpos = PApplet.parseInt(slider);
}
/***************************************************************************************************/
public void SC(float slider) {
  SLscal = PApplet.parseInt(slider);
}
/***************************************************************************************************/
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
public void draw_ch_label(int n, int x, int y, int lcolor, String label)
{
  textFont(font1);
  fill(255,200);
  //text("SEN",x+2,y+15);
  //text("tmp",70+x+2,y+15);
  textAlign(CENTER);
  text("x"+sen_scal[n],x+12,y+15);
  text("x"+tmp_scal[n],70+x+12,y+15);
  fill(255,175);
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
public void draw_temp_label(int x, int y)
{
  textFont(font1);
  fill(255,75);
  text(temperature+"\u00B0C",x+14,y+105);
  fill(color(255,200));
  rect(x,y-30,52,52,5);
  fill(bgcolor);
  text("TEMP"+"\u00B0",x+12,y);
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
public void Draw_triangles(int n, int sCol, int tCol)
{
  float  y_sen = map(100-sen_vpos[n],0,100,0,370)+20;
  float  y_tmp = map(100-tmp_vpos[n],0,100,0,370)+20;
  
  if(sen_status[n]==true){fill(sCol);triangle(width-17, y_sen, width-7, y_sen+5, width-7, y_sen-5);}
  if(tmp_status[n]==true){fill(tCol);triangle(width-17, y_tmp, width-7, y_tmp+5, width-7, y_tmp-5);}
  
  // \u0433\u043e\u0440\u0438\u0437\u043e\u043d\u0442\u0430\u043b\u044c\u043d\u0430\u044f \u043b\u0438\u043d\u0438\u044f \u043d\u0443\u043b\u044f
  stroke(255,20);
  if(sen_status[n]==true){line(15,y_sen,width-17,y_sen);}  
  if(tmp_status[n]==true){line(15,y_tmp,width-17,y_tmp);}  
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void serialEvent (Serial port)
{
   data = port.readStringUntil ('\n');
   String[] list = split(data, '\u0009');
  
//  index = data.indexOf("\n");
//  ch_ID = int(data.substring(0, index));
//===========================================// 
  if(list.length==3)
  {
    ch_ID = PApplet.parseInt(list[0]);
    voltage[ch_ID] = PApplet.parseFloat(list[1]);
    tempere[ch_ID] = PApplet.parseFloat(list[2]);
  }
//===========================================// 
  if(list.length==2)
  {
    temperature = PApplet.parseFloat(list[1]);
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

public void appendTextToFile(String filename, String text){
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
public void createFile(File f){
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
public void up_serial() {
  if (serial_list_index < (num_serial_ports - 1)) {
    serial_list_index++;
    serial_list = Serial.list()[serial_list_index];      // move one position down in the list of serial ports
  }
} 
public void down_serial() {
  if (serial_list_index > 0) {      
    serial_list_index--;
    serial_list = Serial.list()[serial_list_index];      // move one position up in the list of serial ports
  }
} 
public void connect_serial() {
  if (serial_port == null) {
    serial_port = new Serial(this, Serial.list()[serial_list_index], 9600);       // connect to the selected serial port
    serial_port.bufferUntil('\n');
  }
} 
public void disconnect_serial() {
    serial_port.clear();
    serial_port.stop();
    serial_port = null;
} 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//===================================================== CH1
public void vis_sen_ch1(boolean Status) {
  sen_status[1]=Status;
}
public void plus_sen_ch1() {
  sen_scal[1]++;
}
public void minus_sen_ch1() {
  if(sen_scal[1]>1)sen_scal[1]--;
}
public void up_sen_ch1() {
  if(sen_vpos[1]<100)sen_vpos[1]+=10;
}
public void down_sen_ch1() {
  if(sen_vpos[1]>1)sen_vpos[1]-=10;
}
//-----------------------------------------

public void vis_tmp_ch1(boolean Status) {
  tmp_status[1]=Status; 
}
public void plus_tmp_ch1() {
  tmp_scal[1]++;
}
public void minus_tmp_ch1() {
  if(tmp_scal[1]>1)tmp_scal[1]--;
}
public void up_tmp_ch1() {
  if(tmp_vpos[1]<100)tmp_vpos[1]+=10;
}
public void down_tmp_ch1() {
  if(tmp_vpos[1]>1)tmp_vpos[1]-=10;
}
//===================================================== CH2
public void vis_sen_ch2(boolean Status) {
  sen_status[2]=Status;
}
public void plus_sen_ch2() {
  sen_scal[2]++;
}
public void minus_sen_ch2() {
  if(sen_scal[2]>1)sen_scal[2]--;
}
public void up_sen_ch2() {
  if(sen_vpos[2]<100)sen_vpos[2]+=10;
}
public void down_sen_ch2() {
  if(sen_vpos[2]>1)sen_vpos[2]-=10;
}
//-----------------------------------------

public void vis_tmp_ch2(boolean Status) {
  tmp_status[2]=Status; 
}
public void plus_tmp_ch2() {
  tmp_scal[2]++;
}
public void minus_tmp_ch2() {
  if(tmp_scal[2]>1)tmp_scal[2]--;
}
public void up_tmp_ch2() {
  if(tmp_vpos[2]<100)tmp_vpos[2]+=10;
}
public void down_tmp_ch2() {
  if(tmp_vpos[2]>1)tmp_vpos[2]-=10;
}
//===================================================== CH3
public void vis_sen_ch3(boolean Status) {
  sen_status[3]=Status;
}
public void plus_sen_ch3() {
  sen_scal[3]++;
}
public void minus_sen_ch3() {
  if(sen_scal[3]>1)sen_scal[3]--;
}
public void up_sen_ch3() {
  if(sen_vpos[3]<100)sen_vpos[3]+=10;
}
public void down_sen_ch3() {
  if(sen_vpos[3]>1)sen_vpos[3]-=10;
}
//-----------------------------------------

public void vis_tmp_ch3(boolean Status) {
  tmp_status[3]=Status; 
}
public void plus_tmp_ch3() {
  tmp_scal[3]++;
}
public void minus_tmp_ch3() {
  if(tmp_scal[3]>1)tmp_scal[3]--;
}
public void up_tmp_ch3() {
  if(tmp_vpos[3]<100)tmp_vpos[3]+=10;
}
public void down_tmp_ch3() {
  if(tmp_vpos[3]>1)tmp_vpos[3]-=10;
}
//===================================================== CH4
public void vis_sen_ch4(boolean Status) {
  sen_status[4]=Status;
}
public void plus_sen_ch4() {
  sen_scal[4]++;
}
public void minus_sen_ch4() {
  if(sen_scal[4]>1)sen_scal[4]--;
}
public void up_sen_ch4() {
  if(sen_vpos[4]<100)sen_vpos[4]+=10;
}
public void down_sen_ch4() {
  if(sen_vpos[4]>1)sen_vpos[4]-=10;
}
//-----------------------------------------

public void vis_tmp_ch4(boolean Status) {
  tmp_status[4]=Status; 
}
public void plus_tmp_ch4() {
  tmp_scal[4]++;
}
public void minus_tmp_ch4() {
  if(tmp_scal[4]>1)tmp_scal[4]--;
}
public void up_tmp_ch4() {
  if(tmp_vpos[4]<100)tmp_vpos[4]+=10;
}
public void down_tmp_ch4() {
  if(tmp_vpos[4]>1)tmp_vpos[4]-=10;
}
//===================================================== CH5
public void vis_sen_ch5(boolean Status) {
  sen_status[5]=Status;
}
public void plus_sen_ch5() {
  sen_scal[5]++;
}
public void minus_sen_ch5() {
  if(sen_scal[5]>1)sen_scal[5]--;
}
public void up_sen_ch5() {
  if(sen_vpos[5]<100)sen_vpos[5]+=10;
}
public void down_sen_ch5() {
  if(sen_vpos[5]>1)sen_vpos[5]-=10;
}
//-----------------------------------------

public void vis_tmp_ch5(boolean Status) {
  tmp_status[5]=Status; 
}
public void plus_tmp_ch5() {
  tmp_scal[5]++;
}
public void minus_tmp_ch5() {
  if(tmp_scal[5]>1)tmp_scal[5]--;
}
public void up_tmp_ch5() {
  if(tmp_vpos[5]<100)tmp_vpos[5]+=10;
}
public void down_tmp_ch5() {
  if(tmp_vpos[5]>1)tmp_vpos[5]-=10;
}
//===================================================== EXT TEMPERATURE
public void plus_sen_t() {
  ext_tmp_scal++;
}
public void minus_sen_t() {
  if(ext_tmp_scal>1)ext_tmp_scal--;
}
public void up_sen_t() {
  if(ext_tmp_vpos<100)ext_tmp_vpos+=10;
}
public void down_sen_t() {
  ext_tmp_vpos-=10;
}
//===================================================== INFO
public void info(boolean Status) {
  inf_status=Status;
}
//=======================================================================
//===================================================== INPUTs ==========
public void store_ch1() {
  serial_port.write("CLL_1_"+cp5.get(Textfield.class,"in_1").getText());
}
public void store_ch2() {
  serial_port.write("CLL_2_"+cp5.get(Textfield.class,"in_2").getText());
}
public void store_ch3() {
  serial_port.write("CLL_3_"+cp5.get(Textfield.class,"in_3").getText());
}
public void store_ch4() {
  serial_port.write("CLL_4_"+cp5.get(Textfield.class,"in_4").getText());
}
public void store_ch5() {
  serial_port.write("CLL_5_"+cp5.get(Textfield.class,"in_5").getText());
}
  public void settings() {  size(1000,700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P_5x2CH_DataViewer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
