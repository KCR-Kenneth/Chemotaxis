Ghost [] boo = new Ghost [10];
Man pac = new Man (370,30);
Wall [] nope = new Wall [0];
Powerup [] balls = new Powerup [0];
int tic = 1;
boolean wallMode = false;
boolean powered = false;
int poweredTimer;

int round = 1;
boolean lost = false;

void setup() {
  size(720,720);
  background(30);
  frameRate(10);
  for (int i = 0; i < boo.length; i++) {
    int c = color ((int)(Math.random() * 256), (int)(Math.random() * 256), (int)(Math.random() * 256));
    boo[i] = new Ghost (370,600,c);
  }
}

void draw() {
  decorate();
  for (int i = 0; i < nope.length; i++) {
    nope[i].show();
  }
  for (int i = 0; i < balls.length; i++) {
    balls[i].show();
  }
  tic++;
  if (tic > 3) {
    tic = 1;
    for (int i = 0; i < boo.length; i++) {
      boo[i].direction = boo[i].redirect();
      int retries = 0;
      while(boo[i].direction == -1 && retries < 10) {
        boo[i].direction = boo[i].redirect();
        retries++;
      }
    }
    pac.redirect();
    for (int i = 0; i < balls.length; i++) {
      if (pac.myX == balls[i].myX && pac.myY == balls[i].myY) {
        powered = true;
        poweredTimer = 90;
        Powerup [] temp = balls;
        balls = new Powerup [balls.length-1];
        for (int j = 0; j < balls.length; j++) {
          if (j == i) {
            j++;
          }
          balls[j] = temp[j];
        }
      }
    }
  }
  /*
    if (powered) {
      int dupes = 0;
      for (int i = 0; i < boo.length; i++) {
        if (pac.myX == boo[i].myX && pac.myY == boo[i].myY) {
          dupes++;
        }
      }
      Ghost [] temp = boo;
      boo = new Ghost [boo.length-dupes];
      if (dupes == 0) {
        boo = temp;
      } else {
        int shift = 0;
        for (int i = 0; i < boo.length; i++) {
          if (pac.myX == temp[i].myX && pac.myY == temp[i].myY) {
            i++;
            shift++;
          } else {
            boo[i-shift] = temp[i];
          }
        }
      }
      */
      if (powered) {
        for (int i = 0; i < boo.length; i++) {
          if (boo[i].myX > pac.myX - 11 && boo[i].myX < pac.myX + 11 && boo[i].myY > pac.myY - 11 && boo[i].myY < pac.myY + 11) {
            Ghost [] temp = boo;
            boo = new Ghost [boo.length-1];
            for (int j = 0; j < i; j++) {
              boo[j] = temp[j];
            }
            for (int k = i+1; k < temp.length; k++) {
              boo[k-1] = temp[k];
            }
            i = boo.length;
          }
        }
      } else {
        for (int i = 0; i < boo.length; i++) {
          if (boo[i].myX > pac.myX - 11 && boo[i].myX < pac.myX + 11 && boo[i].myY > pac.myY - 11 && boo[i].myY < pac.myY + 11) {
            pac = new Man (370,330);
            boo = new Ghost [0];
            lost = true;
          }
        }
      }
  
  if (poweredTimer > 0) {
    poweredTimer-=1;
    if (poweredTimer == 0) {
      powered = false;
    }
  }
  
  for (int i = 0; i < boo.length; i++) {
    boo[i].move();
    boo[i].show();
  }
  pac.move();
  pac.show();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      pac.request = 0;
    } else if (keyCode == DOWN) {
      pac.request = 1;
    } else if (keyCode == LEFT) {
      pac.request = 2;
    } else if (keyCode == UP) {
      pac.request = 3;
    }
  }
}

void mouseDragged() {
  if (mouseY < 631 && wallMode) {
    Wall [] temp = new Wall[nope.length+1];
    for (int i = 0; i < nope.length; i++) {
      temp[i] = nope[i];
    }
    nope = new Wall[nope.length + 1];
    for (int i = 0; i < temp.length; i++) {
      nope[i] = temp[i];
    }
    nope[nope.length-1] = new Wall ((int)(mouseX/30)*30, (int)(mouseY/30)*30);
  }
}

void mousePressed() {
  System.out.println(mouseX + ", " + mouseY);
  if (mouseY < 630 && !wallMode) {
    if (!checkDupe()){
      Powerup [] temp = new Powerup[balls.length+1];
      for (int i = 0; i < balls.length; i++) {
        temp[i] = balls[i];
      }
      balls = new Powerup[balls.length + 1];
      for (int i = 0; i < balls.length; i++) {
        balls[i] = temp[i];
      }
      balls[balls.length-1] = new Powerup ((int)(mouseX/30)*30, (int)(mouseY/30)*30+30);
    }
  } else {
    if (mouseX > 85 && mouseX < 235) {
      wallMode = true;
    } else if (mouseX > 285 && mouseX < 435) {
      wallMode = false;
    } else if (mouseX > 485 && mouseX < 635 && boo.length == 0) {
      round++;
      boo = new Ghost [10*round];
      for (int i = 0; i < boo.length; i++) {
        int c = color ((int)(Math.random() * 256), (int)(Math.random() * 256), (int)(Math.random() * 256));
        boo[i] = new Ghost (370,600,c);
      }
      pac = new Man (370,30);
      nope = new Wall [0];
      balls = new Powerup [0];
      tic = 1;
      wallMode = true;
      powered = false;
      poweredTimer = 0;
    }
  }
}

class Ghost {
  int myX, myY, mySpd;
  int myC;
  // Direction Key: 0 = Right, 1 = Down, 2 = Left, 3 = Up
  int direction;
  // orientation of sprite!
  boolean faceLeft;
  boolean freeze;
  
  Ghost(int x, int y, int c) {
    myX = x;
    myY = y;
    myC = c;
    mySpd = 10;
  }
  
  int redirect () {
    // Create bias in the randomness of direction
    double xBias;
    double yBias;
    if (pac.myX - myX > 0) {
      xBias = 0.4;
    } else if (pac.myX - myX < 0) {
      xBias = -0.4;
    } else {
      xBias = 0;
    }
    if (pac.myY - myY > 0) {
      yBias = 0.4;
    } else if (pac.myY - myY < 0) {
      yBias = -0.4;
    } else {
      yBias = 0;
    }
    
    if (powered) {
      xBias*=-1;
      yBias*=-1;
    }
    
    //if (get(myX+30,myY) != color(0,0,255))
    //if (get(myX,myY-30) != color(0,0,255))
    double random = Math.random();
    if (random < 0.5) {
      if (random < (0.5 + xBias)) {
        if (get(myX+20,myY) != color(0,0,255)){
          return 0;
        }
      } else {
        if (get(myX-20,myY) != color(0,0,255)){
          return 2;
        }
      }
    } else {
      if (random < (0.5 + yBias)) {
        if (get(myX,myY+20) != color(0,0,255)){
          return 1;
        }
      } else {
        if (get(myX,myY-20) != color(0,0,255)){
          return 3;
        }
      }
    }
    return -1;
  }
  // NOTE: There is no randomness in the move() itself, as I want to
  // move in a "set" direction for a given amount of time before being
  // redirected (look at above function)
  void move() {
    if (direction == 0) {
      myX+=mySpd;
      faceLeft = false;
    } else if (direction == 1) {
      myY+=mySpd;
    } else if (direction == 2) {
      myX-=mySpd;
      faceLeft = true;
    } else if (direction == 3) {
        myY-=mySpd;
    }
  }
  
  void show () {
    int scale = 1;
    noStroke();
    fill(myC);
    if (powered) {
      fill(0,0,254);
    }
    arc (myX, myY, 30*scale, 30*scale, PI, 2*PI);
    rectMode(CENTER);
    rect (myX, myY+5*scale, 30*scale, 10*scale);
    for(int i = 0; i <= 20; i+=10) {
      triangle(myX+(-15+i)*scale, myY+10*scale, myX+(-10+i)*scale, myY+18*scale, myX+(-5+i)*scale, myY+10*scale);
    }
    fill(255);
    ellipse(myX-5*scale, myY-5*scale, 5*scale,5*scale);
    ellipse(myX+5*scale, myY-5*scale, 5*scale,5*scale);
    fill(0,0,255);
    int inverter;
    if (faceLeft) {
      inverter = 1;
    } else {
      inverter = -1;
    }
    ellipse(myX-6*scale*inverter, myY-5*scale, 3*scale,3*scale);
    ellipse(myX+4*scale*inverter, myY-5*scale, 3*scale,3*scale);
  }
}

class Man {
  int myX, myY, myC, mySpd, direction, face, request;
  boolean powered;
  
  Man (int x, int y) {
    myX = x;
    myY = y;
    myC = color (255,255,0);
    mySpd = 10;
  }
  
  void redirect() {
    direction = request;
  }
  
  void move() {
    if (direction == 0) {
      if (get(myX+20,myY) != color(0,0,255)) {
        myX+=mySpd;
      }
    } else if (direction == 1) {
      if (get(myX,myY+20) != color(0,0,255)) {
        myY+=mySpd;
      }
    } else if (direction == 2) {
      if (get(myX-20,myY) != color(0,0,255)){
        myX-=mySpd;
      }
    } else if (direction == 3) {
      if (get(myX,myY-20) != color(0,0,255)) {  
        myY-=mySpd;
      }
    }
  }
  
  void show() {
    fill(255,255,0);
    noStroke();
    pushMatrix();
      translate(myX,myY);
      rotate(direction*PI/2);
      arc (0,0,30,30,PI/4,7*PI/4);
    popMatrix();
  }
}

class Wall {
  int myX,myY;
  Wall (int x, int y) {
    myX = x;
    myY = y;
  }
  
  void show() {
    noStroke();
    fill(0,0,255);
    rect(myX, myY, 30, 30);
  }
}

class Powerup {
  int myX, myY;
  Powerup(int x, int y) {
    myX = x;
    myY = y;
  }
  
  void show() {
    fill(255,255,200);
    ellipse(myX, myY, 20, 20);
  }
}

boolean checkDupe() {
  for (int i = 0; i < balls.length; i++) {
    for (int j = -30; j <=30; j+=30){
      for (int k = -30; k <=30; k+=30) {
        if (balls[i].myX == (int)(mouseX/30)*30 + k && balls[i].myY == (int)(mouseY/30)*30+30 + j) {
          return true;
        }
      }
    }
  }
  return false;
}

void decorate() {
  background(30);
  fill (0,0,255);
  stroke(0);
  rectMode(CORNER);
  noStroke();
  rect (-15,0,30,720);
  rect (0,-15,720,30);
  rect (705,0,30,720);
  rect (0,615,720,105);
  
  //Buttons
  rectMode(CENTER);
  fill(255);
  rect(160,680,150,50);
  rect(360,680,150,50);
  rect(560,680,150,50);
  
  textAlign(CENTER);
  fill(150,150,0);
  textSize(30);
  text("Walls", 160, 690);
  text("Powerups", 360, 690);
  text("NEXT", 560, 690);
  
  if (lost) {
    textSize(60);
    fill(255,0,0);
    text("YOU LOSE!", 360,360);
    textSize(30);
    text("<Refresh to Try Again>", 360,400);
  }
}
