// Example showing how to add a Swing menu bar to an OpenGL sketch. 
// This requires JOGL's NewtCanvasAWT class for native parenting: 
// http://jogamp.org/deployment/jogamp-next/javadoc/jogl/javadoc/com/jogamp/newt/awt/NewtCanvasAWT.html
// in order to wrap the native GLWindow as a Canvas that can be added 
// to AWT/Swing components.

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import com.jogamp.newt.awt.*;
import com.jogamp.newt.opengl.*;

void init() {
  JFrame frame = new JFrame("Parent JFrame");
  frame.setLayout(new BorderLayout());  
  frame.setResizable(false);
  
  JMenuBar menuBar = new JMenuBar();    
  JMenu menu = new JMenu("Menu");  
  JMenuItem exitItem = new JMenuItem("Exit");
  exitItem.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
      exit();
    }
  });
  menu.add(exitItem);
  menuBar.add(menu);
  
  // Wrap the native surface using a NewtCanvasAWT object
  // that can be used to embed inside the JFrame.
  GLWindow win = (GLWindow)surface.getNative();
  Canvas canvas = new NewtCanvasAWT(win);
  canvas.setBounds(0, 0, win.getWidth(), win.getHeight());
  
  frame.setJMenuBar(menuBar);
  frame.add(canvas);
    
  frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  frame.pack();
  frame.setVisible(true);
  frame.setLocation(200, 200);
        
  super.init();
}

void settings() {
  size(400, 400, P3D);
}
  
void draw() {
  background(150);
  line(0, 0, 400, 400);
  line(0, 400, 400, 0);
  ellipse(mouseX, mouseY, 50, 50);
}  