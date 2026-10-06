public class Stack <T>{

    private Node head;
    private int size;

    public void push(String data){
        head = new Node(data, head);
        size++;
    }

    public String pop(){
        if (head == null){
            return null;       
        }
        String data = head.getData();
        head = head.getNextNode();
        size--;
        return data;

    }

    public String peek(){
        if (head == null){
            return null;
        }
        String data = head.getData();
        return data;
    }

    public int size(){
        return size;
    }
    
    public boolean isEmpty(){
        return head == null;
    }
    
    private class Node{
        private String data;
        private Node nextNode;

        public Node (String data, Node nextNode){
            this.data = data;
            this.nextNode = nextNode;
        }

        public String getData(){
            return data;
        }

        public Node getNextNode(){
            return nextNode;
        }
    }
}
