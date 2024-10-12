class StatBar {
  private int mines;
  private int flags = 0;
  
  public StatBar (int mines) {
    this.mines = mines;
  }
  
  // every time a tile is flagged or unflagged
  // update mines and flags
  public void flag(boolean undo){
    if(!undo){
      flags++;
      mines--;
    } else {
      flags--;
      mines++;
    }
  }
  
  // dont mind all of the spaces 
  // im lazy
  public void show() {
    fill(0);
    textSize(40);
    textAlign(CENTER);
    text(mines + " Mines                      " + flags + " Flags", 300, 665);
  }
}
