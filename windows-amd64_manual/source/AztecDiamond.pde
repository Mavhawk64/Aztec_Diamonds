// Color Key:

// -1 -- VOID / Gray

// 0 -- Empty / Light Gray

// 1 -- Up / Blue

// 2 -- Right / Red

// 3 -- Down / Green

// 4 -- Left / Yellow


class AztecDiamond {
  private static final int VOID = -1, EMPTY = 0, U = 1, R = 2, D = 3, L = 4;


  private int N;
  private int[][] grid;
  public AztecDiamond(int N) {
    this.N = N;
    this.grid = new int[2*N+2][2*N+2];
    this.create();
  }

  public void fillDoubles() {
    int ROW_COUNT = this.grid.length - 2;
    int COL_COUNT = this.grid[0].length - 2;
    for (int i = 1; i <= ROW_COUNT; i++) {
      for (int j = 1; j <= COL_COUNT; j++) {
        if (this.grid[i][j] == EMPTY && this.grid[i+1][j] == EMPTY && this.grid[i][j+1] == EMPTY && this.grid[i+1][j+1] == EMPTY) {
          this.fillSquare(i, j);
        }
      }
    }
  }

  public int[][] getGrid() {
    return grid;
  }

  public void move() {
    int ROW_COUNT = this.grid.length - 2;
    int COL_COUNT = this.grid[0].length - 2;
    int[][] nextGrid = (new AztecDiamond(this.N)).getGrid();
    
    // Apply UP / DOWN
      for (int i = 1; i <= ROW_COUNT; i++) {
        for (int j = 1; j <= COL_COUNT; j++) {
          int val = this.grid[i][j];
          if (val == U && nextGrid[i-1][j] == EMPTY && nextGrid[i-1][j+1] == EMPTY) {
            nextGrid[i-1][j] = U;
            nextGrid[i-1][j+1] = U;
            this.grid[i][j] = EMPTY;
            this.grid[i][j+1] = EMPTY;
            j++;
          } else if (val == D && nextGrid[i+1][j] == EMPTY && nextGrid[i+1][j+1] == EMPTY) {
            nextGrid[i+1][j] = D;
            nextGrid[i+1][j+1] = D;
            this.grid[i][j] = EMPTY;
            this.grid[i][j+1] = EMPTY;
            j++;
            i-=2;
          }
        }
      }
      // Apply LEFT / RIGHT
      for (int j = 1; j <= COL_COUNT; j++) {
        for (int i = 1; i <= ROW_COUNT; i++) {
          int val = this.grid[i][j];
          if (val == L && nextGrid[i][j-1] == EMPTY && nextGrid[i+1][j-1] == EMPTY) {
            nextGrid[i][j-1] = L;
            nextGrid[i+1][j-1] = L;
            this.grid[i][j] = EMPTY;
            this.grid[i+1][j] = EMPTY;
            i++;
          } else if (val == R && nextGrid[i][j+1] == EMPTY && nextGrid[i+1][j+1] == EMPTY) {
            nextGrid[i][j+1] = R;
            nextGrid[i+1][j+1] = R;
            this.grid[i][j] = EMPTY;
            this.grid[i+1][j] = EMPTY;
            i++;
            j-=2;
          }
        }
      }
      
      // Apply Frozen Values
      
      for(int i = 0; i < this.grid.length; i++) {
        for(int j = 0; j < this.grid[i].length; j++) {
          if(this.grid[i][j] != EMPTY)
            nextGrid[i][j] = this.grid[i][j];
        }
      }
      
      this.grid = nextGrid;
  }

  public AztecDiamond mapTo(AztecDiamond baby) {
    int[][] bg = baby.getGrid();
    for (int i = 1; i < bg.length - 1; i++) {
      for (int j = 1; j < bg[i].length - 1; j++) {
        if (bg[i][j] != VOID)
          this.grid[i+1][j+1] = bg[i][j];
      }
    }
    return this;
  }

  public void fixErrors() {
    int ROW_COUNT = this.grid.length - 2;
    int COL_COUNT = this.grid[0].length - 2;
    for(int i = 1; i <= ROW_COUNT; i++) {
      for(int j = 1; j <= COL_COUNT; j++) { 
        int val = this.grid[i][j];
        if(val == D && this.grid[i+1][j] == U || val == R && this.grid[i][j+1] == L) {
          this.drainSquare(i,j);
        }
      }
    }
  }
  
  private void drainSquare(int tlx, int tly) {
    this.grid[tlx][tly] = EMPTY;
      this.grid[tlx][tly+1] = EMPTY;
      this.grid[tlx+1][tly] = EMPTY;
      this.grid[tlx+1][tly+1] = EMPTY;
  }

  private void fillSquare(int tlx, int tly) {
    boolean isVert = random(1) < 0.5;
    if (isVert) {
      this.grid[tlx][tly] = U;
      this.grid[tlx][tly+1] = U;
      this.grid[tlx+1][tly] = D;
      this.grid[tlx+1][tly+1] = D;
    } else {
      this.grid[tlx][tly] = L;
      this.grid[tlx][tly+1] = R;
      this.grid[tlx+1][tly] = L;
      this.grid[tlx+1][tly+1] = R;
    }
  }

  public void show() {
    push();
    rectMode(CENTER);
    int ROW_COUNT = this.grid.length - 2;
    int COL_COUNT = this.grid[0].length - 2;
    float MARGIN = 0;
    float WIDTH = (width - MARGIN) / COL_COUNT - MARGIN;
    float HEIGHT = (height - MARGIN) / ROW_COUNT - MARGIN;
    for (int i = 1; i <= ROW_COUNT; i++) {
      for (int j = 1; j <= COL_COUNT; j++) {
        int column = j - 1;
        int row = i - 1;
        float x = (MARGIN + WIDTH) * column + MARGIN + floor(WIDTH / 2);
        float y = (MARGIN + HEIGHT) * row + MARGIN + floor(HEIGHT / 2);

        switch(this.grid[i][j]) {
        case EMPTY:
          fill(150);
          break;
        case U:
          fill(#00bfff);
          break;
        case R:
          fill(#d73030);
          break;
        case D:
          fill(#00ff00);
          break;
        case L:
          fill(#ffd700);
          break;
        default:
          fill(50);
          break;
        }


        if (this.grid[i][j] == -1) {
          fill(50);
        } else if (this.grid[i][j] == 0) {
          fill(150);
        }
        rect(x, y, WIDTH, HEIGHT);
      }
    }
    pop();
  }



  private void create() {
    for (int i = 0; i <= N; i++) {
      for (int j = 0; j <= N-i; j++) {
        this.grid[i][j] = VOID;
      }
      for (int j = N-i+1; j < N-i+1 + 2*i; j++) {
        this.grid[i][j] = EMPTY;
      }
      for (int j = N-i+1 + 2*i; j <= N-i+1 + 2*i + N-i; j++) {
        this.grid[i][j] = VOID;
      }
    }
    for (int i = N; i > -1; i--) {
      int x = 2*N-i+1;
      for (int j = 0; j <= N-i; j++) {
        this.grid[x][j] = VOID;
      }
      for (int j = N-i+1; j < N-i+1 + 2*i; j++) {
        this.grid[x][j] = EMPTY;
      }
      for (int j = N-i+1 + 2*i; j <= N-i+1 + 2*i + N-i; j++) {
        this.grid[x][j] = VOID;
      }
    }
  }
}
