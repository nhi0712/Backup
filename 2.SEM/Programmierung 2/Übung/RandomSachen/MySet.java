import java.util.TreeSet;
import java.util.Iterator;
import java.util.Set;

public class MySet {
public static void main(String[] args) {
    Set mySet = new TreeSet();
    mySet.add("Duong");
    mySet.add("Thi");
    mySet.add("Quynh");
    mySet.add("Nhi");

    System.out.println(mySet.contains("Nhi"));
    System.out.println(mySet.size());

    Iterator i = mySet.iterator();
    while (i.hasNext()){
        System.out.println(i.next());
    }

    


}
}
