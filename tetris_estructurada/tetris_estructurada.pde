
// Proyecto Tetris Estructurada

// variables Generales:
int gameWidth=0;
int gameHeight=0;
int scaled_height=0;//altura de la pantalla en cuadros de juego
int scaled_width=0;//ancho de la pantallaen cuadros de juego
int scale= 0; //el tamaño de los cuadros base del tetris
int nivel=1;//habra cuatro niveles 0-3
int intervalo=500;
int prevCounter=0;
int timeCounter=0;

//variables para Figura en juego:

//actuales
int pos_xFig=10;//desde 1 hasta width-2
int pos_yFig=1;//desde 1 hasta height-2
int rotacion=0;
int estado=0; // decide el color de la figura segun la convención usada.
int figura=1;
boolean ingame=false;
int timer=0;//variable de tiempo

//siguientes:
boolean choose=true;
int figura1=int(random(0,7));
int estado1=figura1+1;

//variables de memoria:
int matrix[][];//de posicion del tablero.
int play_height=0;//altura del tablero 
int play_width=0; //ancho del tablero
int score=0;
boolean show=false;


//Control de Pantallaz y demas UI:

//Pantalla de juego Game()
boolean GameScreen=true;//Me dice si estamos en la pantalla Game
boolean gameover=false;
boolean pause=false;



void settings() {
  gameWidth=displayWidth;
  //gameHeight=displayHeight;
  gameWidth=(gameWidth/2);
  gameHeight=(gameWidth);
  scale=gameWidth/24;
  scaled_height=gameHeight/scale;
  scaled_width=gameWidth/scale;
  play_height=20;//scaled_height-2;// altura del tablero en cuadritos 
  play_width=10;//(scaled_width*2/3)-2; //ancho del tablero en cuadritos
  // hacer una matriz con varias listas de int, para que se puedan elegir varios colores, en vez de uno.
  matrix = new int[scaled_height][scaled_width]; //sobre esta matriz se dibuja todo en la pantalla
  gameHeight-=scale*2;
  size(gameWidth, gameHeight);
}

    void setup() {
    
      rectMode(CORNER);
      textAlign(CENTER);
      background(0);
      frameRate(20);//FrameCount%10==0 es cada medio segundo; a menor numero de modulo mas rapido ira el pullDown();
      recordMatrix();
      
    }


    void draw() {
    
      background(0);
      println(figura1,figura);
      if(GameScreen){Game();}
      
      
    }

  // UI:
    
    // Para botones presionados
    void keyPressed() {
      
      if (key == CODED) {
    
        if (keyCode == UP) {
          if (pos_yFig>1) {
            if(GameScreen & !pause & !gameover){rotateRight();}
          }
          
        }
        if (keyCode == RIGHT) {
          if(GameScreen & !pause & !gameover & ingame){Translate(1);}
          
        } else if (keyCode == LEFT) {
          if(GameScreen & !pause & !gameover & ingame){Translate(-1);}
          
        }
        if (keyCode == SHIFT) {
          if(GameScreen & !pause){show= !show;}
          if(GameScreen & pause){Restart();}
          
        }
        if(keyCode == DOWN){
           if(GameScreen & !pause & !gameover){
             pullDown();
             score+=1*nivel;
           }//funcion de bajar mas rapido la figura y aumenta el score.
           
         }
         
      }
      
      if(keyCode == 32){//ESPACIO
            if(GameScreen & !gameover){ pause=!pause; }
            if(gameover){ Restart(); }
           
      }
      
    }
    
    // para cuando presionan el mouse
    void mouseClicked() {
    }



//Interzas gráfica:

// elegir el color de la figura a mostrar.
void selectColor(int color1) {
  if (color1==0) {//backgound
    fill(80,20);//negro
  } else if (color1==1) {//figura 0
    fill(248, 255, 0);//amarillo
  } else if (color1==2) {//figura 1
    fill(36, 254, 236);//azul claro
  } else if (color1==3) {//figura2
    fill(255, 7, 26);//rojo
  } else if (color1==4) {//figura3
    fill(45, 254, 19);//verde claro
  } else if (color1==5) {//figura4
    fill(38, 27, 251);//azul oscuro
  } else if (color1==6) {//figura5
    fill(251, 19, 254);//morado
  } else if (color1==7) {//figura6
    fill(251,83,177);//rosado
  } else if (color1==8) {//borde
    fill(255,188,35);
  }else if(color1==9){//Titulos Menus
    fill(4,90,210);//azul oscuro
  }else if(color1==10){////Comandos
    fill(0,205,42);//verde oscuro
  }
}

//Funcion que me dibuja un cuadro en relacion con cada celda de la matriz de juego
void drawBoard() {
  //cada espacio en la matriz corresponde a un cuadro de scale en largo.
  //dibujar fila por fila
  for (int j=0; j<scaled_height; j++) {

    for (int i=0; i<scaled_width; i++) {
      push();
      selectColor(matrix[j][i]);//selecciona el color segun el numero en la celda especifica matriz.
      if ((i>0 & i<play_width+1) & (j>0 & j<play_height+1)) {//seleccionar rango del tablero de juego
        strokeWeight(1);
        stroke(150);
      } else {
        strokeWeight(3);
        stroke(0);
      }
      square((scale*i), (scale*j), scale);
      pop();
    }
  }
  //borde();
}


void borde() {
  push();
  selectColor(8);
  strokeWeight(3);
  stroke(0);
  //dibujar layout en 2/3 de pantalla
  int board_width=scaled_width*2/3;
  int board_height= scaled_height;
  int x_pos=0;
  int y_pos=gameHeight-scale;
  //dibujar lineas horizontales
  for (int i=0; i<board_width+1; i++) {
    square(x_pos, y_pos, scale);
    square(x_pos, 0, scale);
    x_pos=(scale*i);
  }

  y_pos=0;
  x_pos= (gameWidth*2/3)-scale;
  //dibujar lineas verticales
  for (int i=0; i<board_height+1; i++) {
    square(0, y_pos, scale);
    square(x_pos, y_pos, scale);
    y_pos=(scale*i);
  }

  pop();
}

//figures: L3x2 (izquierda) y (derecha), cuadro2x2, lilnea 1x4, S 2x2 (izquierda) (derecha), T 3x2.
//TODAS LAS FIGURAS EXCEPTO POR EL CUADRADO EMPIEZAN DESDE EL EJE DE ROTACIÓN PARA NO TENER QUE ACTUALIZAR LA POSICION DE LA FIGURA CON CADA ROTACIÓN
//Las figuras deben dibujar cuadros cambiando los numeros en la matrix de juego.
void cuadrado(int pos_x, int pos_y, int colorS) {
  matrix[pos_y][pos_x]=colorS;//empezar desde la esquina superior izq.
  matrix[pos_y+1][pos_x]=colorS;
  matrix[pos_y+1][pos_x+1]=colorS;
  matrix[pos_y][pos_x+1]=colorS;
}

void linea(int pos_x, int pos_y, int colorLi, int rotacion) {//tarea 0=dibujar, tarea 1=revisar.

  matrix[pos_y][pos_x]=colorLi;//Empezar desde el cuadro central (2do tanto vertical como horizontal)
  if (rotacion==0) {//vertical mirando hacia abajo
    if (pos_y>1) {
      matrix[pos_y-1][pos_x]=colorLi;
    }//restriccion para el inicio de la caida
    matrix[pos_y+1][pos_x]=colorLi;
    matrix[pos_y+2][pos_x]=colorLi;
  } else if (rotacion==1) {//horizontal 1 izquierda 
    matrix[pos_y][pos_x-1]=colorLi;
    matrix[pos_y][pos_x+1]=colorLi;
    matrix[pos_y][pos_x+2]=colorLi;
  } else if (rotacion==2) {//vertical mirando hacia arriba
    matrix[pos_y+1][pos_x]=colorLi;
    matrix[pos_y-1][pos_x]=colorLi;
    matrix[pos_y-2][pos_x]=colorLi;
  } else if (rotacion==3) {//horizontal dos derecha
    matrix[pos_y][pos_x+1]=colorLi;
    matrix[pos_y][pos_x-1]=colorLi;
    matrix[pos_y][pos_x-2]=colorLi;
  } else if (rotacion==4) {//linea de borrado vertical (esta empieza desde abajo)
    if (pos_y>1) {
      matrix[pos_y-1][pos_x]=colorLi;
    }
    if (pos_y>2) {
      matrix[pos_y-2][pos_x]=colorLi;
    }
    if (pos_y>3) {
      matrix[pos_y-3][pos_x]=colorLi;
    }
  }
}

//Ele con la punta derecha
void ele1(int pos_x, int pos_y, int colorL, int rotacion) {
  
  matrix[pos_y][pos_x]=colorL;//cuadro central(eje de rotacion), el central del palo
  if (rotacion==0) {// caso por default horizontal con punta derecha
    matrix[pos_y][pos_x+1]=colorL;
    matrix[pos_y][pos_x-1]=colorL;
    if (pos_y>1) {
      matrix[pos_y-1][pos_x+1]=colorL;
    }//restringir la punta en la primera iteración de la bajada
  } else if (rotacion==1) {//vertical con punta superior
    matrix[pos_y+1][pos_x]=colorL;
    matrix[pos_y-1][pos_x]=colorL;
    matrix[pos_y-1][pos_x-1]=colorL;
  } else if (rotacion==2) {//horizontal con punta inferior
    matrix[pos_y][pos_x+1]=colorL;
    matrix[pos_y][pos_x-1]=colorL;
    matrix[pos_y+1][pos_x-1]=colorL;
  } else if (rotacion==3) {//vertical con punta inferior
    matrix[pos_y-1][pos_x]=colorL;
    matrix[pos_y+1][pos_x]=colorL;
    matrix[pos_y+1][pos_x+1]=colorL;
  }
}
// Ele con la punta izquierda.
void ele2(int pos_x, int pos_y, int colorL, int rotacion) {
  matrix[pos_y][pos_x]=colorL;//cuadro central(eje de rotacion), el central del palo
  if (rotacion==0) {//horizontal con punta superior por default.
    matrix[pos_y][pos_x-1]=colorL;//caso punta izquierda (superior por default)
    matrix[pos_y][pos_x+1]=colorL;
    if (pos_y>1) {
      matrix[pos_y-1][pos_x-1]=colorL;
    }
  } else if (rotacion==1) {//vertical punta inferior
    matrix[pos_y+1][pos_x]=colorL;
    matrix[pos_y-1][pos_x]=colorL;
    matrix[pos_y+1][pos_x-1]=colorL;
  } else if (rotacion==2) {//horizontal punta inferior
    matrix[pos_y][pos_x-1]=colorL;
    matrix[pos_y][pos_x+1]=colorL;
    matrix[pos_y+1][pos_x+1]=colorL;
  } else if (rotacion==3) {//vertical punta superior
    matrix[pos_y-1][pos_x]=colorL;
    matrix[pos_y+1][pos_x]=colorL;
    matrix[pos_y-1][pos_x+1]=colorL;
  }
  
}

//Ese normal, punta derecha.
void ese1(int pos_x, int pos_y, int colorS, int rotacion) {
  
  matrix[pos_y][pos_x]=colorS;//cuadro central(eje de rotacion), central inf por default
  if (rotacion==0) {//horizontal con punta superior derecha por default.
    matrix[pos_y][pos_x-1]=colorS;
    if (pos_y>1) {//restriccion primer iteracion
      matrix[pos_y-1][pos_x]=colorS;
      matrix[pos_y-1][pos_x+1]=colorS;
    }
  } else if (rotacion==1) {//vertical punta superior 
    matrix[pos_y+1][pos_x]=colorS;
    matrix[pos_y][pos_x-1]=colorS;
    matrix[pos_y-1][pos_x-1]=colorS;
  } else if (rotacion==2) {//horizontal punta inferior izq.
    matrix[pos_y][pos_x+1]=colorS;
    matrix[pos_y+1][pos_x]=colorS;
    matrix[pos_y+1][pos_x-1]=colorS;
  } else if (rotacion==3) {//vertical punta inferior
    matrix[pos_y-1][pos_x]=colorS;
    matrix[pos_y][pos_x+1]=colorS;
    matrix[pos_y+1][pos_x+1]=colorS;
  }
}

//Ese invertida, punta izquierda,
void ese2(int pos_x, int pos_y, int colorS, int rotacion) {
  
  matrix[pos_y][pos_x]=colorS;//cuadro central(eje de rotacion), el central del palo
  if (rotacion==0) {//horizontal con punta superior izq. por default. --__
    matrix[pos_y][pos_x+1]=colorS;
    if (pos_y>1) {
      matrix[pos_y-1][pos_x]=colorS;
      matrix[pos_y -1][pos_x-1]=colorS;
    }
  } else if (rotacion==1) {//vertical punta inferior
    matrix[pos_y-1][pos_x]=colorS;
    matrix[pos_y][pos_x-1]=colorS;
    matrix[pos_y+1][pos_x-1]=colorS;
  } else if (rotacion==2) {//horizontal punta inferior der. --__
    matrix[pos_y][pos_x-1]=colorS;
    matrix[pos_y+1][pos_x]=colorS;
    matrix[pos_y+1][pos_x+1]=colorS;
  } else if (rotacion==3) {//vertical punta superior
    matrix[pos_y+1][pos_x]=colorS;
    matrix[pos_y][pos_x+1]=colorS;
    matrix[pos_y-1][pos_x+1]=colorS;
  }
}

void te(int pos_x, int pos_y, int colorT, int rotacion) {
  
  matrix[pos_y][pos_x]=colorT;//cuadro central(eje de rotacion), el central del palo
  if (rotacion==0) {//horizontal con puta sup. por default
    matrix[pos_y][pos_x+1]=colorT;
    matrix[pos_y][pos_x-1]=colorT;
    if (pos_y>1) {
      matrix[pos_y -1][pos_x]=colorT;
    }
  } else if (rotacion==1) {//vertical punta izq.
    matrix[pos_y-1][pos_x]=colorT;
    matrix[pos_y][pos_x-1]=colorT;
    matrix[pos_y+1][pos_x]=colorT;
  } else if (rotacion==2) {//horizontal punta inferior
    matrix[pos_y+1][pos_x]=colorT;
    matrix[pos_y][pos_x+1]=colorT;
    matrix[pos_y][pos_x-1]=colorT;
  } else if (rotacion==3) {//vertical punta derecha
    matrix[pos_y][pos_x+1]=colorT;
    matrix[pos_y-1][pos_x]=colorT;
    matrix[pos_y+1][pos_x]=colorT;
  }
}


//Memoria: 

//Representación binaria del tablero de juego
void recordMatrix() {
  //Hacer bordes horizontales:
  for (int i=0; i<play_width+2; i++) {
    matrix[0][i]=8;
    matrix[play_height+1][i]=8;
  }
  //hacer bordes verticales
  for (int j=0; j<play_height+2; j++) {
    matrix[j][0]=8;
    matrix[j][play_width+1]=8;
  }
  //IMPRIMIR LA MATRIZ EN CONCOLSA 8 POR FILAS
  for (int j=0; j<play_height; j++) {
    //llenar linea horizontal.
    for (int i=0; i<play_width; i++) {
      print(matrix[j][i]);
    }
    print("\n");
  }
}

// Control/ Funcionalidades del juego:

// pinta la figura deseada segun el caso y la rotacion especificada
void figura(int posx, int posy, int colorF, int caso, int rotacion) {
  if (caso==0) {
    cuadrado(posx, posy, colorF);
  } else if (caso==1) {
    linea(posx, posy, colorF, rotacion);
  } else if (caso==2) {
    ele1(posx, posy, colorF, rotacion);
  } else if (caso==3) {
    ele2(posx, posy, colorF, rotacion);
  } else if (caso==4) {
    ese1(posx, posy, colorF, rotacion);
  } else if (caso==5) {
    ese2(posx, posy, colorF, rotacion);
  } else if (caso==6) {
    te(posx, posy, colorF, rotacion);
  }
}

//revisar si se puede bajar la figura
boolean checkDown() {
  boolean down=true;

  if (figura==0) {//cuadrado
    if (matrix[pos_yFig+2][pos_xFig]!=0 || matrix[pos_yFig+2][pos_xFig+1]!=0) {down=false;}
    
  } else if (figura==1) {//linea

    if (rotacion==0) {
      if (matrix[pos_yFig+3][pos_xFig]!=0) {down=false;}
    } else if (rotacion==2) {
      if ( matrix[pos_yFig+2][pos_xFig]!=0) {down=false;}
    } else if (rotacion==1) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig+2]!=0){down=false;}
    } else if (rotacion==3) {
      if (matrix[pos_yFig+1][pos_xFig-2]!=0 ||matrix[pos_yFig+1][pos_xFig-1]!=0||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0){down=false;}
    }
    
  } else if (figura==2) {//ele punta derecha

    if (rotacion==0) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}
    } else if (rotacion==2) {
      if (matrix[pos_yFig+2][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}
    } else if (rotacion==1) {//verticales
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig+2][pos_xFig]!=0) {down=false;}
    } else if (rotacion==3) {
      if (matrix[pos_yFig+2][pos_xFig]!=0 ||matrix[pos_yFig+2][pos_xFig+1]!=0) {down=false;}//mismo que para cuadrado
    }
    
  } else if (figura==3) {// elel punta izquierda

    if (rotacion==0) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}//misma para ele1 caso0
    } else if (rotacion==2) {
      if (matrix[pos_yFig+2][pos_xFig+1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig-1]!=0) {down=false;}
    } else if (rotacion==1) {//verticales
      if (matrix[pos_yFig+2][pos_xFig-1]!=0 ||matrix[pos_yFig+2][pos_xFig]!=0) {down=false;}//casi misma que el cuadrado pero con eje a la der.
    } else if (rotacion==3) {
      if (matrix[pos_yFig+2][pos_xFig]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0) {down=false;}//casi misma que ele1 caso1, pero con x multiplicada(-1)
    }
    
  } else if (figura==4) {//ese punta derecha

    if (rotacion==0) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig][pos_xFig+1]!=0) {down=false;}//solo tres cuadros que checar
    } else if (rotacion==2) {
      if (matrix[pos_yFig+2][pos_xFig-1]!=0 ||matrix[pos_yFig+2][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}
    } else if (rotacion==1) {//verticales (solo dos cuadros a revisar)
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+2][pos_xFig]!=0) {down=false;}
    } else if (rotacion==3) {
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig+2][pos_xFig+1]!=0) {down=false;}
    }
    
  } else if (figura==5) {//ese punta izq.

    if (rotacion==0) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig+1]!=0||matrix[pos_yFig][pos_xFig-1]!=0) {down=false;}
    } else if (rotacion==2) {
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+2][pos_xFig]!=0||matrix[pos_yFig+2][pos_xFig+1]!=0) {down=false;}
    } else if (rotacion==1) {//verticales
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig+2][pos_xFig-1]!=0) {down=false;}
    } else if (rotacion==3) {
      if (matrix[pos_yFig+2][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}
    }
    
  } else if (figura==6) {//te

    if (rotacion==0) {//horizontales
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig-1]!=0) {down=false;}//mismo que ele1 y ele2 caso 0
    } else if (rotacion==2) {
      if (matrix[pos_yFig+1][pos_xFig-1]!=0 ||matrix[pos_yFig+1][pos_xFig+1]!=0||matrix[pos_yFig+2][pos_xFig]!=0) {down=false;}
    } else if (rotacion==1) {//verticales
      if (matrix[pos_yFig+2][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig-1]!=0) {down=false;}
    } else if (rotacion==3) {
      if (matrix[pos_yFig+2][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig+1]!=0) {down=false;}//mismo que para figura 5 caso3
    }
  }
  return down;
}

//baja la figura en juego.   
void pullDown() {
  figura(pos_xFig,pos_yFig,estado,figura,rotacion);
  if (checkDown()) {//revisar la condicion de si el cuadro de abajo ya esta ocupado
    figura(pos_xFig, pos_yFig, 0, figura, rotacion);//borrar figura actual
    pos_yFig++;
    //actualizar posicion
    figura(pos_xFig, pos_yFig, estado, figura, rotacion);//dibujar figura actualizada
  }
}

//Mover las figuras hacia los lados.
void Translate(int dir) {//1=derecha; -1=izquierda
  if (checkTranslate(dir) & !gameover) {
    //borrar figura actual
    figura(pos_xFig, pos_yFig, 0, figura, rotacion);
    //actualizar posicion
    pos_xFig+=dir;
    //dibujar nueva figura.
    figura(pos_xFig, pos_yFig, estado, figura, rotacion);
  }
}

boolean checkTranslate(int dir) {//dir=-1,izquierda; dir=+1,derecha.
  boolean Translate=true;

  if (figura==0) {//cuadrado
    if(dir==-1){
      if (matrix[pos_yFig][pos_xFig+dir]!=0 & matrix[pos_yFig+1][pos_xFig+dir]!=0) {Translate=false;}
    }else{
      if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0 & matrix[pos_yFig+1][pos_xFig+(2*dir)]!=0) {Translate=false;}
    }
    
  } else if (figura==1) {//linea

    if (rotacion==0) {//verticales
      if (matrix[pos_yFig][pos_xFig+dir]!=0 || matrix[pos_yFig+1][pos_xFig+dir]!=0||matrix[pos_yFig+2][pos_xFig+dir]!=0 || matrix[pos_yFig-1][pos_xFig+dir]!=0){Translate=false;}
    } else if (rotacion==2) {
      if (matrix[pos_yFig][pos_xFig+dir]!=0 || matrix[pos_yFig+1][pos_xFig+dir]!=0||matrix[pos_yFig-1][pos_xFig+dir]!=0 || matrix[pos_yFig-2][pos_xFig+dir]!=0) {Translate=false;}
    } else if (rotacion==1) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig-2]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+3]!=0) {Translate=false;}
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig-3]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+2]!=0) {Translate=false;}
      }
    }
    
  } else if (figura==2) {//ele punta derecha

    if (rotacion==0) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig]!=0) {Translate=false;}
      } else{
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-1][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    }else if (rotacion==2) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0 ||matrix[pos_yFig+dir][pos_xFig]!=0) {Translate=false;}
      }
    } else if (rotacion==1) {//verticales
      if (dir==-1) {
        if (matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    }
    
  } else if (figura==3) {//ele punta izquierda

    if (rotacion==0) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig-dir][pos_xFig]!=0||matrix[pos_yFig][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    } else if (rotacion==2) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    } else if (rotacion==1) {//verticales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}//mismo que rotacion1 dir+1
      } else {
        if (matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0||matrix[pos_yFig-1][pos_xFig+2]!=0) {Translate=false;}
      }
    }
    
  } else if (figura==4) {//ese punta derecha

    if (rotacion==0) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    } else if (rotacion==2) {
      if (dir==-1) {
        if (matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig][pos_xFig+dir]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==1) {//verticales
      if (dir==-1) {
        if (matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig]!=0) {Translate=false;}
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    }
    
  } else if (figura==5) {//ese punta izquierda

    if (rotacion==0) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig-dir][pos_xFig+dir]!=0||matrix[pos_yFig][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    } else if (rotacion==2) {
      if (dir==-1) {
        if (matrix[pos_yFig-dir][pos_xFig+dir]!=0||matrix[pos_yFig][pos_xFig+(2*dir)]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig+dir][pos_xFig+(2*dir)]!=0||matrix[pos_yFig][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==1) {//verticales
      if (dir==-1) {
        if (matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}//misma que rot=0 dir=1
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+(2*dir)]!=0) {Translate=false;}
      }
    }
    
  } else if (figura==6) {//te

    if (rotacion==0) {//horizontales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    } else if (rotacion==2) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}//misma que rot0 dir-1
      }
    } else if (rotacion==1) {//verticales
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}//misma que ele2 rot1 dir1
      }
    } else if (rotacion==3) {
      if (dir==-1) {
        if (matrix[pos_yFig][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0) {Translate=false;}
      } else {
        if (matrix[pos_yFig][pos_xFig+(2*dir)]!=0||matrix[pos_yFig-dir][pos_xFig+dir]!=0||matrix[pos_yFig+dir][pos_xFig+dir]!=0) {Translate=false;}
      }
    }
    
  }

  return Translate;
}

//Funcion de rotación (me llaman el caso especifico de la figura y ademas me actualizan las variabes Pos_xFig y pos_yFig para que las funciones PullDown y slide no pierdan track de la figura
//tener cuidado con los limites de movimiento a la hora de hacer las rotaciones

//Rotación Horaria de la figura
void rotateRight() {//(caso--)
  if (checkRotate()) {
    //borrar figura actual
    figura(pos_xFig, pos_yFig, 0, figura, rotacion);
    if (rotacion==0) {
      rotacion=3;
    } else {
      rotacion--;
    }
    figura(pos_xFig, pos_yFig, estado, figura, rotacion);
  }
}

//Funcion que revisa si la figura si se puede rotar
boolean checkRotate() {
  boolean rotate=true;
  //si las rotaciones son verticales(impares), hacer que el checkDown tambien las afecten.
    if (!checkDown()) {rotate=false;}
    
  if(figura==0){//cuadrado
    
    if(!checkDown()){rotate=false;}
  
  } else if (figura==1) {//linea

    if (rotacion==0) {//3
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig-2]!=0||matrix[pos_yFig][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig-1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+2][pos_xFig]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig][pos_xFig+2]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig-1][pos_xFig]!=0 ||matrix[pos_yFig-2][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig]!=0) {rotate=false;}
    }
    
  } else if (figura==2) {//ele punta derecha

    if (rotacion==0) {//3
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig-1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig-1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig-1][pos_xFig]!=0||matrix[pos_yFig-1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig-1]!=0) {rotate=false;}
    }
    
  } else if (figura==3) {//ele punta izquierda

    if (rotacion==0) {//3
      if (matrix[pos_yFig-1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig-1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig-1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig-1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {rotate=false;}
    }
    
  } else if (figura==4) {//ese punta derecha

    if (rotacion==0) {//3
      if (matrix[pos_yFig][pos_xFig+1]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig-1][pos_xFig]!=0||matrix[pos_yFig-1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig][pos_xFig-1]!=0 ||matrix[pos_yFig-1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig+1][pos_xFig]!=0||matrix[pos_yFig+1][pos_xFig-1]!=0) {rotate=false;}
    }
  } else if (figura==5) {//ese punta izquierda

    if (rotacion==0) {//3
      if (matrix[pos_yFig+1][pos_xFig]!=0 ||matrix[pos_yFig-1][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig][pos_xFig+1]!=0 ||matrix[pos_yFig-1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig-1][pos_xFig]!=0 ||matrix[pos_yFig+1][pos_xFig-1]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig][pos_xFig-1]!=0||matrix[pos_yFig+1][pos_xFig+1]!=0) {rotate=false;}
    }
  } else if (figura==6) {//te

    if (rotacion==0) {//3
      if (matrix[pos_yFig+1][pos_xFig]!=0) {rotate=false;}
    } else if (rotacion==1) {//0
      if (matrix[pos_yFig][pos_xFig+1]!=0) {rotate=false;}
    } else if (rotacion==2) {//1
      if (matrix[pos_yFig-1][pos_xFig]!=0) {rotate=false;}
    } else if (rotacion==3) {//2
      if (matrix[pos_yFig][pos_xFig-1]!=0) {rotate=false;}
    }
  }

  return rotate;
}

//Revisa si hay Game over
void checkGameOver(){
  if(!checkDown()){
      if(matrix[1][(play_width/2)-1]!=0 ||matrix[1][(play_width/2)]!=0 || matrix[1][(play_width/2)-2]!=0){gameover=true;}
   }
  
}

//Funcion que permite la jugabilidad (donde ingame se reinicia si la figura choca abajo)(La funcion principal del juego) 
void Play() {
  //checar si se sube de nivel segun el timeCounter
  if(timeCounter-prevCounter >= 90){
     prevCounter=timeCounter;
     if(nivel<4){nivel++;}//nivel max.4
  }
  intervalo=500-(50*(nivel-1));
  //no agregar un for porque va a ir en el draw asi que ya se repite
  if (!ingame) {//si ya no se puede bajar o rotar se reinician los valores para una nueva figura
    pos_yFig=1; //reiniciar variables de posicion
    pos_xFig=(play_width/2)-1;
    rotacion=0;
    figura=figura1;
    estado=estado1;
    if(!gameover){figura1=int(random(0,7));}
    estado1=figura1+1;
    NewFigure();
    ingame=true;//reiniciar booleano
    eraseLine();
  } else {//cuando la ficha esta en juego
    //figura(pos_xFig,pos_yFig,estado,figura,rotacion);
    if (TimeDown()) {pullDown();}
    if (!checkDown() & !checkRotate()) {ingame=false;}
    checkGameOver();

  }
  
}

//La Funcion que ve si una linea ya ha sido llenada,la borra y baja las demas filas.
void eraseLine(){ 
  int counter=0;
  for (int j=1; j<play_height+1; j++) {//recorre por filas (j=numero de fila)
    counter=0;//reiniciar el counter cada vez que se itere cada fila
    for (int i=1; i<play_width+1; i++) {
      if(matrix[j][i]!=0){counter++;}   
    }
    if(counter==play_width){//si la fila esta llena
      //borrar line
      for(int i=1;i<play_width+1;i++){
        matrix[j][i]=0;
        score+=100*nivel;
      }
      //bajar lineas
        LinesDown(j);
    }
    
  }
   
}

//La funcion que baja a las demas filas y resetea la ultima fila.
void LinesDown(int line){
  //recorrer la matriz desde j line hacia arriba
  for(int y=line;y>0;y--){
    if(y>1){
      for(int i=0;i<play_width+1;i++){
        matrix[y][i]=matrix[y-1][i];
      }
      
    }else{
      for(int i=1;i<play_width+1;i++){
        matrix[y][i]=0;
      }
      
    }
       
  }
 
  
}
//Cuenta el Tiempo de bajada
boolean TimeDown(){
   boolean down=false;
   if(millis()-timer>=intervalo){
     timer=millis();
     down=true;
     timeCounter++;
   }
   return down;
}

//Pantallas y demas Interzaces: 

//Pantalla de Juego;

void Game(){
  //Inicializacion del Juego
    drawBoard();
    if (show) {printPlayMatriz();}
    //Dibujar Interfaz de la pantalla:
    //Dibujar cuadrito con la siguiente figura ¿meterla en PLay?
     Bordesito(play_width+4,1,8,5);
     //dibujar Cuadrito con Score
     Bordesito(play_width+3,9,10,5);
     push();
     fill(255);
     textSize(50);
     text("PUNTAJE:",scale*18,(scale*12)-20);
     text(score,scale*18,(scale*14)-20);
     fill(249,20,20);
     textSize(40);
     text("NIVEL:",scale*18,(scale*18)+10);
     text(nivel,scale*18,(scale*19)+20);
     pop();
     
   //Dibujar Cuadrito con Numero de Nivel 
     Bordesito(play_width+4,16,8,4);  
     
  //Jugar
    if(!gameover){
       if(!pause){Play();}
       else{ pauseScreen();}
     }else{
       GameOverScreen();
     }
  
}
//Dibujar cuadrito de Interfaz desde ezquina izquierda (x,y)
void Bordesito(int x, int y,int ancho, int largo){
   for(int i=0;i<ancho;i++){
      matrix[y][x+i]=8;
      matrix[y+largo][x+i]=8;
      if(i>0 & i<largo){
         matrix[y+i][x]=8;
         matrix[y+i][x+ancho-1]=8;
      }
   }

}

//Funcion que reinicia el juego
void Restart(){
  //Reiniciar Variables
  pos_yFig=1;
  pos_xFig=(play_width/2)-1;
  rotacion=0;
  figura1=int(random(0,7));
  estado1=figura1+1;
  ingame=true;
  gameover=false;
  pause=false;
  nivel=1;
  score=0;
  //Reiniciar Matriz de Juego
  for(int j=1;j<play_height+1;j++){
    for(int i=1;i<play_width+1;i++){
      matrix[j][i]=0;
    }
  }
  //Lamar La funcion de Juego Otravez
  GameScreen=true;

}

//Pantalla de Pausa
void pauseScreen(){
  push();
  fill(200,200,200,255*.50);
  square(0,0,gameWidth);
  fill(255,188,35);
  square(scale*2,scale,scale*20);//(x,y,ancho)
  textSize(60);
  selectColor(9);
  text("PAUSA",scale*12,scale*5);//(char,x,y);
  textSize(60);
  fill(0);
  text("Tu puntaje Es:",12*scale,8*scale);
  text(score,12*scale,11*scale);
  selectColor(10);
  textSize(30);
  Boton(scale*5,(scale*13)-10);
  text("Presione Espacio para Reanudar",scale*12,scale*14);
  Boton(scale*5,(scale*16)-10);
  textSize(25);
  text("Presione SHIFT para Iniciar Nuevo Juego",scale*12,scale*17);
  pop();
  

}

//Se activa cuando se pierde el juego
void GameOverScreen(){
  push();
  selectColor(8);
  rect(0,0,gameWidth,gameHeight);
  selectColor(9);
  textSize(80);
  text("GAME OVER!",12*scale,5*scale);
  fill(0);
  textSize(60);
  text("Tu puntaje Fue:",12*scale,8*scale);
  text(score,12*scale,11*scale);
  Boton(5*scale,(14*scale)-10);
  selectColor(10);
  textSize(30);
  text("Presione Espacio para Volver a Jugar",12*scale,15*scale);
  pop();
    

}

//resetear cuadrito figura siguiente:
void NewFigure(){
  
  for(int j=0;j<3;j++){
    for(int i=0;i<5;i++){
      matrix[3+j][play_width+6+i]=0;
    }
  }
  if(figura1!=1 & figura1!=0){figura(play_width+7,4,estado1,figura1,0);}
  else if (figura1!=0){figura(play_width+7,4,estado1,figura1,1);}
  else{figura(play_width+7,3,estado1,figura1,1);}
}

//Boton
void Boton(int x, int y ){
  push();
  selectColor(1);
  strokeWeight(8);
  stroke(0);
  rect(x,y,scale*14,scale*2);
  pop();
}
// imprime la matriz en tiempo real en pantalla.
//text(c,x, y)
void printPlayMatriz() {
  //imprimir matriz actualizada
  push();
  textSize(scale);
  textAlign(LEFT);
  fill(200, 200, 200, 150);
  for (int j=0; j<play_height+2; j++) {
    for (int i=0; i<play_width+2; i++) {
      text(matrix[j][i], (i*scale), (j*scale)+(scale));
    }
  }
  pop();
}
