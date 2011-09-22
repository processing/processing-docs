/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Life vs Life Arena (2003) (play http://www.lifevslife.com)
  
  Justin Bakse (justin@volanokit.com)
  http://www.volcanokit.com
   
  Hey, it is kind of messy in here. Sorry.
  
  Also depending on this and that, it might take a fairly long time to launch. (like a whole minute)
*/

/* **********************************************************************
CLASS: Life Build

********************************************************************** */

public class lifeBuild extends BApplet
{
  //----------------------------------------------------------------
  // Config Globals
  //----------------------------------------------------------------

  //board display
  short cellSize = 9;
  short cellSpace = 10;
  short colCount = 60;
  short rowCount = 30;
  boolean frameBlend = false;
  boolean allowCapture = true;
  //state
  String MODE = "play"; // battle, build, play
  String boardName ="";
  String login ="";
  String board1Name = "";
  String board2Name = "";
  boolean shouldPostWin = false;

  //----------------------------------------------------------------
  // CONTROLS / UI
  //----------------------------------------------------------------

  //Misc Assets
  BFont UIFont;

  //Buttons
  PictureButton allBackwardButton;
  PictureButton backwardButton;
  PictureButton playButton;
  PictureButton forwardButton;
  PictureButton saveBoardButton;
   PictureButton newBattleButton;
  //Images
  BImage grayTile;
  BImage darkTile;
  BImage redTile;
  BImage darkRedTile;
  BImage blueTile;
  BImage scoreBoard;
  BImage buildBoard;

  BImage [] bigNums = new BImage[10];
  BImage [] lilNums = new BImage[10];
  BImage redArrow;
  BImage blueArrow;
  BImage blueWins;
  BImage redWins;
  BImage tieGame;

  //----------------------------------------------------------------
  // MODEL VARIABLES
  //----------------------------------------------------------------

  byte[][] map = new byte[colCount][rowCount];
  byte[][] allBackwardMap = new byte[colCount][rowCount];
  byte[][] scratchMap = new byte[colCount][rowCount];
  Generation[] history = new Generation[1000];

  boolean running = false;
  boolean stasis = false;
  boolean settled = false;
  int winner = 0;

  int generationFrame = 0;
  int historyFrame = 0;
  int cellCount;
  int redCellCount;
  int blueCellCount;

  boolean firstRelease = true;

  //----------------------------------------------------------------
  // Input Output Variables
  //----------------------------------------------------------------

  boolean hasPostedWin = false;

  boolean firstLoop = true;
  /*------------------------------------------------------------------------
  Core Functions
  ------------------------------------------------------------------------*/
  void setup()
  {
    size(600, 365);
    background(32, 32, 32);

  }

  void loop()
  {
   
    if (firstLoop){
      settled = false;
      loadParams();
      firstLoop = false;
       
      loadResources();
      
      setupUI();
      
      initHistory();
     
   
      if(MODE.equals("battle"))  loadBoard1();
      if(MODE.equals("battle"))  loadBoard2();
       
      resetBattle();
      
    }
    loopBoard();
    loopUI();
  }

  void mouseReleased()
  {
    if (firstRelease){
      firstRelease = false;
      return;
    }
    if(  playButton.mouseUp()){
      running = playButton.state();
    }
    if (MODE.equals("build")){
      if (saveBoardButton.mouseUp()){
        if ((redCellCount >= 3 )&&( redCellCount <=60)&&(!running)) saveBoard();
      }
    }
    
    if (MODE.equals("battle")){
      if (newBattleButton.mouseUp()){
        if (settled == true) link("http://www.volcanokit.com/life/life3/battle.php","myPopup");
      }
    }
    

    if (allBackwardButton.mouseUp()) rewindBoard();
    if (backwardButton.mouseUp()) unstepCells();
    if (forwardButton.mouseUp()) stepCells();
    if (mouseY < rowCount * cellSpace) toggleCell();
  }

  void keyReleased()
  {
    //stepCells();
  }

  //------------------------------------------------------------------------
  //  SETUP FUNCTIONS
  //------------------------------------------------------------------------

  void loadResources()
  {
    UIFont = loadFont("Meta-Bold.vlw.gz");
    textFont(UIFont, 14);
    grayTile = loadImage("http://www.volcanokit.com/life/life3/data/grayTile.gif");
    darkTile = loadImage("http://www.volcanokit.com/life/life3/data/darkTile.gif");
    redTile = loadImage("http://www.volcanokit.com/life/life3/data/redTile.gif");
    darkRedTile = loadImage("http://www.volcanokit.com/life/life3/data/darkRedTile.gif");
    blueTile = loadImage("http://www.volcanokit.com/life/life3/data/blueTile.gif");
    scoreBoard = loadImage("http://www.volcanokit.com/life/life3/data/scoreBoard.gif");
    buildBoard = loadImage("http://www.volcanokit.com/life/life3/data/buildBoard.gif");

    bigNums[0] = loadImage("http://www.volcanokit.com/life/life3/data/bigZero.gif");
    bigNums[1] = loadImage("http://www.volcanokit.com/life/life3/data/bigOne.gif");
    bigNums[2] = loadImage("http://www.volcanokit.com/life/life3/data/bigTwo.gif");
    bigNums[3] = loadImage("http://www.volcanokit.com/life/life3/data/bigThree.gif");
    bigNums[4] = loadImage("http://www.volcanokit.com/life/life3/data/bigFour.gif");
    bigNums[5] = loadImage("http://www.volcanokit.com/life/life3/data/bigFive.gif");
    bigNums[6] = loadImage("http://www.volcanokit.com/life/life3/data/bigSix.gif");
    bigNums[7] = loadImage("http://www.volcanokit.com/life/life3/data/bigSeven.gif");
    bigNums[8] = loadImage("http://www.volcanokit.com/life/life3/data/bigEight.gif");
    bigNums[9] = loadImage("http://www.volcanokit.com/life/life3/data/bigNine.gif");

    lilNums[0] = loadImage("http://www.volcanokit.com/life/life3/data/lilZero.gif");
    lilNums[1] = loadImage("http://www.volcanokit.com/life/life3/data/lilOne.gif");
    lilNums[2] = loadImage("http://www.volcanokit.com/life/life3/data/lilTwo.gif");
    lilNums[3] = loadImage("http://www.volcanokit.com/life/life3/data/lilThree.gif");
    lilNums[4] = loadImage("http://www.volcanokit.com/life/life3/data/lilFour.gif");
    lilNums[5] = loadImage("http://www.volcanokit.com/life/life3/data/lilFive.gif");
    lilNums[6] = loadImage("http://www.volcanokit.com/life/life3/data/lilSix.gif");
    lilNums[7] = loadImage("http://www.volcanokit.com/life/life3/data/lilSeven.gif");
    lilNums[8] = loadImage("http://www.volcanokit.com/life/life3/data/lilEight.gif");
    lilNums[9] = loadImage("http://www.volcanokit.com/life/life3/data/lilNine.gif");

    redArrow = loadImage("http://www.volcanokit.com/life/life3/data/redArrow.gif");
    blueArrow = loadImage("http://www.volcanokit.com/life/life3/data/blueArrow.gif");

    redWins = loadImage("http://www.volcanokit.com/life/life3/data/redWins.gif");
    blueWins = loadImage("http://www.volcanokit.com/life/life3/data/blueWins.gif");
    tieGame = loadImage("http://www.volcanokit.com/life/life3/data/tie.gif");

  }

  //------------------------------------------------------------------------
  //UI FUNCTIONS
  //------------------------------------------------------------------------
  void setupUI()
  {
    allBackwardButton = new PictureButton(50, 340, 18, "allBackward.gif", "allBackward.gif", true);
    backwardButton = new PictureButton(75, 340, 18, "backward.gif", "backward.gif", true);
    playButton = new PictureButton(100, 340, 18, "play.gif", "pause.gif", true);
    forwardButton = new PictureButton(125, 340, 18, "forward.gif", "forward.gif", true);

    if (MODE.equals("build")){
      saveBoardButton = new PictureButton(242, 337, 80, "saveBoard.gif", "saveBoard.gif", false);
    }
    
    if (MODE.equals("battle")){
      newBattleButton = new PictureButton(242, 337, 80, "newbattle.gif", "newbattle.gif", false);
    }
    

  }

  void loopUI()
  {
    //CALC
    //CALC
    setAllBackwardButton();
    setBackwardButton();
    setForwardButton();

    setSaveBoardButton();

    checkWinner();

    //DRAW
    //DRAW
   // text("MODE: "+ MODE, 10, 10);
    //    text("Board 2 Name: "+ board2Name, 10, 40);
    //Dashboard 1
    if (MODE.equals("build")){
      image(buildBoard, 0,  305);
    }else{
      image(scoreBoard, 0,  305);
    }
    
    if (!MODE.equals("build")){
      printBigNumber(blueCellCount, 480, 312);
    }
    if (!MODE.equals("build")){
      displayWinner();
    }
    //Dashboard 2
    displayGeneration();
    allBackwardButton.display();
    backwardButton.display();
    playButton.display();
    forwardButton.display();

    if (MODE.equals("build")){
      saveBoardButton.display();
    }
    

    if (MODE.equals("battle")){
      if (settled == true)
      newBattleButton.display();
    }
    

    drawCursor();
    fill(255,255,255);

    //DEBUG
    //printDebugInfo();
  }
  void drawCursor(){

    int gridx = mouseX/cellSpace;
    int gridy = mouseY/cellSpace;
    if (MODE.equals("battle")) return;
    if (MODE.equals("build") && gridx >= colCount/2) return;
    if (mouseY > 300) return;

    noFill();
    if (gridx < colCount/2)   stroke(250,50,50);
    if (gridx >= colCount/2) stroke(50,50,250);
    rect(gridx*cellSpace , gridy*cellSpace, 10, 10);

  }
  void displayWinner(){
    if (winner == 1) image(redWins, 210,312);
    if (winner == 2) image(redWins, 210,312);
    if (winner == 3) image(tieGame, 210,312);
    if (winner == 4) image(blueWins, 210,312);
    if (winner == 5) image(blueWins, 210,312);

    if (winner == 0){
      if (generationFrame > 0){
        if (redCellCount > blueCellCount) image(redArrow, 292, 309);
        if (redCellCount < blueCellCount) image(blueArrow, 292, 309);
      }
    }
  }

  void displayGeneration()
  {
    if (stasis){
      stroke(130,130,30);
    }else{
      stroke(80,80,80);
    }
    fill(0,0,0);
    rect(8,343,30,12);
    noStroke();
    printLilNumber(generationFrame, 12, 346);
  }

  void printDebugInfo()
  {
    fill(255,255,255);
    int textY = 480;
    text("Board Name: "+ boardName, 10, textY); textY+=15;
    text("Login: "+ login, 10, textY); textY+=15;
    text("Gen: "+ generationFrame, 10, textY); textY+=15;
    text("History: "+ historyFrame, 10, textY); textY+=15;
    text("Oldest: "+ getOldest(), 10, textY); textY+=15;
    textY = 480;
    if (stasis)  text("Stasis: TRUE", 150, textY);
    if (!stasis)  text("Stasis: FALSE", 150, textY); textY+=15;
    text("Cell Count: "+cellCount, 150, textY); textY+=15;
    text("Red Count: "+redCellCount, 150, textY); textY+=15;
    text("Blue Count: "+blueCellCount, 150, textY); textY+=15;
    textY = 480;
    String statusMessage = "battling";
    if (stasis) statusMessage = "stasis";
    if (redCellCount == 0) statusMessage = "kill";
    if (blueCellCount == 0) statusMessage = "kill";
    if (redCellCount > blueCellCount) statusMessage += " red";
    if (blueCellCount > redCellCount) statusMessage += " blue";
    if (blueCellCount == redCellCount) statusMessage += " tie";
    text("Status: "+statusMessage, 310, textY);textY+=15;
  }

  //UI CALC
  void setSaveBoardButton()
  {
    if (MODE.equals("build")){
      if ((redCellCount >= 3) && (redCellCount <= 60) && (!running)){
        saveBoardButton.setActive(true);
      }else{
        saveBoardButton.setActive(false);
      }
    }
  }

  void setAllBackwardButton()
  {
    allBackwardButton.setActive(true);
    if (generationFrame == 0) allBackwardButton.setActive(false);
    if (running) allBackwardButton.setActive(true);
  }

  void setForwardButton()
  {
    forwardButton.setActive(true);
    if (running) forwardButton.setActive(false);
  }
  void setBackwardButton()
  {
    backwardButton.setActive(true);
    if (getOldest() >= generationFrame)  backwardButton.setActive(false);
    if (running) backwardButton.setActive(false);
  }

  //UI DRAW
  void printBigNumber(int value, int x, int y)
  {
    int scratch = value;
    int thousands = scratch/1000;
    scratch = scratch - thousands *1000;
    int hundreds = scratch/100;
    scratch = scratch - hundreds*100;
    int tens = scratch/10;
    scratch = scratch - tens * 10;
    int ones = scratch;

    if (thousands>0) image(bigNums[thousands], x+0, y);
    if (hundreds>0) image(bigNums[hundreds], x+15, y);
    if ((hundreds>0) || (tens>0)) image(bigNums[tens], x+30,  y);
    image(bigNums[ones], x+45,  y);
  }

  void printLilNumber(int value, int x, int y)
  {
    int scratch  = value;
    int thousands = scratch/1000;
    scratch = scratch - thousands*1000;
    int hundreds = scratch/100;
    scratch = scratch - hundreds*100;
    int tens = scratch/10;
    scratch = scratch - tens * 10;
    int ones = scratch;

    image(lilNums[thousands], x+0, y);
    image(lilNums[hundreds], x+6, y);
    image(lilNums[tens], x+12, y);
    image(lilNums[ones], x+18, y);
  }

  /*------------------------------------------------------------------------
  Board UI Funtions
  ------------------------------------------------------------------------*/
  void toggleCell()
  {
    int gridx = mouseX/cellSpace;
    int gridy = mouseY/cellSpace;

    if (MODE.equals("battle")) return;
    if ((gridx >= colCount/2) && (MODE == "build")) return;

    if (map[gridx][gridy] == 0){
      if (gridx < colCount/2){
        map[gridx][gridy] = 1;
      }else{
        map[gridx][gridy] = 2;
      }
    }else{
      map[gridx][gridy] = 0;
    }

    resetBattle();
  }

  void rewindBoard()
  {
    int row, col;
    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        map[col][row] = allBackwardMap[col][row];
      }
    }
    playButton.setState(false);
    running = false;
    resetBattle();
  }
  /*------------------------------------------------------------------------
  Data Reading Functions
  ------------------------------------------------------------------------*/

  void loadParams()
  {
    
    try{
     MODE = getParameter("MODE");
    }
    catch (Exception e){
      //let mode fall through from the decleartion intialization.
    }

   
    //MODE == BUILD
    if (MODE.equals("build")){
      try{
        boardName = getParameter("boardName");
        login = getParameter("login");
      }
      catch (Exception e){
        //let mode fall through from the decleartion intialization.
      }
    }
   
   
    //MODE == BATTLE
    if (MODE.equals("battle")){
      try{
        board1Name = getParameter("board1Name");
        board2Name = getParameter("board2Name");
        if (getParameter("shouldPostWin").equals("YES")){
          shouldPostWin = true;
        }
      }
      catch (Exception e){
        //let mode fall through from the decleartion intialization.
      }
    }
    
  }

  void loadBoard1()
  {
    int strPos;
    int col, row;
    //    String lines[] = loadStrings("http://www.volcanokit.com/life/life/getBoardResult.php?formBoardName="+board1Name+"&formSubmitted=getBoard");
    String lines[] = loadStrings("http://www.volcanokit.com/life/life3/lifeLib.php?formBoardName="+board1Name+"&formSubmitted=getBoard");

    String boardData = lines[0];

    for (strPos = 0; strPos < boardData.length(); strPos+=2){
      char sub = boardData.charAt(strPos);
      col = (int)sub-65;
      sub = boardData.charAt(strPos+1);
      row = (int)sub-65;
      map[col][row] = 1;
    }
  }

  void loadBoard2()
  {
    int strPos;
    int col, row;
    //    String lines[] = loadStrings("http://www.volcanokit.com/life/life/getBoardResult.php?formBoardName="+board2Name+"&formSubmitted=getBoard");
    String lines[] = loadStrings("http://www.volcanokit.com/life/life3/lifeLib.php?formBoardName="+board2Name+"&formSubmitted=getBoard");
    String boardData = lines[0];
     
     
    for (strPos = 0; strPos < boardData.length(); strPos+=2){
      char sub = boardData.charAt(strPos);
      col = (colCount - 1) - ((int)sub-65);
      sub = boardData.charAt(strPos+1);
      row = (int)sub-65;
      map[col][row] = 2;
    }
  }

  /*------------------------------------------------------------------------
  Data Writing Functions
  ------------------------------------------------------------------------*/
  void saveBoard()
  {

    String data = "";
    int row, col;
    for (row = 0; row < 30; row ++){
      for (col = 0; col < 30; col ++){
        if (map[col][row]>0){
          data+=(char)(col+65);
          data+=(char)(row+65);
        }
      }
    }

    String lines[] = loadStrings("http://www.volcanokit.com/life/life3/lifeLib.php?formLogin="+login+"&formBoardName="+boardName+"&formSubmitted=createBoard&formBoardData="+data);
    String boardData = lines[0];
    link("http://www.volcanokit.com/life/life3/your.php","myPopup");

  }

  void postResult()
  {
    if (!shouldPostWin) return;
    if (hasPostedWin) return;

    String lines[] = loadStrings("http://www.volcanokit.com/life/life3/lifeLib.php?formBoard1Name="+board1Name+"&formBoard2Name="+board2Name+"&formResultCode="+winner+"&formSubmitted=createBattle");


    hasPostedWin = true;
  }

  /*------------------------------------------------------------------------
  Officiation Model Functions
  ------------------------------------------------------------------------*/

  void initHistory()
  {
    for (int g = 0; g < history.length; g++){
      history[g] = new Generation();
    }
  }

  void checkWinner()
  {
    if (settled) return;
    if (redCellCount == 0) winner = 5;
    if (blueCellCount == 0) winner = 1;
    if (blueCellCount == 0 && redCellCount == 0) winner = 3;
    if (stasis){
      if (redCellCount < blueCellCount) {
        winner = 4;
      }
      if (redCellCount > blueCellCount) {
        winner = 2;
      }
      if (redCellCount == blueCellCount) winner = 3;
    }
    if (!(stasis || redCellCount == 0 || blueCellCount == 0)) winner = 0; //protection
    if (generationFrame == 0 && !stasis) winner = 0; //no wins on first frame

    if (winner != 0) {
      settled = true;
      postResult();
    }

  }

  boolean isMatch(int testGen)
  {
    int row, col;
    if (cellCount != history[testGen].cellCount) return false;
    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        if (map[col][row] != history[testGen].map[col][row]) return false;
      }
    }
    return true;
  }

  void updateHistory()
  {
    int cellCount = 0;
    short row;
    short col;

    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        history[historyFrame].map[col][row] = map[col][row];
        if (map[col][row] > 0) cellCount++;
      }
    }

    history[historyFrame].generationFrame = generationFrame;
    history[historyFrame].cellCount = cellCount;

    historyFrame++; if (historyFrame == history.length) historyFrame = 0;
    generationFrame++;

  }

  void resetBattle()
  {

    generationFrame = 0;
    historyFrame = 0;
  
    stasis = false;
    if (MODE.equals("build")) zeroRight();
    countCells();
    int row, col;
    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        allBackwardMap[col][row] = map[col][row];
      }
    }

  }
  void zeroRight()
  {
    int row, col;
    for(row = 0; row < rowCount; row++){
      for(col = colCount/2; col < colCount; col++){
        map[col][row] = 0;
      }
    }
  }
  /*------------------------------------------------------------------------
  Board Model Functions
  ------------------------------------------------------------------------*/
  void loopBoard()
  {
    if (running) stepCells();
    drawCells();
  }

  void stepCells()
  {
    updateHistory();
    calcScratch(); scratchMap2Map();
    countCells();
    checkStasis();
  }

  void unstepCells(){
    if (getOldest() >= generationFrame) return;
    if (historyFrame == 0) historyFrame = history.length;
    historyFrame--;
    generationFrame--;

    short row;
    short col;

    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        map[col][row] = history[historyFrame].map[col][row];
      }
    }
    countCells();
  }

  void countCells()
  {
    int row;
    int col;
    cellCount = 0; redCellCount = 0; blueCellCount = 0;
    if (MODE.equals("build")){
      for(row = 0; row < rowCount; row++){
        for(col = 0; col < colCount/2; col++){
        if (map[col][row] == 1) {cellCount++; redCellCount++;}
        if (map[col][row] == 2) {cellCount++; blueCellCount++;}
        }
      }
    }else{
      for(row = 0; row < rowCount; row++){
        for(col = 0; col < colCount; col++){
        if (map[col][row] == 1) {cellCount++; redCellCount++;}
        if (map[col][row] == 2) {cellCount++; blueCellCount++;}
        }
      }
    }
  }

  int getOldest(){
    int testGen;
    int oldest = 1666;
    for (testGen = 0; testGen < history.length; testGen++){
      if (history[testGen].generationFrame < oldest) oldest = history[testGen].generationFrame;
    }
    return oldest;
  }

  void checkStasis()
  {
    int testGen;
    boolean match = false;
    int backin = 0;

    if (generationFrame >= history.length){
      for (testGen = historyFrame; testGen < history.length; testGen++){
        if (isMatch(testGen) == true){
          backin = testGen;
          match = true;
          stasis = true;
          testGen = 10000000;
        }
      }
    }

    if (!match){
      backin = -historyFrame;
      for (testGen = 0; testGen < historyFrame; testGen++){
        if (isMatch(testGen) == true){
          backin = testGen;
          match = true;
          stasis = true;
          testGen = 10000000;
        }
      }
    }

    if (match){
      //generationFrame = generationFrame + backin;
      historyFrame =  backin;
      generationFrame = history[historyFrame].generationFrame;
    }

  }

  void drawCells()
  {
    short row;
    short col;

    background(32,32,32);
    fill(255,0,0);
    noStroke();

    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        if (map[col][row] == 0){
          if (frameBlend) {
            tint(255,255,255,45);
          }else{
            noTint();
          }
          if ((col >= 30) && (MODE.equals( "build"))){
            image(darkTile, col*cellSpace,  row*cellSpace);
          }else{
            image(grayTile, col*cellSpace,  row*cellSpace);
          }
        }
        if (map[col][row] == 1){
          noTint();

          if ((col >= 30) && (MODE.equals( "build"))){
            image(darkRedTile, col*cellSpace,  row*cellSpace);
          }else{
            image(redTile, col*cellSpace,  row*cellSpace);
          }

        }
        if (map[col][row] == 2){
          noTint();
          image(blueTile, col*cellSpace,  row*cellSpace);
        }
      }
    }

  }

  void calcScratch()
  {
    short row;
    short col;

    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        int reds = countReds(col,row);
        int blues = countBlues(col,row);
        int count = reds+blues;

        //apply rules
        if (count < 2){
          scratchMap[col][row] = 0;
        }
        if (count == 2){
          scratchMap[col][row] = map[col][row];
        }
        if (count == 3){
          if(allowCapture){
            if (reds>blues) {
              scratchMap[col][row] = 1;
            }else{
              scratchMap[col][row] = 2;
            }
          }else{
            scratchMap[col][row] = map[col][row];
          }
        }

        if (count > 3){
          scratchMap[col][row] = 0;
        }
      }
    }
  }

  int countReds(int col, int row)
  {
    int neigborCount = 0;
    int nCol;
    int nRow;

    nCol = fixCol(col-1);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col-1);
    nRow = fixRow(row);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col-1);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 1 ) neigborCount++;

    return neigborCount;

  }

  int countBlues(int col, int row)
  {
    int neigborCount = 0;
    int nCol;
    int nRow;

    nCol = fixCol(col-1);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row-1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col-1);
    nRow = fixRow(row);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col-1);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    nCol = fixCol(col+1);
    nRow = fixRow(row+1);
    if ( map[nCol][nRow] == 2 ) neigborCount++;

    return neigborCount;

  }

  int fixRow(int nRow)
  {
    if (nRow < 0) nRow = rowCount-1;
    if (nRow > rowCount-1) nRow = 0;
    return nRow;
  }

  int fixCol(int nCol)
  {
    if (nCol < 0) nCol = colCount-1;
    if (nCol > colCount-1) nCol = 0;
    return nCol;
  }

  void map2ScratchMap()
  {
    short row;
    short col;
    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        scratchMap[col][row] = map[col][row];
      }
    }
  }

  void scratchMap2Map()
  {
    short row;
    short col;
    for(row = 0; row < rowCount; row++){
      for(col = 0; col < colCount; col++){
        map[col][row] = scratchMap[col][row];
      }
    }
  }

  /* **********************************************************************
  CLASS: Button

  ********************************************************************** */
  class Button
  {
    int x, y;
    int diam;
    boolean state = false;
    boolean toggle = false;
    boolean active = true;
    void update()
    {
    }

    boolean mouseUp()
    {
      if(over()) {
        handlePress();
        return true;
      }else{
        return false;
      }
    }

    boolean over()
    {
      return true;
    }

    void handlePress()
    {

    }
    boolean state()
    {
      return state;
    }
    void setActive(boolean _active){
      active = _active;
    }
    void setState(boolean _state)
    {
      state = _state;
    }
    boolean getState()
    {
      return state;
    }

  }
  /* **********************************************************************
  CLASS: Rect Button

  ********************************************************************** */
  class RectButton extends Button
  {
    RectButton(int _x, int _y, int _size, boolean _toggle)
    {
      x = _x;
      y = _y;
      diam = _size;
      toggle = _toggle;
    }

    boolean over()
    {
      if( overRect(x, y, diam, diam) ) {
        return true;
      } else {
        return false;
      }
    }

    void display()
    {
      stroke(255);
      if (state){
        fill(255, 255, 255);
      }else{
        fill(0, 0, 0);
      }
      rect(x, y, diam, diam);
    }

    void handlePress()
    {
      if (toggle){
        state = !state; //toggle
      }
    }
  }

  class PictureButton extends Button
  {

    BImage baseImage;
    BImage altImage;

    PictureButton(int _x, int _y, int _size, String image1, String image2, boolean _toggle)

    {
      x = _x;
      y = _y;
      diam = _size;
      toggle = _toggle;
      baseImage = loadImage("http://www.volcanokit.com/life/life3/data/"+image1);
      altImage = loadImage("http://www.volcanokit.com/life/life3/data/"+image2);
      active = true;
    }
    void display()
    {
      if (!active){
        tint(255,255,255,65);
      }else{
        noTint();
      }
      if (state){
        image(altImage, x, y);
      }else{
        image(baseImage, x, y);
      }
      noTint();

    }
    void handlePress()
    {
      if (toggle){
        state = !state; //toggle
      }
    }
    boolean over()
    {

      if( overRect(x, y, diam, diam) ) {
        return true;
      } else {
        return false;
      }
    }

  }

  /* **********************************************************************
  Button Utility Functions

  ********************************************************************** */
  boolean overRect(int x, int y, int width, int height)
  {
    if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  /* **********************************************************************
  Generation Class

  ********************************************************************** */
  class Generation
  {
    int generationFrame = 1666;
    int cellCount = 0;

    byte[][] map = new byte[60][30];

    Generation()
    {

    }

  }

}
