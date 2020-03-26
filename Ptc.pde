ArrayList <Ptc> ptcs; // declaro una lista ptcs

void initPtcs() {
  ptcs = new ArrayList<Ptc>(); //inicializo la lista ptc
}

void updatePtcs() { // cargar puntos 
  //int cantidad = int(map (kennedyHombres[valSlider], 0, maxDato, 100, 500));

  // int cantidadCirculos= ptcs.size();

  if (unaVez==false)
  {
    if (onPressed && ptcs.size() <=kennedyHombres[valSlider]) {
      println("contando :" + ptcs.size());
      for (int i=0; i<1; i++) {
        Ptc ptc = new Ptc(mouseX+random(-g.cellSize*.25, g.cellSize*.25), mouseY+random(-g.cellSize*.25, g.cellSize*.25));
        ptcs.add(ptc);
      }
      
    }
    if(ptcs.size()==kennedyHombres[valSlider]){
      unaVez=true;
      println("ya me llene");
    }
  }




  for (int i=ptcs.size ()-1; i>-1; i--) {
    Ptc ptc = ptcs.get(i);
    ptc.update();
  }
}

void drawPtcs() {
  for (int i=ptcs.size ()-1; i>-1; i--) {
    Ptc ptc = ptcs.get(i);
    ptc.display();
  }
}

//ESTA CLASE SE USA EN GRID AND CELL  Y EN UNA LISTA EN ESTE MISMO ARCHIVO
class Ptc { // CLASE PTC------------------------------------------------------------------------------------

  color c; //variable de color
  PVector pos, vel, acc; // vectores posicion velocidad y accion
  float friction, thres, thresT, weight, weightT;
  int attachedCol, attachedRow, pAttachedCol, pAttachedRow;

  Ptc(float initX, float initY) { // esta clase necesita dos valores
    pos = new PVector(initX, initY); // posicion inicial X y Y de los circulos
    vel = new PVector(0, 0); //velocidad 
    acc = new PVector(0, 0); //accion

    friction = random(.8, .95); 
    weight = weightT = 10;
    thres = thresT = 80;

    c = color(#2D11ED); // color del circulo

    initAttachedCell(); // funcion  initAttachedCell
  }

  void centralGravity() {
    PVector ctr = new PVector(width*.5, height*.5);
    PVector dir = PVector.sub(ctr, pos);
    dir.mult(.0005);
    acc.add(dir);
  }


  void updatePos() {
    vel.add(acc);
    vel.mult(friction);
    pos.add(vel);
    acc.set(0, 0);
  }


  void update() {
    //centralGravity();
    repelNeighbors();
    updatePos();
    updateParas();
    updateAttachedCell();
  }


  void repelNeighbors() {
    //Same cell comparison
    for (int k=0; k<g.cells[attachedRow][attachedCol].containingPtcs.size (); k++) {
      Ptc p = g.cells[attachedRow][attachedCol].containingPtcs.get(k);
      repelPtc(p);
    }
    //Cell comparison (right)
    if (attachedCol<g.cols-1) {
      for (int k=0; k<g.cells[attachedRow][attachedCol+1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow][attachedCol+1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (left)
    if (attachedCol>0) {
      for (int k=0; k<g.cells[attachedRow][attachedCol-1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow][attachedCol-1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (below)
    if (attachedRow<g.rows-1) {
      for (int k=0; k<g.cells[attachedRow+1][attachedCol].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow+1][attachedCol].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (top)
    if (attachedRow>0) {
      for (int k=0; k<g.cells[attachedRow-1][attachedCol].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow-1][attachedCol].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (right below)
    if (attachedCol<g.cols-1 && attachedRow<g.rows-1) {
      for (int k=0; k<g.cells[attachedRow+1][attachedCol+1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow+1][attachedCol+1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (right above)
    if (attachedCol<g.cols-1 && attachedRow>0) {
      for (int k=0; k<g.cells[attachedRow-1][attachedCol+1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow-1][attachedCol+1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (left below)
    if (attachedCol>0 && attachedRow<g.rows-1) {
      for (int k=0; k<g.cells[attachedRow+1][attachedCol-1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow+1][attachedCol-1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
    //Cell comparison (left above)
    if (attachedCol>0 && attachedRow>0) {
      for (int k=0; k<g.cells[attachedRow-1][attachedCol-1].containingPtcs.size (); k++) {
        Ptc p = g.cells[attachedRow-1][attachedCol-1].containingPtcs.get(k);
        repelPtc(p);
      }
    }
  }


  void repelPtc(Ptc ptc) {
    PVector dir = PVector.sub(pos, ptc.pos);
    float totalThres = thres + ptc.thres;
    if (dir.mag()<totalThres) {
      float force = 1.0/(pow(dir.mag()*.25, 2)+1);
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
      ptc.acc.sub(dir);
    }
  }

  void initAttachedCell() { //"inicializar celda adjunta()"

    //constrain restringe una variable , valor inicial, valor final
    float tmpX = constrain(pos.x, 0, width-1); // la posicion x va de 0 al ancho de la pantalla menos 1
    float tmpY = constrain(pos.y, 0, height-1);// la posicion y va de 0 al alto de la pantalla menos 1

    //println("esta es posicion x: "+ pos.x +" esta es posicion y: "+ pos.y);

    //floor : Calcula el valor int más cercano que es menor o igual que el valor del parámetro.
    // coge un valor del click entre 0 al ancho y el alto del canvas  tmpX -tmpY y lo divide en 100
    // como este valor es un decimal luego lo acerca a int mar cercado - redondea el número
    attachedCol = pAttachedCol = floor(tmpX/g.cellSize);
    attachedRow = pAttachedRow = floor(tmpY/g.cellSize);

    //println("valor adjunto columna"+ attachedCol);
    //println("valor adjunto fila"+ attachedRow );

    // g.cells[][]. busca segun los valores [attachedRow][attachedCol] la posicion de la grilla que es el mismo del valor del arreglo 
    //y agrega en la lista estos valores. 
    g.cells[attachedRow][attachedCol].containingPtcs.add(this);
  }

  void updateAttachedCell() {
    float tmpX = constrain(pos.x, 0, width-1);
    float tmpY = constrain(pos.y, 0, height-1);

    pAttachedCol = attachedCol;
    pAttachedRow = attachedRow;
    attachedCol = floor(tmpX/g.cellSize);
    attachedRow = floor(tmpY/g.cellSize);

    if (attachedRow == pAttachedRow && attachedCol == pAttachedCol) {
    } else {
      g.cells[attachedRow][attachedCol].containingPtcs.add(this);
      g.cells[pAttachedRow][pAttachedCol].containingPtcs.remove(this);
    }
  }

  void updateParas() {
    if (pos.x>0 && pos.x<width-1 && pos.y>0 && pos.y<height-1) {
      int imgIndex = floor(pos.x*.5) + floor(pos.y*.5)*srcImg.width;
      thresT = pow(1-brightness(srcImg.pixels[imgIndex])/255.0, 8)*148+2;
      weightT = pow(brightness(srcImg.pixels[imgIndex])/255.0, .5)*10;
    } else {
      thresT = .1;
      weightT = .1;
    }

    thres = lerp(thres, thresT, .75);
    weight = lerp(weight, weightT, .1);
  }


  void display() {
    strokeWeight(weight);
    stroke(c);
    point(pos.x, pos.y);
  }
} //finaliza la clase PTC
