import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;


public class List_Iterator {
public static void main(String[] args) {
    List myList = new ArrayList();
    myList.add("A"); //index 0
    myList.add("B"); //1
    myList.add("C"); //2  
    myList.add("D"); //3
    myList.add(2, "B");
    myList.set(3, "b");

    System.out.println("List has B? " + myList.contains("B"));
    System.out.println("List hat D? " + myList.contains("D"));
    System.out.println("index of A " + myList.indexOf("A"));
    System.out.println("index of B " + myList.indexOf("B"));
    System.out.println("index of D " + myList.indexOf("D"));
    System.out.println(myList.get(0));
    System.out.println(myList.size());

    myList.set(4, "d");
    Iterator i = myList.iterator();
    while (i.hasNext()){
        System.out.println(i.next());
       
    }

    

}
}
