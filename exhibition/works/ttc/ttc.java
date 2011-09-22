// THE TEXT TIME CURVATURE
// a chronotext device

// by Ariel Malka, june 2004
// made for "the processing exhibition"

// made with eclipse & a mutant version of bagel circa 056
// bagel is also known as "the processing engine"

// more context: www.chronotext.org & www.processing.org


import java.util.Stack;
import java.util.Vector;
import java.io.*;
import java.util.zip.*;
import java.awt.event.*;
import java.net.*;

public class Online_4 extends BApplet
{
  public void setup()
  {
    size(400, 400);
    background(0);
    hint(SMOOTH_IMAGES);

    // ---

    ui_init();
  }

  // ---

  public void mousePressed()
  {
    if (tree_RECORDED != null)
    {
      tree_RECORDED.stream.mouseIn();
    }
  }

  public void mouseReleased()
  {
    if (tree_RECORDED != null)
    {
      tree_RECORDED.stream.mouseIn();
    }
  }

  public void mouseMoved()
  {
    if (tree_RECORDED != null)
    {
      tree_RECORDED.stream.mouseIn();
    }
  }

  public void mouseDragged()
  {
    if (tree_RECORDED != null)
    {
      tree_RECORDED.stream.mouseIn();
    }
  }

  public void keyPressed(KeyEvent e)
  {
    // doing this stuff manually, cause can't rely on the way p5 is handling "coded" keys...
    keyPressed = true;
    key = e.getKeyChar();

    if (tree_RECORDED != null)
    {
      tree_RECORDED.stream.keyIn((char) key, e.getKeyCode());
    }
  }

  // ---

  public void loop()
  {
    ScreenManager.run();
  }

  // ------------------------------------------------------

  // UI

  int ui_y = 378;
  int ui_h = 22;

  XFont xfont;
  static final float[] widths_MyriadBold_64 = { 12.93f, 17.15f, 25.41f, 35.2f, 35.52f, 56.32f, 43.39f, 13.12f, 20.1f, 20.1f, 29.06f, 38.14f, 16.64f, 20.61f, 16.64f, 21.18f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 35.52f, 16.64f, 16.64f, 38.14f, 38.14f, 38.14f, 28.48f, 49.28f, 41.98f, 38.66f, 38.08f, 44.54f, 34.18f, 33.73f, 43.65f, 44.1f, 18.24f, 26.3f, 39.3f, 32.7f, 54.14f, 44.16f, 45.89f, 37.18f, 45.89f, 37.95f, 34.56f, 35.07f, 43.65f, 40.7f, 56.83f, 39.23f, 38.59f, 36.93f, 20.1f, 21.89f, 20.1f, 38.14f, 32.0f, 19.2f, 33.79f, 38.27f, 28.86f, 38.14f, 33.79f, 21.82f, 37.44f, 37.5f, 17.54f, 18.62f, 34.69f, 17.54f, 55.04f, 37.5f, 36.93f, 38.27f, 38.08f, 24.32f, 27.78f, 23.49f, 37.31f, 33.92f, 48.58f, 33.22f, 33.47f, 30.02f, 20.1f, 18.11f, 20.1f, 38.14f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 12.93f, 17.15f, 35.52f, 35.52f, 35.52f, 35.52f, 18.11f, 35.9f, 19.2f, 43.33f, 24.19f, 29.76f, 38.14f, 20.61f, 32.64f, 19.2f, 22.78f, 38.14f, 24.06f, 23.87f, 19.2f, 37.31f, 34.69f, 16.64f, 19.2f, 23.49f, 24.7f, 29.76f, 53.18f, 53.18f, 53.18f, 28.48f, 41.98f, 41.98f, 41.98f, 41.98f, 41.98f, 41.98f, 55.55f, 38.21f, 34.18f, 34.18f, 34.18f, 34.18f, 18.24f, 18.24f, 18.24f, 18.24f, 45.06f, 44.16f, 45.89f, 45.89f, 45.89f, 45.89f, 45.89f, 38.14f, 45.89f, 43.65f, 43.65f, 43.65f, 43.65f, 38.59f, 37.12f, 38.4f, 33.79f, 33.79f, 33.79f, 33.79f, 33.79f, 33.79f, 51.39f, 28.86f, 33.79f, 33.79f, 33.79f, 33.79f, 17.54f, 17.54f, 17.54f, 17.54f, 36.74f, 37.5f, 36.93f, 36.93f, 36.93f, 36.93f, 36.93f, 38.14f, 36.93f, 37.31f, 37.31f, 37.31f, 37.31f, 33.47f, 38.27f, 33.47f };

  PFont pfont;
  static final int[] widths_Tahoma_10 = { 3, 2, 4, 7, 6, 10, 7, 2, 4, 4, 6, 7, 3, 4, 3, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 7, 7, 7, 5, 9, 7, 6, 7, 7, 6, 6, 7, 7, 4, 4, 6, 5, 8, 7, 8, 6, 8, 6, 6, 6, 7, 6, 10, 6, 6, 6, 4, 4, 4, 7, 5, 5, 5, 6, 5, 6, 5, 3, 6, 6, 2, 3, 6, 2, 8, 6, 6, 6, 6, 4, 4, 3, 6, 6, 8, 5, 6, 4, 5, 4, 5, 7, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 3, 2, 5, 6, 6, 5, 4, 5, 5, 9, 5, 6, 7, 4, 9, 5, 5, 7, 5, 5, 5, 6, 5, 4, 5, 5, 5, 6, 10, 10, 10, 5, 7, 7, 7, 7, 7, 7, 9, 7, 6, 6, 6, 6, 4, 4, 4, 4, 7, 7, 8, 8, 8, 8, 8, 7, 8, 7, 7, 7, 7, 6, 6, 5, 5, 5, 5, 5, 5, 5, 9, 5, 5, 5, 5, 5, 2, 2, 2, 2, 5, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6 };

  Style defaultStyle;

  Screen_MAIN screen_MAIN;
  Screen_ABOUT screen_ABOUT;
  Screen_LIVE screen_LIVE;
  Screen_PLAYBACK screen_PLAYBACK;

  Tree tree_RECORDED;
  Tree tree_LOADED;

  Stream stream_LOADED;
  Stream stream_RECORDED;

  void ui_init()
  {
    xfont = new XFont("/MyriadBold_64_western.jpg", 64, 70, 76, widths_MyriadBold_64);
    pfont = new PFont("/Tahoma_10_western.gif", 12, 12, widths_Tahoma_10);

    defaultStyle = new Style();
    StyleShortcut.get(defaultStyle, 0xcccccc, 0x000000, 0xffff99, 0x606060);

    // ---

    screen_MAIN = new Screen_MAIN();
    screen_ABOUT = new Screen_ABOUT();
    screen_PLAYBACK = new Screen_PLAYBACK();
    screen_LIVE = new Screen_LIVE();

    ui_SHARED_init(); // should be the first, since the "shared nature"
    ui_MAIN_init();
    ui_ABOUT_init();
    ui_PLAYBACK_init();
    ui_LIVE_init();

    ScreenManager.setScreen(screen_MAIN);

    String name = null;
    String url = getParameter("url");
    String file = getParameter("file");
    if (url != null)
    {
      name = "//scgi-bin/redirect.pl?" + URLEncoder.encode(url);
    }
    else if (file != null)
    {
      name = "/" + file;
    }

    if (name != null)
    {
      stream_LOADED = new Stream(Stream.TYPE_READONLY);
      boolean success = stream_LOADED.load(name);
      if (success)
      {
        tree_LOADED = new Tree(stream_LOADED, xfont, 20, pfont);
        setTreeParams(tree_LOADED);

        screen_PLAYBACK.setCurrentTree(tree_LOADED);
        ScreenManager.setScreen(screen_PLAYBACK);
      }
      else
      {
        System.err.println("INVALID FILE-NAME OR URL!");
      }
    }
  }

  // ------------------------------------------------------

  // MAIN UI

  static final String credits = "the text time curvature\nariel malka | june 2004 | chronotext.org\nmade for processing.org/exhibition";

  int main_button_x = 283;
  int main_button_w = 101;

  TextButton button_play_loaded;
  TextButton button_record_new, button_play_recorded;
  TextButton button_about;

  void ui_MAIN_init()
  {
    button_play_loaded = new TextButton(main_button_w, 16, pfont, defaultStyle);
    button_play_loaded.setLocation(main_button_x, 58);
    button_play_loaded.setText("REPLAY MESSAGE");

    button_record_new = new TextButton(main_button_w, 16, pfont, defaultStyle);
    button_record_new.setLocation(main_button_x, 180);
    button_record_new.setText("RECORD NEW");

    button_play_recorded = new TextButton(main_button_w, 16, pfont, defaultStyle);
    button_play_recorded.setLocation(main_button_x, 205);
    button_play_recorded.setText("REPLAY IT");

    button_about = new TextButton(main_button_w, 16, pfont, defaultStyle);
    button_about.setLocation(main_button_x, 326);
    button_about.setText("ABOUT + HELP");

    // since these buttons are only used in this screen it's okay to do this stuff here and once (i.e. no need to removeListener() later on...)
    button_play_loaded.addListener(screen_MAIN);
    button_record_new.addListener(screen_MAIN);
    button_play_recorded.addListener(screen_MAIN);
    button_about.addListener(screen_MAIN);
  }

  // ------------------------------------------------------

  // "ABOUT" UI

  int back_x;

  void ui_ABOUT_init()
  {
    back_x = button_up.x - 3 - pfont.getStringWidth("back");
  }

  // ------------------------------------------------------

  // SHARED UI

  int views_x, views_w;
  TextButton button_view_1, button_view_2, button_view_3;

  ImageButton button_up;
  int options_x;

  void ui_SHARED_init()
  {
    views_w = pfont.getStringWidth("views");
    views_x = 3;

    button_view_1 = new TextButton(16, 16, pfont, defaultStyle);
    button_view_1.setLocation(views_x + views_w + 3, ui_y + 3);
    button_view_1.setText("1");

    button_view_2 = new TextButton(16, 16, pfont, defaultStyle);
    button_view_2.setLocation(button_view_1.x + 16 + 1, ui_y + 3);
    button_view_2.setText("2");

    button_view_3 = new TextButton(16, 16, pfont, defaultStyle);
    button_view_3.setLocation(button_view_2.x + 16 + 1, ui_y + 3);
    button_view_3.setText("3");

    button_up = new ImageButton(16, 16, loadImage("/up.gif"), defaultStyle);
    button_up.setLocation(width - 3 - 16, ui_y + 3);

    options_x = button_up.x - 3 - pfont.getStringWidth("options");
  }

  void ui_SHARED_enter(Screen screen, Tree tree)
  {
    button_view_1.addListener(screen);
    button_view_1.reset();
    button_view_1.setLocked(true);

    button_view_2.addListener(screen);
    button_view_2.reset();

    button_view_3.addListener(screen);
    button_view_3.reset();

    setTreeView_1(tree);

    button_up.addListener(screen);
    button_up.reset();
  }

  void ui_SHARED_exit(Screen screen)
  {
    button_view_2.removeListener(screen);
    button_view_2.removeListener(screen);
    button_view_2.removeListener(screen);
    button_up.removeListener(screen);
  }

  void ui_SHARED_run(Tree tree)
  {
    rectMode(CORNER);
    fill(0);
    noStroke();
    rect(0, ui_y, width, ui_h);

    fill(255);
    pfont.drawString("views", views_x, ui_y + 3 + 2);
    button_view_1.run();
    button_view_2.run();
    button_view_3.run();

    button_up.run();
    fill(button_up.color_body);
    pfont.drawString("options", options_x, ui_y + 3 + 2);
  }

  void event_SHARED(Tree tree, Object source, int message)
  {
    event_views(tree, source, message);
  }

  public void event_views(Tree tree, Object source, int message)
  {
    if (source == button_view_1)
    {
      button_view_1.setLocked(true);
      button_view_2.setLocked(false);
      button_view_3.setLocked(false);
      setTreeView_1(tree);
    }
    if (source == button_view_2)
    {
      button_view_2.setLocked(true);
      button_view_1.setLocked(false);
      button_view_3.setLocked(false);
      setTreeView_2(tree);
    }
    if (source == button_view_3)
    {
      button_view_3.setLocked(true);
      button_view_1.setLocked(false);
      button_view_2.setLocked(false);
      setTreeView_3(tree);
    }
  }

  void setTreeView_1(Tree tree)
  {
    tree.cam_fov = 60;
    tree.cam_twist = radians(0);
    tree.cam_elevation = radians(330);
    tree.cam_azimuth = radians(0);
    tree.cam_x = 0;
    tree.cam_y = 0;
    tree.cam_distance = 275;
  }

  void setTreeView_2(Tree tree)
  {
    tree.cam_fov = 60;
    tree.cam_twist = radians(0);
    tree.cam_elevation = radians(-60);
    tree.cam_azimuth = radians(23);
    tree.cam_x = 50;
    tree.cam_y = 10;
    tree.cam_distance = 158;
  }

  void setTreeView_3(Tree tree)
  {
    tree.cam_fov = 60;
    tree.cam_twist = radians(0);
    tree.cam_elevation = radians(0);
    tree.cam_azimuth = radians(0);
    tree.cam_x = 0;
    tree.cam_y = 0;
    tree.cam_distance = 500;
  }

  void setTreeParams(Tree tree)
  {
    tree.curvature_maxAngle = radians(9); // (radians) per font-size (distance)
    tree.curvature_timeThreshold = 1000; // millis, after this period: curvature is null
    tree.curvature_interpFactor = 0.1f; // between 0 & 1, the lower it is the more time it takes for curvature to change
    tree.vanishDistance = 2000; // beyond this distance, no text is shown (strongly related to font-size)
    tree.slope = radians(-5);
  }

  // ------------------------------------------------------

  // PLAYBACK UI

  int playback_x = 131;
  int clock_w = 48, cross_w = 4;
  int clock_playback_x, cross_x;
  ImageButton button_play, button_rewind, button_pause;
  BImage cross;
  TextButton button_speed_1, button_speed_4, button_speed_16;

  void ui_PLAYBACK_init()
  {
    button_rewind = new ImageButton(16, 16, loadImage("/rewind.gif"), defaultStyle);
    button_rewind.setLocation(playback_x, ui_y + 3);

    button_play = new ImageButton(16, 16, loadImage("/play.gif"), defaultStyle);
    button_play.setLocation(button_rewind.x + 16 + 1, ui_y + 3);

    button_pause = new ImageButton(16, 16, loadImage("/pause.gif"), defaultStyle);
    button_pause.setLocation(button_play.x + 16 + 1, ui_y + 3);

    clock_playback_x = button_pause.x + 16 + 3;

    cross = loadImage("/cross.gif");
    cross_x = clock_playback_x + clock_w + 6;

    button_speed_1 = new TextButton(16, 16, pfont, defaultStyle);
    button_speed_1.setLocation(cross_x + cross_w + 3, ui_y + 3);
    button_speed_1.setText("1");

    button_speed_4 = new TextButton(16, 16, pfont, defaultStyle);
    button_speed_4.setLocation(button_speed_1.x + 16 + 1, ui_y + 3);
    button_speed_4.setText("4");

    button_speed_16 = new TextButton(16, 16, pfont, defaultStyle);
    button_speed_16.setLocation(button_speed_4.x + 16 + 1, ui_y + 3);
    button_speed_16.setText("16");
  }

  void ui_PLAYBACK_enter(Screen screen, Tree tree)
  {
    tree.addListener(screen);

    button_rewind.addListener(screen);
    button_rewind.reset();
    button_rewind.setEnabled(false);

    button_play.addListener(screen);
    button_play.reset();

    button_pause.addListener(screen);
    button_pause.reset();
    button_pause.setEnabled(false);

    button_speed_1.addListener(screen);
    button_speed_1.reset();
    button_speed_1.setLocked(true);
    setClockRate(tree.stream.clock, 1); // default speed

    button_speed_4.addListener(screen);
    button_speed_4.reset();

    button_speed_16.addListener(screen);
    button_speed_16.reset();
  }

  void ui_PLAYBACK_exit(Screen screen, Tree tree)
  {
    tree.removeListener(screen);

    button_rewind.removeListener(screen);
    button_play.removeListener(screen);
    button_pause.removeListener(screen);
    button_speed_1.removeListener(screen);
    button_speed_4.removeListener(screen);
    button_speed_16.removeListener(screen);
  }

  void ui_PLAYBACK_run(Tree tree)
  {
    button_rewind.run();
    button_play.run();
    button_pause.run();

    drawClock(tree.stream.getCurrentMediaTime(), clock_playback_x, ui_y + 3, clock_w, 16);

    image(cross, cross_x, ui_y + 3 + 6);
    button_speed_1.run();
    button_speed_4.run();
    button_speed_16.run();
  }

  void event_PLAYBACK(Tree tree, Object source, int message)
  {
    event_media(tree, source, message);
    event_deck(tree, source, message);
    event_speed(tree, source, message);
  }

  void event_media(Tree tree, Object source, int message)
  {
    if (source == tree && message == Tree.EVENT_ENDOFMEDIA)
    {
      button_pause.setEnabled(false);
      button_play.setLocked(false);
    }
  }

  void event_deck(Tree tree, Object source, int message)
  {
    if (source == button_rewind)
    {
      tree.stop();
      tree.start(Stream.MODE_PLAYBACK);

      tree.stream.clock.stop();
      button_pause.setEnabled(false);
      button_pause.setLocked(false);
      button_play.setEnabled(true);
      button_play.setLocked(false);
      button_rewind.setEnabled(false);
    }
    else if (source == button_play)
    {
      if (!tree.started)
      {
        tree.start(Stream.MODE_PLAYBACK);
      }
      else
      {
        tree.stream.clock.start();
      }
      button_play.setLocked(true);
      button_pause.setEnabled(true);
      button_pause.setLocked(false);
      button_rewind.setEnabled(true);
    }
    else if (source == button_pause)
    {
      if (tree.stream.clock.getState() == Clock.STARTED)
      {
        tree.stream.clock.stop();
        button_pause.setLocked(true);
        button_play.setLocked(false);
      }
    }
  }

  void event_speed(Tree tree, Object source, int message)
  {
    if (source == button_speed_1)
    {
      setClockRate(tree.stream.clock, 1);
      button_speed_1.setLocked(true);
      button_speed_4.setLocked(false);
      button_speed_16.setLocked(false);
    }
    else if (source == button_speed_4)
    {
      setClockRate(tree.stream.clock, 4);
      button_speed_1.setLocked(false);
      button_speed_4.setLocked(true);
      button_speed_16.setLocked(false);
    }
    else if (source == button_speed_16)
    {
      setClockRate(tree.stream.clock, 16);
      button_speed_1.setLocked(false);
      button_speed_4.setLocked(false);
      button_speed_16.setLocked(true);
    }
  }

  void setClockRate(Clock clock, float rate)
  {
    if (clock.getState() == Clock.STOPPED)
    {
      clock.setRate(rate);
    }
    else
    {
      clock.stop();
      clock.setRate(rate);
      clock.start();
    }
  }

  // ---

  void drawClock(int t, int x, int y, int w, int h)
  {
    t /= 1000;
    int hours = t / 3600;
    int minutes = (t / 60) - (hours * 60);
    int seconds = t - (hours * 3600) - (minutes * 60);
    String s = new String((hours < 10 ? "0" : "") + hours + ":" + (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds);

    rectMode(CORNER);
    fill(51);
    noStroke();
    rect(x, y, w, h);

    fill(255);
    pfont.drawString(s, x + (w - pfont.getStringWidth(s)) / 2, y + (h - pfont.getHeight()) / 2);
  }

  // ---

  // LIVE UI

  int live_x = 171;
  int clock_live_x;
  ImageButton button_record, button_stop;

  void ui_LIVE_init()
  {
    button_record = new ImageButton(16, 16, loadImage("/record.gif"), defaultStyle);
    button_record.setLocation(live_x, ui_y + 3);

    button_stop = new ImageButton(16, 16, loadImage("/stop.gif"), defaultStyle);
    button_stop.setLocation(button_record.x + 16 + 1, ui_y + 3);

    clock_live_x = button_stop.x + 16 + 3;
  }

  void ui_LIVE_run(Tree tree)
  {
    button_record.run();
    button_stop.run();

    drawClock(tree.stream.getCurrentMediaTime(), clock_live_x, ui_y + 3, clock_w, 16);
  }

  // ------------------------------------------------------

  public class Screen_MAIN extends Screen
  {
    public void enter()
    {
      button_play_loaded.reset();
      button_record_new.reset();
      button_play_recorded.reset();
      button_about.reset();

      if (stream_LOADED == null || !stream_LOADED.loaded)
      {
        button_play_loaded.setEnabled(false);
      }

      if (stream_RECORDED == null || !stream_RECORDED.recorded)
      {
        button_play_recorded.setEnabled(false);
      }
    }

    public void exit()
    {
    }

    public void run()
    {
      stroke(0x50);
      line(267, 0, 267, 399);
      line(267, 134, 399, 134);
      line(267, 267, 399, 267);

      fill(255);
      pfont.drawString(credits, 16, 348);

      button_play_loaded.run();
      button_record_new.run();
      button_play_recorded.run();
      button_about.run();
    }

    public void event(Object source, int message)
    {
      if (source == button_play_loaded)
      {
        screen_PLAYBACK.setCurrentTree(tree_LOADED);
        ScreenManager.setScreen(screen_PLAYBACK);
        return;
      }

      if (source == button_record_new)
      {
        stream_RECORDED = new Stream(Stream.TYPE_RECORDABLE);
        tree_RECORDED = new Tree(stream_RECORDED, xfont, 20, pfont);
        setTreeParams(tree_RECORDED);

        screen_LIVE.setCurrentTree(tree_RECORDED);
        ScreenManager.setScreen(screen_LIVE);
        return;
      }

      if (source == button_play_recorded)
      {
        screen_PLAYBACK.setCurrentTree(tree_RECORDED);
        ScreenManager.setScreen(screen_PLAYBACK);
        return;
      }

      if (source == button_about)
      {
        ScreenManager.setScreen(screen_ABOUT);
      }
    }
  }

  // ------------------------------------------------------

  static final String about = "ABOUT\n\na very experimental text recorder (the first in a long series of chronotext devices?)\n\nparticularities:\n- tree structure.\n- curvature of the medium affected by type rate.\n\nutility: close to null *\n\n(*) except in the context of epistemology, surrealism and/or poetry...\n\n\nHELP\n\nwhen recording:\n\n- use the \"enter\" key to create a new branch.\n\n- use the left/right arrow keys to navigate between branches.\n\n- alternatively, use the history bar at the bottom to switch between the last edited\nbranches.\n\n- intentionally, it is not possible to pause while recording (i.e. capturing the whole\nprocess is the key...)\n\n- the \"offline\" version, available at chronotext.org/devices/ttc must be used in\norder to save records.";

  public class Screen_ABOUT extends Screen
  {
    public void enter()
    {
      button_up.addListener(this);
      button_up.reset();
    }

    public void exit()
    {
      button_up.removeListener(this);
    }

    public void run()
    {
      fill(255);
      pfont.drawString(about, 16, 16);

      button_up.run();
      fill(button_up.color_body);
      pfont.drawString("back", back_x, ui_y + 3 + 2);
    }

    public void event(Object source, int message)
    {
      if (source == button_up)
      {
        ScreenManager.setScreen(screen_MAIN);
      }
    }
  }

  // ------------------------------------------------------

  public class Screen_PLAYBACK extends Screen
  {
    Tree currentTree;

    public void setCurrentTree(Tree tree)
    {
      currentTree = tree;
    }

    public void enter()
    {
      ui_SHARED_enter(this, currentTree);
      ui_PLAYBACK_enter(this, currentTree);

      // starting to play automatically...
      currentTree.start(Stream.MODE_PLAYBACK);
      button_play.setLocked(true);
      button_pause.setEnabled(true);
      button_pause.setLocked(false);
      button_rewind.setEnabled(true);
    }

    public void exit()
    {
      ui_SHARED_exit(this);
      ui_PLAYBACK_exit(this, currentTree);
    }

    public void run()
    {
      currentTree.run();
      ui_SHARED_run(currentTree);
      ui_PLAYBACK_run(currentTree);
    }

    public void event(Object source, int message)
    {
      event_SHARED(currentTree, source, message);
      event_PLAYBACK(currentTree, source, message);

      if (source == button_up)
      {
        currentTree.stop();
        ScreenManager.setScreen(screen_MAIN);
      }
    }
  }

  // ------------------------------------------------------

  public class Screen_LIVE extends Screen
  {
    Tree currentTree;

    public void setCurrentTree(Tree tree)
    {
      currentTree = tree;
    }

    public void enter()
    {
      ui_SHARED_enter(this, currentTree);

      button_record.addListener(this);
      button_record.reset();

      button_stop.addListener(this);
      button_stop.reset();
      button_stop.setEnabled(false);

      // starting to record automaticaly...
      button_record.setLocked(true);
      button_stop.setEnabled(true);
      currentTree.start(Stream.MODE_LIVE);
    }

    public void exit()
    {
      ui_SHARED_exit(this);

      button_record.removeListener(this);
      button_stop.removeListener(this);
    }

    public void run()
    {
      currentTree.run();
      ui_SHARED_run(currentTree);
      ui_LIVE_run(currentTree);
    }

    public void event(Object source, int message)
    {
      event_SHARED(currentTree, source, message);

      if (source == button_record)
      {
        button_record.setLocked(true);
        button_stop.setEnabled(true);
        currentTree.start(Stream.MODE_LIVE);
        return;
      }

      if (source == button_stop)
      {
        currentTree.stop();
        button_record.setEnabled(false);
        button_stop.setEnabled(false);
        return;
      }

      if (source == button_up)
      {
        currentTree.stop();
        ScreenManager.setScreen(screen_MAIN);
      }
    }
  }

  // ------------------------------------------------------

  // inspired by SUN's Java Media Framework

  public class Clock
  {
    public static final int STOPPED = 0;
    public static final int STARTED = 2;

    private int mst;
    private float rate;
    private int state;
    private long tbst;

    public Clock()
    {
      mst = 0;
      rate = 1;
      state = STOPPED;
    }

    public void start()
    {
      if (state != STOPPED)
      {
        System.err.println("MEDIA CLOCK: CLOCK ALREADY STARTED");
        return;
      }

      tbst = System.currentTimeMillis();
      state = STARTED;
    }

    public void stop()
    {
      if (state != STOPPED)
      {
        mst = getMediaTime();
        state = STOPPED;
      }
    }

    public int getMediaTime()
    {
      return mst + (int) ((state == STOPPED) ? 0 : (System.currentTimeMillis() - tbst) * rate);
    }

    public void setMediaTime(int now)
    {
      if (state != STOPPED)
      {
        System.err.println("MEDIA CLOCK: CLOCK ALREADY STARTED");
        return;
      }

      mst = now;
    }

    public int getState()
    {
      return state;
    }

    public void setRate(float factor)
    {
      if (state != STOPPED)
      {
        System.err.println("MEDIA CLOCK: CLOCK ALREADY STARTED");
        return;
      }

      rate = factor;
    }
  }

  // ------------------------------------------------------

  public class Tree extends EventCaster
  {
    public final static int EVENT_ENDOFMEDIA = 0;

    private XFont font;
    private float fontSize;
    private PFont pfont;

    public float cam_fov, aspect;
    public float cam_elevation, cam_azimuth, cam_twist;
    public float cam_x, cam_y, cam_distance;

    public float curvature_maxAngle;
    public int curvature_timeThreshold;
    public float curvature_interpFactor;
    public float vanishDistance;
    public float slope;

    public Branch rootBranch, currentBranch;
    public Stack branches;
    public NavHistory navHistory;
    public EditHistory editHistory;
    Navigator navigator;

    Stream stream;
    boolean started;

    public Tree(Stream stream, XFont font, float fontSize, PFont pfont)
    {
      super();

      this.stream = stream;
      stream.setTree(this);

      this.font = font;
      this.fontSize = fontSize;
      this.pfont = pfont;

      branches = new Stack();
      navHistory = new NavHistory();
      editHistory = new EditHistory();
      navigator = new Navigator(this, 360, pfont);
    }

    public void start(int mode)
    {
      if (started)
      {
        return;
      }

      stream.start(mode, System.currentTimeMillis()); // can fail (silently for now...)
      started = true;

      if (rootBranch == null)
      {
        rootBranch = new Branch(this, null, 0, font, fontSize);
        rootBranch.id = 0;
        branches.push(rootBranch);
      }
      currentBranch = rootBranch;
      rootBranch.isRoot = true;
      rootBranch.start(0); // branch's beginning is relative to the tree

      navHistory.reset();
      navHistory.add(currentBranch);
      editHistory.reset();
      navigator.reset();
    }

    public void stop()
    {
      if (started)
      {
        stream.stop();
        started = false;
        rootBranch.stop();
      }
    }

    public void endOfMedia()
    {
      stop();

      castEvent(EVENT_ENDOFMEDIA);
    }

    public int branchAdded(Branch branch)
    {
      if (branches.contains(branch))
      {
        return branch.id;
      }
      else
      {
        branches.push(branch);
        return branches.size() - 1;
      }
    }

    public void branchStopped(Branch branch)
    {
      navHistory.remove(branch);
      editHistory.remove(branch);
    }

    public void branchEdited(Branch branch)
    {
      editHistory.update(branch);
    }

    public boolean switchBranch(Branch to)
    {
      if (!to.started || to == currentBranch)
      {
        return false;
      }

      if (!currentBranch.isEmpty())
      {
        to.setPrevious(currentBranch);
      }
      else
      {
        currentBranch.stop(); // cancelling branches that are empty when they're switched-from...
      }

      currentBranch = to;
      navHistory.add(to);
      //System.out.println("JUMP TO BRANCH: " + to.id);
      return true;
    }

    public void run()
    {
      stream.run();
      draw();
      navigator.run(); // should always occur after stream.run() for correct synchronization
    }

    public void draw()
    {
      if (currentBranch == null)
      {
        return;
      }

      beginCamera();
      perspective(cam_fov, width / (float) height, 1, 1000);
      endCamera();

      translate(cam_x, cam_y, -cam_distance);
      rotateZ(cam_twist);
      rotateX(-cam_elevation);
      rotateZ(-cam_azimuth);

      currentBranch.drawFrom(stream.getCurrentMediaTime());

      resetMatrix(); // so forthcoming 2d stuff is draw correctly
    }
  }

  // ------------------------------------------------------

  public class Stream
  {
    public final static int MODE_LIVE = 0;
    public final static int MODE_PLAYBACK = 1;

    public static final int EVENT_TEXT = 0;
    public static final int EVENT_NAV = 1;

    public static final int TYPE_RECORDABLE = 0;
    public static final int TYPE_READONLY = 1;

    public static final String FORMAT_STRING = "CHRONOTEXT_TTC";

    // an interleaved stream used as a "physical" (mouse & keyboard) input buffer in LIVE mode
    private IntBuffer in_track_time;
    private IntBuffer in_track_event;
    private CharBuffer in_track_text;
    private IntBuffer in_track_nav;
    private int in_size;

    // an interleaved stream used as a data-source both for LIVE (writing to it) & PLAYBACK (reading from it) modes
    private IntBuffer ext_track_time;
    private IntBuffer ext_track_event;
    private CharBuffer ext_track_text;
    private IntBuffer ext_track_nav;
    private int ext_size;

    // used for playback
    private int ext_pos;
    private int currentMediaTime;
    private int previousPlaybackTime;

    private boolean recorded;
    private boolean loaded;
    public int mode;
    public int type;

    private boolean started;
    private int duration;
    public Clock clock;
    private long creationTime;

    private Tree tree;

    public Stream(int type)
    {
      this.type = type;

      in_track_time = new IntBuffer();
      in_track_event = new IntBuffer();
      in_track_text = new CharBuffer();
      in_track_nav = new IntBuffer();
      in_size = 0;

      ext_track_time = new IntBuffer();
      ext_track_event = new IntBuffer();
      ext_track_text = new CharBuffer();
      ext_track_nav = new IntBuffer();
      ext_size = 0;

      clock = new Clock();
    }

    public void setTree(Tree tree)
    {
      this.tree = tree;
    }

    public void start(int mode, long t)
    {
      if (started)
      {
        return;
      }

      if (mode == MODE_LIVE)
      {
        if (recorded || type != TYPE_RECORDABLE)
        {
          System.err.println("STREAM HAS BEEN ALREADY RECORDED OR IS READ-ONLY!");
          return;
        }
      }
      else
      {
        if (!recorded && type == TYPE_RECORDABLE)
        {
          System.err.println("STREAM MUST BE RECORDED FIRST!");
          return;
        }
        else if (type == TYPE_READONLY && !loaded)
        {
          System.err.println("STREAM IS EMPTY!");
          return;
        }
      }

      this.mode = mode;
      creationTime = t;

      clock.setMediaTime(0);
      clock.start();
      started = true;

      if (mode == MODE_PLAYBACK)
      {
        ext_pos = 0;
        previousPlaybackTime = 0;
      }
    }

    public void stop()
    {
      if (started)
      {
        if (mode == MODE_LIVE)
        {
          InFlush();

          duration = getDuration();
          recorded = true;
        }
        started = false;
        clock.stop();
      }
    }

    public int getDuration()
    {
      if (mode == MODE_LIVE && !recorded)
      {
        return clock.getMediaTime();
      }
      else
      {
        return duration;
      }
    }

    public long getCreationDate()
    {
      return creationTime;
    }

    public void run()
    {
      if (!started)
      {
        return;
      }

      currentMediaTime = clock.getMediaTime();

      if (mode == MODE_LIVE)
      {
        InFlush();
      }
      else
      {
        setPlaybackMediaTime(currentMediaTime);
      }
    }

    public int getCurrentMediaTime()
    {
      return currentMediaTime;
    }

    public void setPlaybackMediaTime(int targetTime)
    {
      if (!started)
      {
        return;
      }
      if (targetTime >= getDuration())
      {
        tree.endOfMedia();
        return;
      }
      if (targetTime < previousPlaybackTime)
      {
        System.err.println("BUG: CAN'T PLAY BACKWARDS!");
        System.err.println("ext_pos: " + ext_pos);
        System.err.println("targetTime: " + targetTime);
        System.err.println("previousPlaybackTime: " + previousPlaybackTime);

        tree.endOfMedia();
        return;
      }

      int t;
      while (ext_pos < ext_size && (t = ext_track_time.data[ext_pos]) <= targetTime)
      {
        if (ext_track_event.data[ext_pos] == EVENT_TEXT)
        {
          textEvent(ext_track_text.data[ext_pos], t);
        }
        else
        {
          navEvent(ext_track_nav.data[ext_pos], t);
        }
        ext_pos++;
      }

      previousPlaybackTime = targetTime;
    }

    public void keyIn(char keyChar, int keyCode)
    {
      if (started && mode == MODE_LIVE)
      {
        if (key == 0xffff)
        {
          tree.navigator.codeIn(keyCode, clock.getMediaTime());
        }
        else
        {
          textIn(keyChar, clock.getMediaTime());
        }
      }
    }

    public void mouseIn()
    {
      if (started && mode == MODE_LIVE)
      {
        tree.navigator.mouseIn(clock.getMediaTime());
      }
    }

    public synchronized void textIn(char c, int t)
    {
      if ((c >= ' ' && c <= 255) || c == 8 || c == '\n')
      {
        in_track_time.add(t);
        in_track_event.add(EVENT_TEXT);
        in_track_text.add(c);
        in_track_nav.add(0); // dummy
        in_size++;

        // recording could also take place within InFlush()
        if (type == TYPE_RECORDABLE)
        {
          ext_track_time.add(t);
          ext_track_event.add(EVENT_TEXT);
          ext_track_text.add(c);
          ext_track_nav.add(0); // dummy
          ext_size++;
        }
      }
    }

    public synchronized void navIn(int id, int t)
    {
      in_track_time.add(t);
      in_track_event.add(EVENT_NAV);
      in_track_nav.add(id);
      in_track_text.add('\0'); // dummy
      in_size++;

      // recording could also take place within InFlush()
      if (type == TYPE_RECORDABLE)
      {
        ext_track_time.add(t);
        ext_track_event.add(EVENT_NAV);
        ext_track_nav.add(id);
        ext_track_text.add('\0'); // dummy
        ext_size++;
      }
    }

    private synchronized void InFlush()
    {
      // the advantage of recording from here would be of recording only the successfully-processed events

      if (in_size > 0)
      {
        int t;
        for (int i = 0; i < in_size; i++)
        {
          t = in_track_time.data[i];
          if (in_track_event.data[i] == EVENT_TEXT)
          {
            textEvent(in_track_text.data[i], t);
          }
          else
          {
            navEvent(in_track_nav.data[i], t);
          }
        }

        in_track_time.setSize(0);
        in_track_event.setSize(0);
        in_track_text.setSize(0);
        in_track_nav.setSize(0);
        in_size = 0;
      }
    }

    //	returns false is the event was not processed
    private boolean textEvent(char c, int t)
    {
      Branch current = tree.currentBranch;
      if (c == 8)
      {
        return current.delete();
      }
      else if (c == '\n')
      {
        Branch branch = current.addBranch();
        if (branch != null)
        {
          branch.start(t);
          //System.out.println("NEW BRANCH: " + branch.id);
          return tree.switchBranch(branch);
        }
        else
        {
          //System.out.println("CAN'T CREATE BRANCH!");
          return false;
        }
      }
      else
      {
        return current.add(c, t - current.beginning);
      }
    }

    // returns false is the event was not processed
    private boolean navEvent(int id, int t)
    {
      return tree.switchBranch((Branch) tree.branches.elementAt(id));
    }

    // --- FILE IO ---
    
		/*
		FORMAT:
      
		HEADER:
		UTF String:	format-string
		long:				record creation date (in millis)
		int:				duration (in millis)
		int:				number of events (track length)
      
		TRACK:
		for each event:
			int:		time
			byte:		event-type
			char:		text-data
			short:	nav-data
		*/

    public boolean load(String filename) // TODO: proper stream closing on all types of exit
    {
      if (type != TYPE_READONLY || loaded)
      {
        System.err.println("STREAM EITHER READ-ONLY OR ALREADY LOADED!");
        return false;
      }

      try
      {
        InputStream is = getClass().getResourceAsStream(filename);
        GZIPInputStream gzis = new GZIPInputStream(is);
        DataInputStream dis = new DataInputStream(gzis);

        try
        {
          for (int i = 0; i < FORMAT_STRING.length(); i++)
          {
            if (dis.readChar() != FORMAT_STRING.charAt(i))
            {
              throw new Exception();
            }
          }
        }
        catch (Exception e)
        {
          System.err.println("BAD STREAM FORMAT!");
          return false;
        }

        creationTime = dis.readLong();
        duration = dis.readInt();
        ext_size = dis.readInt();

        for (int i = 0; i < ext_size; i++)
        {
          ext_track_time.add(dis.readInt());
          ext_track_event.add(dis.readByte());
          ext_track_text.add(dis.readChar());
          ext_track_nav.add(dis.readShort());
        }

        dis.close();
      }
      catch (Exception e)
      {
        System.err.println("CAN'T READ STREAM!");
        return false;
      }

      loaded = true;
      return true;
    }
  }

  // ------------------------------------------------------

  // lots of hardcoded values (no time to make it really adaptive...)

  public class Navigator
  {
    private Tree tree;
    private int y;
    private PFont font;

    private final int slot_n = 3;
    private final int[][] slot_x = { { 3 }, {
        3, 203 }, {
        3, 136, 269 }
    };
    private final int[][] slot_sep_x = { {
      }, {
        200 }, {
        134, 267 }
    };
    private final int[] slot_w = { 394, 194, 128 };
    private final int slot_h = 18;
    private Branch[] slot_branches;
    private int slot_active_n;
    private int over;
    private boolean armed;

    public Navigator(Tree tree, int y, PFont font)
    {
      this.tree = tree;
      this.y = y;
      this.font = font;

      slot_branches = new Branch[slot_n];
      reset();
    }

    public void reset()
    {
      slot_active_n = 0;
      over = -1;
      armed = false;
    }

    public void mouseIn(int t)
    {
      armed = (over == -1 && mousePressed);
      over = -1;

      int x, w;
      for (int i = 0; i < slot_active_n; i++)
      {
        x = slot_x[slot_active_n - 1][i];
        w = slot_w[slot_active_n - 1];
        if (mouseX >= x && mouseX < (x + w) && mouseY >= y && mouseY < (y + slot_h))
        {
          if (!armed)
          {
            over = i;
          }
          break;
        }
      }

      if (over != -1 && mousePressed)
      {
        tree.stream.navIn(slot_branches[over].id, t);
      }
    }

    public void codeIn(int code, int t)
    {
      Branch branch;

      switch (code)
      {
        case LEFT :
          branch = tree.navHistory.back();
          if (branch != null)
          {
            tree.stream.navIn(branch.id, t);
          }
          break;

        case RIGHT :
          branch = tree.navHistory.forward();
          if (branch != null)
          {
            tree.stream.navIn(branch.id, t);
          }
      }
    }

    public void run()
    {
      Branch branch;
      int n = 0;
      for (int i = tree.editHistory.list.size() - 1; i > -1; i--)
      {
        branch = (Branch) tree.editHistory.list.elementAt(i);
        if (!branch.isEmpty() && branch != tree.currentBranch)
        {
          slot_branches[n++] = branch;
          if (n == slot_n)
          {
            break;
          }
        }
      }
      slot_active_n = n;

      draw();
    }

    public void draw()
    {
      noStroke();
      rectMode(CORNER);

      fill(0xff505050);
      rect(0, y, width, slot_h);

      for (int i = 0; i < slot_active_n; i++)
      {
        fill(over == i ? 0xffffff99 : 0xffcccccc);
        drawEllipseBox(slot_branches[i].stream_char.data, slot_branches[i].size, slot_x[slot_active_n - 1][i], y, slot_w[slot_active_n - 1], slot_h);
      }

      if (slot_active_n > 0)
      {
        fill(0);
        for (int i = 0; i < slot_sep_x[slot_active_n - 1].length; i++)
        {
          rect(slot_sep_x[slot_active_n - 1][i], y, 1, slot_h);
        }
      }
    }

    private StringBuffer ellipseBuffer = new StringBuffer(64);
    private static final String ellipse = "...";

    private void drawEllipseBox(char[] chars, int i, int x, int y, int w, int h)
    {
      if (i == 0)
      {
        return;
      }

      char c;
      int sw = 0, cw;
      int w3 = font.getStringWidth(ellipse);
      ellipseBuffer.setLength(0);

      do
      {
        c = chars[--i];
        cw = font.getCharWidth(c);
        sw += cw;
        if (sw > w - w3)
        {
          sw -= cw;
          sw += w3;
          ellipseBuffer.append(ellipse);
          break;
        }
        ellipseBuffer.append(c);
      }
      while (i > 0);
      ellipseBuffer.reverse();

      font.drawString(ellipseBuffer, x + (w - sw) / 2, y + (h - font.getHeight()) / 2);
    }
  }

  // ------------------------------------------------------

  // note: the list management for the 2 following classes could have been more effective...

  public class NavHistory
  {
    public Stack list;

    public NavHistory()
    {
      list = new Stack();
    }

    public void reset()
    {
      list.setSize(0);
    }

    public void add(Branch branch)
    {
      remove(branch);
      list.push(branch);
    }

    public void remove(Branch branch)
    {
      list.removeElement(branch);
    }

    public Branch back()
    {
      if (list.size() > 1)
      {
        Branch last = (Branch) list.pop();
        list.insertElementAt(last, 0);
        return (Branch) list.pop();
      }
      else
      {
        return null;
      }
    }

    public Branch forward()
    {
      if (list.size() > 1)
      {
        return (Branch) list.elementAt(0);
      }
      else
      {
        return null;
      }
    }
  }

  // ---

  public class EditHistory
  {
    public Stack list;
    private Branch last;

    public EditHistory()
    {
      list = new Stack();
    }

    public void reset()
    {
      last = null;
      list.setSize(0);
    }

    public void update(Branch branch) // called each time a character is added to a branch
    {
      if (branch != last)
      {
        setLast(branch);
      }
    }

    public void remove(Branch branch)
    {
      list.removeElement(branch);
    }

    public void setLast(Branch branch)
    {
      remove(branch);
      list.push(branch);
      last = branch;
    }
  }

  // ------------------------------------------------------

  public class Branch
  {
    public CharBuffer stream_char;
    public IntBuffer stream_time;
    public int size;

    private XFont font;
    private float fontSize;

    public boolean started;
    private int beginning; // relative to tree's beginning

    private FloatBuffer curvature; // used for temporary calculations

    private Stack childBranches;
    private IntBuffer childIndexes; // holds either 0 or the index (-1) of a branch in childBranches
    private int childCount;

    private Branch parent, previous;
    private Tree tree;
    public int id; // index in tree's global branch list
    public boolean isRoot;
    private int position; // relative to parent's text

    private boolean cursor_visible = true;
    private int cursor_period = 500; // millis

    private float childGap;

    public Branch(Tree tree, Branch parent, int position, XFont font, float fontSize)
    {
      this.tree = tree;
      this.parent = parent;
      this.position = position;

      this.font = font;
      this.fontSize = fontSize;
      childGap = 0.5f * fontSize;

      stream_char = new CharBuffer();
      stream_time = new IntBuffer();

      curvature = new FloatBuffer();

      childBranches = new Stack();
      childIndexes = new IntBuffer();
      childCount = 0;
    }

    public void start(int t)
    {
      beginning = t;
      started = true;
      previous = null;
      size = 0;
    }

    public void stop()
    {
      stream_char.setSize(0);
      stream_time.setSize(0);
      started = false;

      Branch child;
      for (int i = childBranches.size() - 1; i >= 0; i--)
      {
        child = (Branch) childBranches.elementAt(i);
        if (child.started)
        {
          child.stop();
        }
      }
      tree.branchStopped(this);
      //System.out.println("DELETED BRANCH: " + id);
    }

    public Branch addBranch()
    {
      return size == 0 ? null : addBranchAt(size - 1);
    }

    public Branch addBranchAt(int pos)
    {
      Branch branch = getChildAt(pos);
      if (branch != null)
      {
        if (!branch.started)
        {
          tree.branchAdded(branch);
          return branch;
        }
        else
        {
          return null;
        }
      }
      else
      {
        branch = new Branch(tree, this, pos, font, fontSize);
        childBranches.push(branch);
        childCount++;
        childIndexes.set(pos, childCount);

        branch.id = tree.branchAdded(branch);
        return branch;
      }
    }

    public boolean add(char c, int t)
    {
      stream_char.add(c);
      stream_time.add(t);
      size++;

      tree.branchEdited(this);
      return true;
    }

    public boolean delete()
    {
      if (size > 0)
      {
        Branch child = getChildAt(size - 1);
        if (child != null && child.started)
        {
          // if the current position is a "node": no character is deleted, instead, a navigation operation occurs...
          boolean switched = tree.switchBranch(child);
          if (switched)
          {
            return true;
          }
          // navigation couldn't take place (e.g. the target branch is not active anymore): continue & do delete...
        }

        size--;
        stream_char.setSize(size);
        stream_time.setSize(size);

        tree.branchEdited(this);
        return true;
      }
      else if (isRoot)
      {
        return false;
      }
      else
      {
        // the beginning of a branch has been reached...
        stop();

        boolean switched = tree.switchBranch(previous);
        if (!switched)
        {
          tree.switchBranch(parent); // TODO: follow this part to see if it's a real solution or only some patchy workaround...
        }
        return true;
      }
    }

    public Branch getChildAt(int pos)
    {
      if (childIndexes.size > pos)
      {
        int index = childIndexes.data[pos];
        if (index != 0)
        {
          return (Branch) childBranches.elementAt(index - 1);
        }
      }
      return null;
    }

    public void setPrevious(Branch branch)
    {
      if (branch.started)
      {
        previous = branch;
      }
    }

    public boolean isEmpty()
    {
      return size == 0;
    }

    public void drawFrom(int t) // t is a timebase that will be used to blink the cursor...
    {
      push();
      drawToStart(size, 0, false);
      pop();

      if (cursor_visible && tree.started)
      {
        if (t % (2 * cursor_period) >= cursor_period)
        {
          stroke(255);
          translate(0, -0.5f * fontSize);
          line(0, 0, 0, fontSize);
        }
      }
    }

    public void drawToStart(int startingPosition, float startingDistance, boolean gap)
    {
      if (startingDistance >= tree.vanishDistance)
      {
        return;
      }

      noStroke();
      font.setSize(fontSize);
      font.setAlign(XFont.RIGHT);

      curvature.setSize(0);
      float global_curvature = 0;
      float local_curvature;
      int old_time = 0;
      int time;
      int delta;
      for (int i = 0; i < startingPosition; i++)
      {
        time = stream_time.data[i];
        delta = time - old_time;
        old_time = time;
        if (delta >= tree.curvature_timeThreshold)
        {
          local_curvature = 0;
          global_curvature = 0;
        }
        else
        {
          local_curvature = (1f - (delta / tree.curvature_timeThreshold)) * tree.curvature_maxAngle;
        }
        global_curvature += (local_curvature - global_curvature) * tree.curvature_interpFactor;
        curvature.add(global_curvature);
      }

      float ss = (float) Math.sin(tree.slope);
      if (gap)
      {
        translate(-childGap, 0, -childGap * ss);
      }

      char c;
      float w;
      float d = startingDistance;
      float opacity;
      int index;
      for (int i = startingPosition - 1; i >= 0; i--)
      {
        if (this == tree.currentBranch || (this != tree.currentBranch && i != (startingPosition - 1)))
        {
          Branch child = getChildAt(i);
          if (child != null && child.started)
          {
            saveMatrix();
            rotateZ(HALF_PI);
            child.drawToEnd(0, d, true);
            restoreMatrix();

            font.setSize(fontSize);
            font.setAlign(XFont.RIGHT);
          }
        }

        opacity = 1f - (d / tree.vanishDistance);
        if (opacity <= 0)
        {
          break; // no need to draw further...
        }
        fill(255f * opacity);

        c = stream_char.data[i];
        w = font.getCharWidth(c);
        d += w;

        push();
        rotateY(tree.slope);
        font.drawChar(c, 0, 0);
        pop();

        translate(-w, 0, w * ss);
        rotateZ((w / font.size) * curvature.data[i]);
      }

      if (!isRoot)
      {
        rotateZ(-HALF_PI);
        push();
        parent.drawToStart(position + 1, d, true);
        pop();
        parent.drawToEnd(position + 1, d, true);
      }
    }

    public void drawToEnd(int startingPosition, float startingDistance, boolean gap)
    {
      if (startingDistance >= tree.vanishDistance)
      {
        return;
      }

      noStroke();
      font.setSize(fontSize);
      font.setAlign(XFont.LEFT);

      float global_curvature = 0;
      float local_curvature;
      int old_time = 0;
      int time;
      int delta;
      for (int i = 0; i < startingPosition; i++)
      {
        time = stream_time.data[i];
        delta = time - old_time;
        old_time = time;
        if (delta >= tree.curvature_timeThreshold)
        {
          local_curvature = 0;
          global_curvature = 0;
        }
        else
        {
          local_curvature = (1f - (delta / tree.curvature_timeThreshold)) * tree.curvature_maxAngle;
        }
        global_curvature += (local_curvature - global_curvature) * tree.curvature_interpFactor;
      }

      float ss = (float) Math.sin(tree.slope);
      if (gap)
      {
        translate(childGap, 0, childGap * ss);
      }

      char c;
      float w;
      float d = startingDistance;
      float opacity;
      int index;
      for (int i = startingPosition; i < size; i++)
      {
        time = stream_time.data[i];
        delta = time - old_time;
        old_time = time;
        if (delta >= tree.curvature_timeThreshold)
        {
          local_curvature = 0;
          global_curvature = 0;
        }
        else
        {
          local_curvature = (1f - (delta / tree.curvature_timeThreshold)) * tree.curvature_maxAngle;
        }
        global_curvature += (local_curvature - global_curvature) * tree.curvature_interpFactor;

        opacity = 1f - (d / tree.vanishDistance);
        if (opacity <= 0)
        {
          break; // no need to draw further...
        }
        fill(255f * opacity);

        c = stream_char.data[i];
        w = font.getCharWidth(c);
        d += w;

        push();
        rotateX(tree.slope);
        font.drawChar(c, 0, 0);
        pop();

        translate(w, 0, w * ss);
        rotateZ(- (w / font.size) * global_curvature);

        Branch child = getChildAt(i);
        if (child != null && child.started)
        {
          saveMatrix();
          rotateZ(HALF_PI);
          child.drawToEnd(0, d, true);
          restoreMatrix();

          font.setSize(fontSize);
          font.setAlign(XFont.LEFT);
        }
      }
    }

    // the 2 following methods are because of the depth-limitations of p5's matrix-stack...

    private float[] matrix = new float[16];

    private void saveMatrix()
    {
      matrix[0] = g.m00;
      matrix[1] = g.m01;
      matrix[2] = g.m02;
      matrix[3] = g.m03;
      matrix[4] = g.m10;
      matrix[5] = g.m11;
      matrix[6] = g.m12;
      matrix[7] = g.m13;
      matrix[8] = g.m20;
      matrix[9] = g.m21;
      matrix[10] = g.m22;
      matrix[11] = g.m23;
      matrix[12] = g.m30;
      matrix[13] = g.m31;
      matrix[14] = g.m32;
      matrix[15] = g.m33;
    }

    private void restoreMatrix()
    {
      g.m00 = matrix[0];
      g.m01 = matrix[1];
      g.m02 = matrix[2];
      g.m03 = matrix[3];
      g.m10 = matrix[4];
      g.m11 = matrix[5];
      g.m12 = matrix[6];
      g.m13 = matrix[7];
      g.m20 = matrix[8];
      g.m21 = matrix[9];
      g.m22 = matrix[10];
      g.m23 = matrix[11];
      g.m30 = matrix[12];
      g.m31 = matrix[13];
      g.m32 = matrix[14];
      g.m33 = matrix[15];
    }
  }

  // ------------------------------------------------------

  // the 3 following classes are more than inspired by SUN's java.util.Vector

  public class CharBuffer
  {
    public char data[];
    public int size;
    private int capacityIncrement;

    public CharBuffer(int initialCapacity, int capacityIncrement)
    {
      this.data = new char[initialCapacity];
      this.capacityIncrement = capacityIncrement;
    }

    public CharBuffer(int initialCapacity)
    {
      this(initialCapacity, 0);
    }

    public CharBuffer()
    {
      this(64);
    }

    public void add(char value)
    {
      ensureCapacity(size + 1);
      data[size++] = value;
    }

    public void set(int index, char value)
    {
      if (index >= size)
      {
        ensureCapacity(index + 1);
        size = index + 1;
      }
      data[index] = value;
    }

    public void setSize(int newSize)
    {
      if (newSize > size)
      {
        ensureCapacity(newSize);
      }
      size = newSize;
    }

    private void ensureCapacity(int minCapacity)
    {
      int oldCapacity = data.length;
      if (minCapacity > oldCapacity)
      {
        char tmp[] = data;
        int newCapacity = (capacityIncrement > 0) ? (oldCapacity + capacityIncrement) : (oldCapacity * 2);
        data = new char[newCapacity < minCapacity ? minCapacity : newCapacity];
        System.arraycopy(tmp, 0, data, 0, size);
      }
    }
  }

  public class IntBuffer
  {
    public int data[];
    public int size;
    private int capacityIncrement;

    public IntBuffer(int initialCapacity, int capacityIncrement)
    {
      this.data = new int[initialCapacity];
      this.capacityIncrement = capacityIncrement;
    }

    public IntBuffer(int initialCapacity)
    {
      this(initialCapacity, 0);
    }

    public IntBuffer()
    {
      this(64);
    }

    public void add(int value)
    {
      ensureCapacity(size + 1);
      data[size++] = value;
    }

    public void set(int index, int value)
    {
      if (index >= size)
      {
        ensureCapacity(index + 1);
        size = index + 1;
      }
      data[index] = value;
    }

    public void setSize(int newSize)
    {
      if (newSize > size)
      {
        ensureCapacity(newSize);
      }
      size = newSize;
    }

    private void ensureCapacity(int minCapacity)
    {
      int oldCapacity = data.length;
      if (minCapacity > oldCapacity)
      {
        int tmp[] = data;
        int newCapacity = (capacityIncrement > 0) ? (oldCapacity + capacityIncrement) : (oldCapacity * 2);
        data = new int[newCapacity < minCapacity ? minCapacity : newCapacity];
        System.arraycopy(tmp, 0, data, 0, size);
      }
    }
  }

  public class FloatBuffer
  {
    public float data[];
    public int size;
    private int capacityIncrement;

    public FloatBuffer(int initialCapacity, int capacityIncrement)
    {
      this.data = new float[initialCapacity];
      this.capacityIncrement = capacityIncrement;
    }

    public FloatBuffer(int initialCapacity)
    {
      this(initialCapacity, 0);
    }

    public FloatBuffer()
    {
      this(64);
    }

    public void add(float value)
    {
      ensureCapacity(size + 1);
      data[size++] = value;
    }

    public void set(int index, float value)
    {
      if (index >= size)
      {
        ensureCapacity(index + 1);
        size = index + 1;
      }
      data[index] = value;
    }

    public void setSize(int newSize)
    {
      if (newSize > size)
      {
        ensureCapacity(newSize);
      }
      size = newSize;
    }

    private void ensureCapacity(int minCapacity)
    {
      int oldCapacity = data.length;
      if (minCapacity > oldCapacity)
      {
        float tmp[] = data;
        int newCapacity = (capacityIncrement > 0) ? (oldCapacity + capacityIncrement) : (oldCapacity * 2);
        data = new float[newCapacity < minCapacity ? minCapacity : newCapacity];
        System.arraycopy(tmp, 0, data, 0, size);
      }
    }
  }

  // ------------------------------------------------------

  public class XFont
  {
    static final int LEFT = 0;
    static final int CENTER = 1;
    static final int RIGHT = 2;

    private BImage data;
    private int pointSize, pointHeight, pointLeading;
    private float[] widths;
    private float size;
    private float size_ratio;
    private float max_width;
    private int align = LEFT;

    public XFont(String filename, int pointSize, int pointHeight, int pointLeading, float[] widths)
    {
      this.pointSize = pointSize;
      this.pointHeight = pointHeight;
      this.pointLeading = pointLeading;
      this.widths = widths;

      max_width = 0;
      for (int i = 0; i < widths.length; i++)
      {
        max_width = widths[i] > max_width ? widths[i] : max_width;
      }

      data = loadImage(filename);
      data.format = ALPHA;
      for (int i = data.width * data.height - 1; i > -1; i--)
      {
        data.pixels[i] &= 0xff;
      }

      setSize(pointSize); // default value
    }

    public void setSize(float size)
    {
      this.size = size;
      size_ratio = size / pointSize;
    }

    public void setAlign(int align)
    {
      this.align = align;
    }

    public float getCharWidth(char c)
    {
      if (c < ' ' || c > 255)
      {
        c = '?';
      }
      return widths[c - ' '] * size_ratio;
    }

    public float getStringWidth(String s)
    {
      float w = 0;
      int len = s.length();
      for (int i = 0; i < len; i++)
      {
        w += getCharWidth(s.charAt(i));
      }
      return w;
    }

    public void drawString(String s, float x, float y)
    {
      if (align == CENTER)
      {
        x -= 0.5f * getStringWidth(s);
      }

      char c;
      int len = s.length();
      for (int i = 0; i < len; i++)
      {
        if (align != RIGHT)
        {
          c = s.charAt(i);
        }
        else
        {
          c = s.charAt(len - i - 1);
        }

        drawChar(c, x, y);

        if (align != RIGHT)
        {
          x += getCharWidth(c);
        }
        else
        {
          x -= getCharWidth(c);
        }
      }
    }

    // note: if a single character has to be horizontally centered, it must be drawn using drawString()
    public void drawChar(char c, float x, float y)
    {
      if (c == ' ')
      {
        return;
      }
      if (c < ' ' || c > 255)
      {
        c = '?';
      }
      float w = widths[c - ' '];

      float cx;
      if (align != RIGHT)
      {
        cx = 0.5f * (size - max_width * size_ratio);
      }
      else
      {
        cx = -w * size_ratio;
      }
      float cy = -0.5f * size; // vertically aligned to center

      float x1 = x + cx;
      float x2 = x1 + w * size_ratio;
      float y1 = y + cy;
      float y2 = y1 + pointHeight * size_ratio;

      // includes quick & dirty 3d clipping...
      float mx = x1 + 0.5f * (x2 - x1);
      float my = y1 + 0.5f * (y2 - y1);
      float sx = screenX(mx, my, 0);
      float sy = screenY(mx, my, 0);
      if (sx >= -32 && sx < (width + 32) && sy > -32 && sy < (height + 32))
      {
        float u1 = 0.5f * (pointSize - w);
        float u2 = u1 + w;
        float v1 = (c - '!') * pointLeading;
        float v2 = v1 + pointHeight;

        beginShape(QUADS);
        textureImage(data);
        vertexTexture(u1, v1);
        vertex(x1, y1);
        vertexTexture(u1, v2);
        vertex(x1, y2);
        vertexTexture(u2, v2);
        vertex(x2, y2);
        vertexTexture(u2, v1);
        vertex(x2, y1);
        endShape();
      }
    }
  }

  // ------------------------------------------------------

  public class PFont
  {
    private BImage data;
    private int box_w, box_h;
    private int[] widths;
    private int leading;

    public PFont(String filename, int box_w, int box_h, int[] widths)
    {
      this.box_w = box_w;
      this.box_h = box_h;
      this.widths = widths;

      data = loadImage(filename);
      for (int i = data.width * data.height - 1; i > -1; i--)
      {
        data.pixels[i] &= 0xff;
      }

      leading = box_h;
    }

    public int getHeight()
    {
      return box_h;
    }

    public int getCharWidth(char c)
    {
      if (c == '\n')
      {
        return 0;
      }
      if (c < ' ' || c > 0xff)
      {
        c = '?';
      }
      return widths[c - ' '];
    }

    public int getStringWidth(String s) // won't work for multiline strings
    {
      int w = 0;
      int len = s.length();
      for (int i = 0; i < len; i++)
      {
        w += getCharWidth(s.charAt(i));
      }
      return w;
    }

    public void drawString(String s, int x, int y)
    {
      char c;
      int xx = x;
      int len = s.length();
      for (int i = 0; i < len; i++)
      {
        c = s.charAt(i);
        if (c == '\n')
        {
          xx = x;
          y += leading;
          continue;
        }
        if (c != ' ')
        {
          drawChar(c, xx, y);
        }
        xx += getCharWidth(c);
      }
    }

    public void drawString(StringBuffer s, int x, int y)
    {
      char c;
      int xx = x;
      int len = s.length();
      for (int i = 0; i < len; i++)
      {
        c = s.charAt(i);
        if (c == '\n')
        {
          xx = x;
          y += leading;
          continue;
        }
        if (c != ' ')
        {
          drawChar(c, xx, y);
        }
        xx += getCharWidth(c);
      }
    }

    public void drawChar(char c, int x, int y) // TODO: clipping against a custom clip-area
    {
      if (c == ' ' || c == '\n')
      {
        return;
      }
      if (c < ' ' || c > 255)
      {
        c = '?';
      }

      int col = g.filli;

      int[] src_pixels = data.pixels;
      int[] dst_pixels = pixels;

      int w = widths[c - ' '];
      int h = box_h;

      int src_w = box_w;
      int dst_w = width;

      int src_offset = src_w * (c - '!') * h;
      int dst_offset = dst_w * y + x;
      for (int iy = 0; iy < h; iy++)
      {
        for (int ix = 0; ix < w; ix++)
        {
          if (src_pixels[src_offset + ix] != 0)
          {
            dst_pixels[dst_offset + ix] = col;
          }
        }
        src_offset += src_w;
        dst_offset += dst_w;
      }
    }
  }

  // ------------------------------------------------------

  public static class ScreenManager
  {
    private static Screen screen_to, screen_current;

    public static void setScreen(Screen screen)
    {
      screen_to = screen;
    }

    public static void run()
    {
      if (screen_to != null)
      {
        if (screen_current != null)
        {
          screen_current.exit();
        }
        screen_current = screen_to;
        screen_to = null;
        screen_current.enter();
      }

      screen_current.run();
    }
  }

  // ---

  public abstract class Screen implements EventListener
  {
    public abstract void run();
    public abstract void enter();
    public abstract void exit();
  }

  // ------------------------------------------------------

  public interface EventListener
  {
    public void event(Object source, int message);
  }

  public class EventCaster
  {
    public Vector listeners;

    public void addListener(EventListener listener)
    {
      if (listeners == null)
      {
        listeners = new Vector();
      }
      if (!listeners.contains(listener))
      {
        listeners.addElement(listener);
      }
    }

    public void removeListener(EventListener listener)
    {
      listeners.removeElement(listener);
    }

    public void castEvent(int message)
    {
      for (int i = listeners.size() - 1; i > -1; i--)
      {
        ((EventListener) listeners.elementAt(i)).event(this, message);
      }
    }
  }

  // ------------------------------------------------------

  public static class StyleShortcut
  {
    public static void get(Style style, int col1, int col2, int col3, int col4)
    {
      style.stroke = col1;
      style.fill = col2;
      style.body = col1;
      style.stroke_over = col3;
      style.fill_over = col2;
      style.body_over = col3;
      style.stroke_pressed = col3;
      style.fill_pressed = col3;
      style.body_pressed = col2;
      style.stroke_disabled = col4;
      style.fill_disabled = col2;
      style.body_disabled = col4;
    }
  }

  public class Style
  {
    public int stroke, fill, body;
    public int stroke_over, fill_over, body_over;
    public int stroke_pressed, fill_pressed, body_pressed;
    public int stroke_disabled, fill_disabled, body_disabled;
  }

  // ---

  public class Button extends EventCaster
  {
    public static final int EVENT_PRESSED = 0;

    public int x, y;
    public int w, h;
    public boolean over, pressed, armed, disabled, locked;
    protected Style style;
    protected int color_stroke, color_fill, color_body;

    public Button(int w, int h, Style style)
    {
      this.style = style;
      this.w = w;
      this.h = h;
    }

    public void setLocation(int x, int y)
    {
      this.x = x;
      this.y = y;
    }

    public void reset()
    {
      over = pressed = armed = disabled = locked = false;
    }

    public void setEnabled(boolean b)
    {
      disabled = !b;
    }

    public void setLocked(boolean b)
    {
      locked = b;
    }

    public void run()
    {
      over = !disabled && !armed && mouseX >= x && mouseX < (x + w) && mouseY >= y && mouseY < (y + h);
      armed = !over && mousePressed;

      if (!locked && !pressed && over && mousePressed)
      {
        castEvent(EVENT_PRESSED);
        pressed = true;
      }
      pressed = !disabled && pressed && mousePressed;

      draw();
    }

    public void draw()
    {
      color_stroke = 0xff000000 | (disabled ? style.stroke_disabled : ((pressed || locked) ? style.stroke_pressed : (over ? style.stroke_over : style.stroke)));
      color_fill = 0xff000000 | (disabled ? style.fill_disabled : ((pressed || locked) ? style.fill_pressed : (over ? style.fill_over : style.fill)));
      color_body = 0xff000000 | (disabled ? style.body_disabled : ((pressed || locked) ? style.body_pressed : (over ? style.body_over : style.body)));

      rectMode(CORNER);
      stroke(color_stroke);
      fill(color_fill);
      rect(x, y, w - 1, h - 1);
    }
  }

  // ---

  public class TextButton extends Button
  {
    private PFont font;
    private String text;
    private int text_w, text_h;

    public TextButton(int w, int h, PFont font, Style style)
    {
      super(w, h, style);
      this.font = font;
    }

    public void setText(String s)
    {
      text = s;
      text_w = font.getStringWidth(s);
      text_h = font.getHeight();
    }

    public void draw()
    {
      super.draw();

      fill(color_body);
      font.drawString(text, x + (w - text_w) / 2, y + (h - text_h) / 2);
    }
  }

  // ---

  public class ImageButton extends Button
  {
    private BImage image;

    public ImageButton(int w, int h, BImage image, Style style)
    {
      super(w, h, style);
      setImage(image);
    }

    public void setImage(BImage image)
    {
      this.image = image;
      for (int i = image.width * image.height - 1; i > -1; i--)
      {
        image.pixels[i] &= 0xff;
      }
    }

    public void draw()
    {
      super.draw();

      int xx = x + (w - image.width) / 2;
      int yy = y + (h - image.height) / 2;

      int[] src_pixels = image.pixels;
      int[] dst_pixels = pixels;

      int src_offset = 0;
      int dst_offset = width * yy + xx;
      for (int iy = image.height - 1; iy > -1; iy--)
      {
        for (int ix = image.width - 1; ix > -1; ix--)
        {
          if (src_pixels[src_offset + ix] != 0)
          {
            dst_pixels[dst_offset + ix] = color_body;
          }
        }
        src_offset += image.width;
        dst_offset += width;
      }
    }
  }
}
