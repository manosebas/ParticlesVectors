ArrayList<Particulas> particulas = new ArrayList<Particulas>(); //Arreglo donde guardare las particulas en pantalla
int pixelSteps = 1; // Piexeles entre particulas
ArrayList<PImage> arreglo = new ArrayList<PImage>(); //Guardaremos lo que queremos que se muestre en pantalla
int arregloIndex = 0;
PImage leon, luna, atrapaSueno, rosa, blanco, girasol;

void setup() {
  size(720, 900, P2D);
  background(255);
  
  luna = loadImage("luna.jpg");
  luna.filter(THRESHOLD);
  leon = loadImage("leon.jpg");
  leon.filter(THRESHOLD,0.2);
  rosa = loadImage("rosa.jpg");
  rosa.filter(THRESHOLD);
  atrapaSueno = loadImage("atrapaSueno.jpg");
  atrapaSueno.filter(THRESHOLD);
  blanco = loadImage("blanco.jpg");
  blanco.filter(THRESHOLD);
  
  
  //Inicio del arreglo
  arreglo.add(leon);
  arreglo.add(luna);
  arreglo.add(rosa);
  arreglo.add(atrapaSueno);
  arreglo.add(blanco);
  cambioGrafico(arreglo.get(arregloIndex));
}

void draw() {
  // Background & efectos de cola de las particulas
  fill(255); //Le ponemos alpha para la cola
  noStroke();
  rect(0, 0, width*2, height*2);

  for (int i = 0; i < particulas.size()-1; i++) {
    //Objtengo las particulas, muestro y muevo
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

//Mostrar el siguiente grafico en el arreglo
void mousePressed() {
  if (mouseButton == LEFT) {
    arregloIndex += 1;
    cambioGrafico(arreglo.get(arregloIndex));

    if (arregloIndex == arreglo.size()-1) { 
      arregloIndex = -1; //Para volver a inciar al hacer click +1     
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
void cambioGrafico(PImage imagen) {
  
  PGraphics grafico = createGraphics(width,height);
  grafico.beginDraw();
  grafico.imageMode(CENTER);
  grafico.image(imagen, width/2, height/2);
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
    
    //Solo continua si el pixel es negro
    if (grafico.pixels[IndexCor] == color(0)) {
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
      
      //Agregamos colores aleatorios a cada particula ****
      auxParticula.colores = color(0);
      //auxParticula.colores = color(random(0,255),random(0,255),random(0,255));
      
      
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
