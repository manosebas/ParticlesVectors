ArrayList<Particulas> particulas = new ArrayList<Particulas>(); //Arreglo donde guardare las particulas en pantalla
int pixelSteps = 1; // Piexeles entre particulas
ArrayList<String> arreglo = new ArrayList<String>(); //Guardaremos lo que queremos que se muestre en pantalla
String tipoLetra = "Arial Bold";
int arregloIndex = 0;

void setup() {
  size(720, 480, P2D);
  //fullScreen(); //Descomentar para probar con pantalla completa, solo funciona en pc poderoso
  background(0);
  
  //Inicio del arreglo
  arreglo.add(tiempo());
  arreglo.add(fecha());
  arreglo.add(" ");
  cambioGrafico(arreglo.get(arregloIndex));
}

void draw() {
  // Background & efectos de cola de las particulas
  //fill(255,100); //Descomentar para otro efecto
  fill(0,5); 
  noStroke();
  rect(0, 0, width*2, height*2);

  for (int i = 0; i < particulas.size()-1; i++) {
    //Objetengo las particulas, muestro y muevo
    Particulas particle = particulas.get(i);
    particle.move();
    particle.display();

    //Eliminio la particula del arreglo si sale de pantalla
    if (particle.died == true) {
      if (particle.posicion.x < 0 || particle.posicion.x > width || particle.posicion.y < 0 || particle.posicion.y > height) {
        particulas.remove(particle);
      }
    }
  }

}

//Hora actual
String tiempo(){
  int s = second();
  int m = minute();
  int h = hour();
  String hora = nf(h,2) + ":" + nf(m,2) + ":" + nf(s,2);
  return hora;
}

//Fecha actual
String fecha(){
  int d = day();
  int m = month();
  int y = year();
  String fecha = nf(d,2) + " / " + nf(m,2) + " / " + nf(y,2);
  return fecha;
  
}

//Reinicio el arreglo para volver a tener fecha y hora actuales 
void reiniciar(){
  for(int i = 0; i<arreglo.size(); i++){
    arreglo.remove(i);
  }
  arreglo.add(tiempo());
  arreglo.add(fecha());
  arreglo.add(" ");
  arregloIndex = 0;
}

//Mostrar el siguiente grafico en el arreglo
void mousePressed() {
  if (mouseButton == LEFT) {
    arregloIndex += 1;
    cambioGrafico(arreglo.get(arregloIndex));

    if (arregloIndex == arreglo.size()-1) { 
      reiniciar();      
    }
    
  }
}

//Elige una posicion aleatoria desde un punto de particula
PVector generateRandomPos(int x, int y, float mag) {
  
  PVector randomDir = new PVector(random(0, width), random(0, height));
  PVector posicion = new PVector(x, y);
  
  posicion.sub(randomDir);
  posicion.normalize();
  posicion.mult(mag);
  posicion.add(x, y);
  
  return posicion;
}

//Las particulas dibujan el grafico
void cambioGrafico(String texto) {
  
  //Creo el grafico
  PGraphics grafico = createGraphics(width, height);
  grafico.beginDraw();
  grafico.fill(0);
  grafico.textSize(100);
  grafico.textAlign(CENTER);
  PFont fuente = createFont(tipoLetra, 100);
  grafico.textFont(fuente);
  grafico.text(texto, width/2, height/2);
  grafico.endDraw();
  grafico.loadPixels();
  
  int conteo = particulas.size();
  int IndexParticulas = 0;

  //Guardamos coordenadas como indices en un arreglo
  //Para un movimiento mas fluido al escoger al azar
  ArrayList<Integer> IndexCoordenadas = new ArrayList<Integer>();
  for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
    IndexCoordenadas.add(i);
  }

  for (int i = 0; i < IndexCoordenadas.size (); i++) {
    //Escogemos una coordenada aleatorea 
    int randomIndex = (int)random(0, IndexCoordenadas.size());
    int IndexCor = IndexCoordenadas.get(randomIndex);
    IndexCoordenadas.remove(randomIndex);
    
    //Solo continua si el pizel no es blanco
    if (grafico.pixels[IndexCor] != 0) {
      //Convierte indice a sus coordenadas
      int x = IndexCor % width;
      int y = IndexCor / width;

      Particulas auxParticula;
      
      if (IndexParticulas < conteo) {
        //Usa una particula que esta en pantalla 
        auxParticula = particulas.get(IndexParticulas);
        auxParticula.died = false;
        IndexParticulas += 1;
      } else {
        //Crea una nueva
        auxParticula = new Particulas();
        
        PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
        auxParticula.posicion.x = randomPos.x;
        auxParticula.posicion.y = randomPos.y;
        
        auxParticula.speed = random(2.0, 5.0);
        auxParticula.fuerza = auxParticula.speed*0.025;
        auxParticula.size = random(3, 6);
        
        particulas.add(auxParticula);
      }
      
      //Agregamos colores aleatorios a cada particula
      auxParticula.colores = color(random(0,255),random(0,255),random(0,255));
      
      //Nuevo objetivo para direccionar
      auxParticula.obj.x = x;
      auxParticula.obj.y = y;
    }
  }

  //Elimina las particulas que sobren al cambiar de grafico
  if (IndexParticulas < conteo) {
    for (int i = IndexParticulas; i < conteo; i++) {
      Particulas particle = particulas.get(i);
      particle.animacionSalida();
    }
  }
}
