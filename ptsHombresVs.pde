
/* @pjs preload="bearyBear300.jpg"; */
import controlP5.*;

ControlP5 cp5;

int valSlider;
int rowCount;
String [] anio; 

Table table;

int [] kennedyHombres;
int datoKennedy;

int maxDato;

boolean unaVez = false;

boolean showGrid =true, showSrcImg, showSubtitle = true; // crea 3 variables que sera usadas mas adelante
PImage srcImg; //img

boolean circleOver=false;

void setup() {
  //P2D: renderizador de gráficos 2D que utiliza hardware de gráficos compatible con OpenGL./
  size(600, 600, P2D); 
  smooth();
  textAlign(CENTER, CENTER);
  textSize(24);

  srcImg = loadImage("prueba.jpg");

  initGrid(); // esta función esta dentro del archivo GridAndCell
  initPtcs(); //esta función esta en el archivo Ptc

  table = loadTable("hombresVSmujeres.csv", "header");
  //numero de filas en el archivo
  rowCount = table.getRowCount();
  println(rowCount + " filas en la tabla");


  anio = new String [rowCount];

  kennedyHombres = new int [rowCount];

  for (int i = 0; i < rowCount; i++)
  {
    //creamos un objeto que guarda la información de las filas de la tabla
    TableRow row = table.getRow(i);

    anio[i] = row.getString("anio");

    kennedyHombres[i]= row.getInt("kennedy-hombres");

    datoKennedy = kennedyHombres[i];
    if (datoKennedy > maxDato) 
    {
      maxDato = datoKennedy;
    }
  }


  cp5 = new ControlP5(this);  

  gui();
}

void gui()
{ 
  cp5.addSlider("valSlider")
    .setPosition(80, 500)
    .setWidth(400)
    .setRange(0, rowCount-1)// valor de cada  linea  ---|----|----|
    .setValue(0)
    .setNumberOfTickMarks(4)
    .setSliderMode(Slider.FLEXIBLE)
    ;
}

//función que se ejecuta cuando el slider se mueve 
void valSlider(int valor ) 
{ 
  //el valor en donde se encuentra el slider
  valSlider = valor;
  //println(valSlider + "    " + kennedyHombres[valSlider]);
  if (unaVez==true) {
    for (int i = ptcs.size() - 1; i >= 0; i--) {
       ptcs.remove(i);
       println("descontando :" + ptcs.size());
    }
    unaVez=false;
  }
  unaVez=false;
}

void draw() {

  updatePtcs(); //esta función esta en el archivo Ptc / carga los puntos

  background(0);
  //if (showSrcImg)image(srcImg, 0, 0, 600, 600); //muestra la imagen con la tecla i / archivo io
  //if (showGrid)drawGrid();  //muestra la grilla con la tecla g / archivo io

  fill(255);
  textSize(25);
  text("Número de casos de suicidios - Kennedy", width*.5, 50);
  text("Hombres", width*.5, 90);

  drawPtcs(); //esta función esta en el archivo Ptc / dibuja los puntos
  if (showSubtitle) { // si show subtitle es verdadero entonces muestre esto y si no - acción archivo io
    fill(255);
    text("Click dentro del Circulo", width*.5, height*.5);
  }

  for (int i = 0; i < rowCount; i++)
  { 
    float x = map(i, 0, rowCount-1, 90, 480);
    //text(tiempo[i], x, 35);

    pushMatrix();
    translate(x, 550);
    //rotate(PI/2);
    //se coloca el texto en cada linea
    textSize(15);
    text(anio[i], 0, 0);
    popMatrix();
  }


  noFill();
  stroke(#2D11ED);
  strokeWeight(2);
  ellipse(width/2, height/2, 300, 300);
  
  fill(255);
  textSize(30);
  text(ptcs.size(),300,225);
}
