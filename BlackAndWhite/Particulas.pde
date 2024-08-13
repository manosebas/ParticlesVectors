class Particulas {
  PVector posicion = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector obj = new PVector(0, 0);

  float distObjetivo = 80;
  float speed = 8.0;
  float fuerza = 0.1;
  float size = 4;
  boolean died = false;
  color colores = color(0);

  void display() {
    // Dibujo la particula
    noStroke();
    fill(colores);
    ellipse(posicion.x, posicion.y, size, size);

  }
  
  void move() {
    //Revisa si la particula esta cerca del objetivo para reducir velocidad
    float aproximidad = 1;
    float distancia = dist(posicion.x, posicion.y, obj.x, obj.y);
    if (distancia < distObjetivo) {
      aproximidad = distancia/distObjetivo;
    }

    //Agregamos fuerza hacia el objeto
    PVector toObjetivo = new PVector(obj.x, obj.y);
    toObjetivo.sub(posicion);
    //toObjetivo.normalize(); //Toma cualquier vector con cualquier tamanio y direccion y lo hace un vector unitario, tamanio 1. mag?div
    //toObjetivo.mult(speed*aproximidad);
    toObjetivo.setMag(speed*aproximidad);
    
    //Agregamos direccion hacia el objeto
    PVector direccion = new PVector(toObjetivo.x, toObjetivo.y);
    direccion.sub(vel);
    //direccion.normalize();
    //direccion.mult(fuerza);
    direccion.setMag(fuerza);
    acc.add(direccion);

    //Movemos la particula
    vel.add(acc);
    posicion.add(vel);
    acc.mult(0);
  }
  
  void animacionSalida() {
    if (died == false) {
      //Cambiamos el objetivo fuera de la pantalla para que cambie de direccion
      PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
      obj.x = randomPos.x;
      obj.y = randomPos.y;

      //Cambio de color a particulas muertas
      colores = color(#8CF0BF);
      //colores = color(random(0,255),random(0,255),random(0,255));

      
      died = true;
    }
  }
  
  
}
