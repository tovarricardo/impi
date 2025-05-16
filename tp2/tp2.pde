PImage[] slides;
PImage startBg;
PImage restartBg;
int currentSlide = 0;
int lastTime = 0;
boolean started = false;
float slideX, slideY;
float textAlpha = 0;
float textScale = 0.5;
float bgFade = 0;

// Constantes 
final int DURACION_DIAPOSITIVA = 4000;
final color AMARILLO_CYBER = color(255, 255, 0);
final color ROSA_CYBER = color(255, 0, 128);
final color AZUL_NEON = color(0, 200, 255);
final int TOTAL_DIAPOSITIVAS = 6;

String[] textos = {
  "CYBERPUNK 2077: Un mundo futurista\ndonde la tecnología y la decadencia\nse entrelazan en Night City.",
  "Juega como V, un mercenario\nen busca de un implante único\nque podría darle la inmortalidad.",
  "Explora distritos llenos de\ncorporaciones corruptas, hackers\ncyborgs y una sociedad dividida.",
  "Personaliza tu experiencia con\narmas, cyberware y decisiones\nque cambian la historia.",
  "Enfréntate a peligrosas bandas\ny corporaciones mientras\ndescubres los secretos de Night City.",
  "El destino de la ciudad\ndependerá de tus acciones.\n¿Estás listo para el desafío?"
};

void setup() {
  size(640, 480);
  smooth();
  frameRate(60);

  // Iniciar imágenes
  slides = new PImage[TOTAL_DIAPOSITIVAS];
  for (int i = 0; i < TOTAL_DIAPOSITIVAS; i++) {
    try {
      slides[i] = loadImage("slide" + i + ".jpg");
      slides[i].resize(width, height);
    }
    catch (Exception e) {
      slides[i] = crearFondoCyberpunk(i);
    }
  }

  // Cargar fondos
  try {
    startBg = loadImage("start_bg.jpg");
    startBg.resize(width, height);
    restartBg = loadImage("restart_bg.jpg");
    restartBg.resize(width, height);
  }
  catch (Exception e) {
    startBg = crearFondoCyberpunk(0);
    restartBg = crearFondoCyberpunk(1);
  }

  //texto
  textAlign(CENTER, CENTER);
  textSize(24);
  slideX = width/2;
  slideY = height/3;
}

PImage crearFondoCyberpunk(int estilo) {
  PImage bg = createImage(width, height, RGB);
  bg.loadPixels();

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      color c;
      float distCentro = dist(x, y, width/2, height/2);

      if (estilo == 0) {
        float r = map(distCentro, 0, width/2, 0, 50);
        float g = map(y, 0, height, 10, 30);
        float b = map(x, 0, width, 30, 50);
        c = color(r, g, b);
      } else {
        float r = map(y, 0, height, 30, 10);
        float g = 0;
        float b = map(distCentro, 0, width/2, 30, 10);
        c = color(r, g, b);
      }

      if (random(1) > 0.95) {
        c = color(0, random(150, 255), random(200, 255), random(50, 100));
      }

      bg.pixels[x + y * width] = c;
    }
  }

  bg.updatePixels();
  return bg;
}

void draw() {
  bgFade = lerp(bgFade, 255, 0.05);
  background(0);

  if (!started) {
    dibujarPantallaInicio();
  } else {
    dibujarPresentacion();
  }
}

void dibujarPantallaInicio() {
  if (frameCount % 20 < 2) {
    tint(255, 50, 50, 200);
  } else {
    tint(255, bgFade);
  }
  image(startBg, 0, 0);
  noTint();

  dibujarTextoNeon("CYBERPUNK 2077", width/2, 100, 48, AZUL_NEON);
  dibujarTextoNeon("PRESENTACIÓN", width/2, 160, 36, ROSA_CYBER);

  boolean hover = mouseSobreBoton(width/2, height/2, 300, 100);
  dibujarBotonCyber("INICIAR VIAJE", width/2, height/2, 300, 100, 42, hover);

  fill(150, 200, 255, 100);
  textSize(16);
  text("Haz clic para comenzar la experiencia", width/2, height - 50);
}

void dibujarPresentacion() {
  tint(255, bgFade);
  image(slides[currentSlide], 0, 0);
  noTint();

  slideX = lerp(slideX, width/2, 0.07);
  slideY = lerp(slideY, height/3, 0.07);
  textAlpha = lerp(textAlpha, 255, 0.04);
  textScale = lerp(textScale, 1.0, 0.06);

  pushMatrix();
  translate(slideX, slideY);
  scale(textScale);

  fill(255, textAlpha);
  textSize(28);
  text(textos[currentSlide], 0, 0);

  dibujarTextoNeon(textos[currentSlide], 0, 0, 28, AMARILLO_CYBER);
  popMatrix();

  dibujarIndicadorDiapositivas();

  if (currentSlide < TOTAL_DIAPOSITIVAS - 1 && millis() - lastTime > DURACION_DIAPOSITIVA) {
    siguienteDiapositiva();
  }

  // Botón solo aparece en última diapositiva
  if (currentSlide == TOTAL_DIAPOSITIVAS - 1) {
    fill(0, 150);
    rect(0, 0, width, height);

    boolean hover = mouseSobreBoton(width/2, height-100, 300, 80);
    dibujarBotonCyber("VOLVER AL INICIO", width/2, height-100, 300, 80, 36, hover);
  }
}

void dibujarTextoNeon(String txt, float x, float y, float size, color colorNeon) {
  textSize(size);

  for (int i = 5; i > 0; i--) {
    fill(red(colorNeon), green(colorNeon), blue(colorNeon), 20*i);
    text(txt, x, y + random(-i, i));
  }

  fill(colorNeon);
  text(txt, x, y);

  if (frameCount % 10 < 5) {
    fill(255, 100);
    text(txt, x + random(-1, 1), y + random(-1, 1));
  }
}

void dibujarIndicadorDiapositivas() {
  float anchoTotal = TOTAL_DIAPOSITIVAS * 20 + (TOTAL_DIAPOSITIVAS-1) * 10;
  float xInicio = width/2 - anchoTotal/2;

  for (int i = 0; i < TOTAL_DIAPOSITIVAS; i++) {
    if (i == currentSlide) {
      fill(AZUL_NEON);
      ellipse(xInicio + i*30, height-30, 20, 20);

      if (frameCount % 20 < 10) {
        fill(AZUL_NEON, 100);
        ellipse(xInicio + i*30, height-30, 30, 30);
      }
    } else {
      fill(100, 100);
      ellipse(xInicio + i*30, height-30, 10, 10);
    }
  }
}

void dibujarBotonCyber(String etiqueta, float x, float y, float w, float h, float tamañoTexto, boolean hover) {
  if (hover) {
    fill(0, 200);
    stroke(ROSA_CYBER);
    strokeWeight(4);
  } else {
    fill(0, 150);
    stroke(AMARILLO_CYBER);
    strokeWeight(3);
  }

  rectMode(CENTER);
  rect(x, y, w, h, 15);

  if (hover) {
    noFill();
    stroke(ROSA_CYBER, 150);
    strokeWeight(2);
    rect(x, y, w+20, h+20, 20);
  }

  if (hover) {
    fill(ROSA_CYBER);
    textSize(tamañoTexto + 2);
  } else {
    fill(AMARILLO_CYBER);
    textSize(tamañoTexto);
  }

  text(etiqueta, x, y);

  rectMode(CORNER);
}

boolean mouseSobreBoton(float x, float y, float w, float h) {
  return mouseX > x - w/2 && mouseX < x + w/2 &&
    mouseY > y - h/2 && mouseY < y + h/2;
}

void siguienteDiapositiva() {
  bgFade = 0;
  currentSlide = (currentSlide + 1) % TOTAL_DIAPOSITIVAS;
  lastTime = millis();

  slideX = random(width/4, width*3/4);
  slideY = random(height/4, height/2);
  textAlpha = 0;
  textScale = 0.6;
}

void mousePressed() {
  if (!started && mouseSobreBoton(width/2, height/2, 300, 100)) {
    started = true;
    lastTime = millis();
    bgFade = 0;
  } else if (currentSlide == TOTAL_DIAPOSITIVAS - 1 &&
    mouseSobreBoton(width/2, height-100, 300, 80)) {
    currentSlide = 0;
    lastTime = millis();
    started = false;
    bgFade = 0;
  }
}
