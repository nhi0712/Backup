public class LinkedList<T> {

    private Node firstNode;
    private int size = 0;
    
    public void add(T data){
        Node newNode = new Node(data);
        size++;
        if (firstNode == null){
            firstNode = newNode;    
            return;      
        }
        Node currentNode = firstNode;
        while (currentNode.getNextNode() != null){
            currentNode = currentNode.getNextNode();
        }
        currentNode.setNextNode(newNode);
    }

    public boolean remove(T data){
        if(firstNode == null){
            return false;
        }
        if(firstNode.getData() == data){
            firstNode = firstNode.getNextNode();
            size--;
            return true;
        }

        Node currentNode = firstNode;
        while (currentNode.getNextNode() != null){
            if (currentNode.getNextNode().getData() == data){
                currentNode.setNextNode(currentNode.getNextNode().getNextNode());
                size--;
                return true;
            }

            currentNode = currentNode.getNextNode();
        }
        return false;
    }

    public void printList(){
        if (firstNode == null){
            System.out.println("List is empty");
        }
        Node currentNode = firstNode;
        while (currentNode.getNextNode() != null){
            System.out.println(currentNode.getData());
            currentNode = currentNode.getNextNode();
        }
        System.out.println(currentNode.getData());

    }

    public int size(){
        return size;
    }

    public boolean isEmpty(){
        return firstNode == null;
    }

    public boolean contains(T data){
        Node currentNode = firstNode;
        while (currentNode.getNextNode() != null){
            if (currentNode.getData() == data){
                return true;
            }
            currentNode = currentNode.getNextNode();
        }
        return false;
    }

    private class Node{
        private T data;
        private Node nextNode;

        Node (T data){
            this.data = data;
            this.nextNode = null;
        }

        T getData(){
            return data;
        }

        Node getNextNode(){
            return nextNode;
        }


        void setNextNode(Node nextNode){
            this.nextNode = nextNode;
        }

    }
}
