public class Queue<T>{

    private Node head;

    private Node tail;
    private int size;

    public void enqueue (T data){
        Node newNode = new Node(data);
        if (isEmpty()){
            head = newNode;
        }
        else{
            tail.setPrevNode(newNode);
        }
        size++;
        tail = newNode;
    }

    public T dequeue(){
        if(isEmpty()){
            return null;
        }
        
        T data = head.getData();
        if (head == tail){
            head = null;
            tail = null;
        }
        else{
            head = head.getPrevNode();
        }
        size--;
        return data;
    }

    public T peek(){
        if (head == null){
            return null;
        }
        T data = head.getData();
        return data;
    } 

    public int size(){
        return size;
    }

    public boolean isEmpty(){
       return head == null && tail == null;
    }

   public void print(){
    if (isEmpty()){
        System.out.println("Queue is empty");
    }

    Node currentNode = head;
    while (currentNode != null){
        System.out.println(currentNode.getData());
        currentNode = currentNode.getPrevNode();
    }

   }

    private class Node{
        private T data;
        private Node prevNode;

        Node (T data){
            this.data = data;
        }
        
        public T getData(){
            return data;
        }

        public Node getPrevNode(){
            return prevNode;
        }

        public void setPrevNode(Node prevNode){
            this.prevNode = prevNode;
        }
    }

}
