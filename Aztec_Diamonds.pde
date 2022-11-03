AztecDiamond a;
int N = 1;
int clicks = 0;
int STEPS = 4;
void setup() {
  size(600, 600);
  a = new AztecDiamond(N);
}

void draw() {
  noStroke();
  background(50);
  a.show();
  //saveFrame("frames/####.png");
  //noLoop();
  //if(frameCount % ((int)(frameRate) * 1) == 0)
    //mouseClicked();
}

void mouseClicked() {
  if (clicks % STEPS == 0) {
    a.fillDoubles();
  } else if (clicks % STEPS == 1) {
    AztecDiamond b = new AztecDiamond(++N);
    a = b.mapTo(a);
  } else if (clicks % STEPS == 2) {
    a.fixErrors();
  } else {
    a.move();
  }
  clicks++;
  clicks %= STEPS;
}
