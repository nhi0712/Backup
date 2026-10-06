package Swing;

import javax.swing.*;

import org.w3c.dom.events.MouseEvent;
import java.awt.event.*;

import java.awt.*;
public class FlowLayoutExample extends JFrame {
    public FlowLayoutExample(){
        this.setTitle("FlowLayoutExmaple");
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        FlowLayout myFlowLayout = new FlowLayout();
        this.setLayout(myFlowLayout);

        this.add(new JLabel("NiNi"), BorderLayout.CENTER);
        this.add(new JButton("LuLu"));
        this.add(new JTextField(20), BorderLayout.SOUTH);
        this.add(new JLabel("label1"));
        this.add(new JLabel("label2"));

        this.add(new JButton("LuNi"));
        this.add(new JTextField(40));

        // MouseListener
        MouseListener mouseListener = new MouseListener() {

      @Override
         public void mouseClicked(MouseEvent e) {
        System.out.println("Clicked UI Component " + ((JButton)e.getSource()).getName());
      }

      @Override
      public void mousePressed(MouseEvent e) {
        System.out.println("Pressed UI Component " + ((JButton)e.getSource()).getName());
      }

      @Override
      public void mouseReleased(MouseEvent e) {
        System.out.println("Released UI Component " + ((JButton)e.getSource()).getName());
      }

      @Override
      public void mouseEntered(MouseEvent e) {
        System.out.println("Entered UI Component " + ((JButton)e.getSource()).getName());
      }

      @Override
      public void mouseExited(MouseEvent e) {
        System.out.println("Exit UI Component " + ((JButton)e.getSource()).getName());
      }
    };

        this.pack();
        this.setVisible(true);

    }

    public static void main(String[] args) {
        new FlowLayoutExample();
    }

}
