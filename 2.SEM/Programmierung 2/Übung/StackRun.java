public class StackRun {
public static void main(String[] args) {
    Stack myStack = new Stack<String>();
    myStack.push("Duong");
    myStack.push("Thi");
    myStack.push("Quynh");
    myStack.push("Nhi");
   

    //oberste Element
    System.out.println(myStack.peek());
   
    //pop
    System.out.println("Elemente werden rausgenommen");
    while (!myStack.isEmpty()){
        System.out.println(myStack.pop());
    } 

    //wie viele Eelemente ist noch auf dem stack
    System.out.println("wie viele Elemente gibt es noch auf dem Stack");
    System.out.println(myStack.peek());


}
}
