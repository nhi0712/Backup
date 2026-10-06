public class FifoQueue {
    private Node head;

    private class Node {
        String data;
        Node next;

        Node (String data) {
            this.data = data;
            this.next = null;
        }
    }   

    public String get() {
        if(head == null) {
            System.out.println("Queue is empty");
            return "";
        }
        else {
            Node current = head;
            while (current.next != null) {
                current = current.next;
            }
            return current.data;
        }
    }

    public void put(String data){
        if(head == null) {
            head = new Node(data);
        }
        else {
            Node current = head;
            while ( current.next != null) {
                current = current.next;
            }
            current.next = new Node(data);

        }
    }

}



