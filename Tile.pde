class Tile {
  private PVector position;
  private int size = 60;
  private int colour;
  private int minesNear;
  private boolean mine, opened, flagged;
  private String number;
  private PImage flag, mineImg;

  // 'opens' the tile when you clicked on it
  public void open() {
    if (!opened && !flagged) {
      opened = true;
      if (minesNear > 0) {
        colour = (int)map(minesNear, 0, 8, 80, 255);
      }
    }
  }

  // when the user right clicks, 'flag' that tile
  public void flag() {
    if (!opened) {
      if (flagged) {
        flagged = false;
      } else {
        flagged = true;
      }
    }
  }

  // check if the user 'opend' a mine
  public boolean dead() {
    if (mine && opened) {
      return true;
    }
    return false;
  }

  // display each tile
  public void show() {
    strokeWeight(1);
    rectMode(CORNER);
    if (opened) {
      fill(160);
      square(position.x, position.y, size);
      if (mine) {
        image(mineImg, position.x, position.y, size, size);
      } else {
        textAlign(CENTER);
        textSize(40);
        fill(colour, 0, 0);
        text(number, position.x + size / 2, position.y + size / 1.4);
      }
    } else if (flagged) {
      fill(255);
      square(position.x, position.y, size);
      image(flag, position.x, position.y, size, size);
    } else {
      fill(255);
      square(position.x, position.y, size);
    }
  }

  // CONSTRUCTOR

  public Tile (int x, int y) {
    position = new PVector((x * size) - 1, y * size);
    flag = loadImage("resources/flag.png");
    mineImg = loadImage("resources/mine.png");
  }

  // GETTERS AND SETTER BELOW

  public void makeMine() {
    this.mine = true;
  }

  public PVector getPosition() {
    return position;
  }

  public boolean getMine() {
    return mine;
  }

  public void setMinesNear(int mines) {
    minesNear = mines;
    if (minesNear > 0) {
      number = String.valueOf(minesNear);
    } else {
      number = " ";
    }

  }

  public boolean getOpen() {
    return opened;
  }
  
  public boolean getFlagged() {
    return flagged;
  }

  public int getMinesNear() {
    return minesNear;
  }
}
