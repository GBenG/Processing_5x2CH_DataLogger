/**
* ControlP5 Icon
*
*
* find a list of public methods available for the Group Controller
* at the bottom of this sketch.
*
* by Andreas Schlegel, 2014
* www.sojamo.de/libraries/controlp5
*
*/


import controlP5.*;

ControlP5 cp5;
Chart myChart;
Println console;
Textarea myTextarea;

PFont   font1;                        // Шрифты
color   bgcolor = color(10,30,50);    //Основной фон

int grx_1 = 50; int gry_1 = 300;
int grx_2 = 200; int gry_2 = 300;


void setup() {
//---------------------------------------------------------------------------   
  size(700,400);
  font1 = loadFont("Impact-12.vlw");          // Подключаем шрифт
//---------------------------------------------------------------------------   
  CColor butcol = new CColor();
    butcol.setForeground(bgcolor);
    butcol.setActive(bgcolor);
    butcol.setBackground(color(255,200));
//----------------------------------------------------------------------    
  cp5 = new ControlP5(this);
  
//------------------------------------------------------------------ CH1
  cp5.addIcon("vis_voc_ch1",10)
      .setPosition(grx_1+30,gry_1)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E,#00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_voc_ch1",10)
     .setPosition(grx_1,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_voc_ch1",10)
     .setPosition(grx_1,gry_1+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_voc_ch1",10)
     .setPosition(grx_1+30,gry_1+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_voc_ch1",10)
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
     .setFontIcons(#00f06E,#00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
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
  cp5.addIcon("vis_voc_ch2",10)
      .setPosition(grx_2+30,gry_2)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcons(#00f06E,#00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
     ;   
  cp5.addIcon("plus_voc_ch2",10)
     .setPosition(grx_2,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f067).setScale(0.9,1).setColor(butcol).showBackground()
     ;  
  cp5.addIcon("minus_voc_ch2",10)
     .setPosition(grx_2,gry_2+60)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f068).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("up_voc_ch2",10)
     .setPosition(grx_2+30,gry_2+30)
     .setSize(22,22).setRoundedCorners(5)
     .setFont(createFont("fontawesome-webfont.ttf", 20))
     .setFontIcon(#00f102).setScale(0.9,1).setColor(butcol).showBackground()
     ; 
  cp5.addIcon("down_voc_ch2",10)
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
     .setFontIcons(#00f06E,#00f070).setScale(0.9,1).setSwitch(true).setColor(butcol).showBackground().setOn()
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
//################################################################################################ DATAFLOW    
       myChart = cp5.addChart("dataflow")
               .setPosition(50, 50)
               .setSize(600, 200)
               .setRange(0, 100)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(8)
               .setColorCaptionLabel(bgcolor)
               .setColorBackground(bgcolor);
               ;

  myChart.addDataSet("VOC_CH1");
  myChart.setData("VOC_CH1", new float[500]);
  myChart.setColors("VOC_CH1", color(255,0,0));
  myChart.addDataSet("TMP_CH1");
  myChart.setData("TMP_CH1", new float[500]);
  myChart.setColors("TMP_CH1", color(255,0,0,100));
  
  myChart.addDataSet("VOC_CH2");
  myChart.setData("VOC_CH2", new float[500]);
  myChart.setColors("VOC_CH2", color(0,255,0));
  myChart.addDataSet("TMP_CH2");
  myChart.setData("TMP_CH2", new float[500]);
  myChart.setColors("TMP_CH2", color(0,255,0,100));
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

void draw() {
  background(bgcolor);
  draw_ch_label(grx_1, gry_1, color(255,0,0), "CH1");
  draw_ch_label(grx_2, gry_2, color(0,255,0), "CH2");
  
  myChart.push("VOC_CH1", (sin(frameCount*0.1)*10)+30);
  myChart.push("TMP_CH1", (sin(frameCount*0.2)*10)+20);
  
  myChart.push("VOC_CH2", (sin(frameCount*0.1)*10)+70);
  myChart.push("TMP_CH2", (sin(frameCount*0.2)*10)+60);
  
  //println((sin(frameCount*0.1)*10)+70+"\t"+(sin(frameCount*0.1)*10)+7);
  
  //if (cp5.isMouseOver()){  println(cp5.getWindow().getMouseOverList());}

}

void down_tmp_ch2(boolean theValue) {
  //println("got an event for icon", theValue);
} 

void draw_ch_label(int x, int y, color lcolor, String label){
  textFont(font1);
  fill(255,200);
  text("VOC",x+2,y+15);
  text("NTC",70+x+2,y+15);
  fill(lcolor);
  rect(x,y-30,122,22,5);
  fill(bgcolor);
  text(label,x+54,y-14);
  stroke(255,200);
  line(x+60,y+0,x+60,y+82);
  noStroke();
}


/*
a list of all methods available for the Icon Controller
use ControlP5.printPublicMethodsFor(Icon.class);
to print the following list into the console.

You can find further details about class Icon in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : ControllerView getView() 
controlP5.Controller : Icon addCallback(CallbackListener) 
controlP5.Controller : Icon addListener(ControlListener) 
controlP5.Controller : Icon addListenerFor(int, CallbackListener) 
controlP5.Controller : Icon align(int, int, int, int) 
controlP5.Controller : Icon bringToFront() 
controlP5.Controller : Icon bringToFront(ControllerInterface) 
controlP5.Controller : Icon hide() 
controlP5.Controller : Icon linebreak() 
controlP5.Controller : Icon listen(boolean) 
controlP5.Controller : Icon lock() 
controlP5.Controller : Icon onChange(CallbackListener) 
controlP5.Controller : Icon onClick(CallbackListener) 
controlP5.Controller : Icon onDoublePress(CallbackListener) 
controlP5.Controller : Icon onDrag(CallbackListener) 
controlP5.Controller : Icon onDraw(ControllerView) 
controlP5.Controller : Icon onEndDrag(CallbackListener) 
controlP5.Controller : Icon onEnter(CallbackListener) 
controlP5.Controller : Icon onLeave(CallbackListener) 
controlP5.Controller : Icon onMove(CallbackListener) 
controlP5.Controller : Icon onPress(CallbackListener) 
controlP5.Controller : Icon onRelease(CallbackListener) 
controlP5.Controller : Icon onReleaseOutside(CallbackListener) 
controlP5.Controller : Icon onStartDrag(CallbackListener) 
controlP5.Controller : Icon onWheel(CallbackListener) 
controlP5.Controller : Icon plugTo(Object) 
controlP5.Controller : Icon plugTo(Object, String) 
controlP5.Controller : Icon plugTo(Object[]) 
controlP5.Controller : Icon plugTo(Object[], String) 
controlP5.Controller : Icon registerProperty(String) 
controlP5.Controller : Icon registerProperty(String, String) 
controlP5.Controller : Icon registerTooltip(String) 
controlP5.Controller : Icon removeBehavior() 
controlP5.Controller : Icon removeCallback() 
controlP5.Controller : Icon removeCallback(CallbackListener) 
controlP5.Controller : Icon removeListener(ControlListener) 
controlP5.Controller : Icon removeListenerFor(int, CallbackListener) 
controlP5.Controller : Icon removeListenersFor(int) 
controlP5.Controller : Icon removeProperty(String) 
controlP5.Controller : Icon removeProperty(String, String) 
controlP5.Controller : Icon setArrayValue(float[]) 
controlP5.Controller : Icon setArrayValue(int, float) 
controlP5.Controller : Icon setBehavior(ControlBehavior) 
controlP5.Controller : Icon setBroadcast(boolean) 
controlP5.Controller : Icon setCaptionLabel(String) 
controlP5.Controller : Icon setColor(CColor) 
controlP5.Controller : Icon setColorActive(int) 
controlP5.Controller : Icon setColorBackground(int) 
controlP5.Controller : Icon setColorCaptionLabel(int) 
controlP5.Controller : Icon setColorForeground(int) 
controlP5.Controller : Icon setColorLabel(int) 
controlP5.Controller : Icon setColorValue(int) 
controlP5.Controller : Icon setColorValueLabel(int) 
controlP5.Controller : Icon setDecimalPrecision(int) 
controlP5.Controller : Icon setDefaultValue(float) 
controlP5.Controller : Icon setHeight(int) 
controlP5.Controller : Icon setId(int) 
controlP5.Controller : Icon setImage(PImage) 
controlP5.Controller : Icon setImage(PImage, int) 
controlP5.Controller : Icon setImages(PImage, PImage, PImage) 
controlP5.Controller : Icon setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : Icon setLabel(String) 
controlP5.Controller : Icon setLabelVisible(boolean) 
controlP5.Controller : Icon setLock(boolean) 
controlP5.Controller : Icon setMax(float) 
controlP5.Controller : Icon setMin(float) 
controlP5.Controller : Icon setMouseOver(boolean) 
controlP5.Controller : Icon setMoveable(boolean) 
controlP5.Controller : Icon setPosition(float, float) 
controlP5.Controller : Icon setPosition(float[]) 
controlP5.Controller : Icon setSize(PImage) 
controlP5.Controller : Icon setSize(int, int) 
controlP5.Controller : Icon setStringValue(String) 
controlP5.Controller : Icon setUpdate(boolean) 
controlP5.Controller : Icon setValue(float) 
controlP5.Controller : Icon setValueLabel(String) 
controlP5.Controller : Icon setValueSelf(float) 
controlP5.Controller : Icon setView(ControllerView) 
controlP5.Controller : Icon setVisible(boolean) 
controlP5.Controller : Icon setWidth(int) 
controlP5.Controller : Icon show() 
controlP5.Controller : Icon unlock() 
controlP5.Controller : Icon unplugFrom(Object) 
controlP5.Controller : Icon unplugFrom(Object[]) 
controlP5.Controller : Icon unregisterTooltip() 
controlP5.Controller : Icon update() 
controlP5.Controller : Icon updateSize() 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : Pointer getPointer() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getAbsolutePosition() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : float[] getPosition() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
controlP5.Icon : Icon activateBy(int) 
controlP5.Icon : Icon hideBackground() 
controlP5.Icon : Icon setFill(boolean) 
controlP5.Icon : Icon setFont(PFont) 
controlP5.Icon : Icon setFont(PFont, int) 
controlP5.Icon : Icon setFontIcon(int) 
controlP5.Icon : Icon setFontIcon(int, int) 
controlP5.Icon : Icon setFontIconOff(int) 
controlP5.Icon : Icon setFontIconOn(int) 
controlP5.Icon : Icon setFontIconSize(int) 
controlP5.Icon : Icon setFontIcons(int, int) 
controlP5.Icon : Icon setFontIndex(int) 
controlP5.Icon : Icon setOff() 
controlP5.Icon : Icon setOn() 
controlP5.Icon : Icon setRoundedCorners(int) 
controlP5.Icon : Icon setScale(float, float) 
controlP5.Icon : Icon setStroke(boolean) 
controlP5.Icon : Icon setStrokeWeight(float) 
controlP5.Icon : Icon setSwitch(boolean) 
controlP5.Icon : Icon setValue(float) 
controlP5.Icon : Icon showBackground() 
controlP5.Icon : Icon update() 
controlP5.Icon : String getInfo() 
controlP5.Icon : String toString() 
controlP5.Icon : boolean getBooleanValue() 
controlP5.Icon : boolean isOn() 
controlP5.Icon : boolean isPressed() 
controlP5.Icon : boolean isSwitch() 
controlP5.Icon : int getFontIcon(int) 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 

created: 2015/03/24 12:21:09

*/