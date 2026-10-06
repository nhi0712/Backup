package Swing;

import javax.swing.*;
import java.awt.*;

public class GridLayoutExample extends JFrame{

    public GridLayoutExample(){
        this.setTitle("GridLayoutExample");
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        this.setLayout(new GridLayout(0,5));

        this.add(new JLabel("Cell 1"));
        this.add(new JLabel("Cell 2"));
        this.add(new JLabel("Cell 3"));
        this.add(new JLabel("Cell 4"));
        this.add(new JLabel("Cell 5"));
        this.add(new JButton("Cell 6"));

        JPanel cell7Panel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        cell7Panel.add(new JButton("Cell 7"));
        this.add(cell7Panel);

    

        this.pack();
        this.setVisible(true);
    }

    public static void main(String[] args) {
        new GridLayoutExample();
    }

}
