package klausur;
public class BinaryTree<T extends Comparable<T>> {

    private Node<T> root = null;
    private int size = 0;
    private class Node<T>{
        private Node<T> leftNode;
        private T data;
        private Node<T> rightNode;

        public Node(T data){
            this.data = data;
            this.leftNode = null;
            this.rightNode = null;
        }

        public T getData(){
            return data;
        }

        public Node<T> getLeftNode(){
            return leftNode;
        }

        public void setLeftNode(Node<T> leftNode){
            this.leftNode = leftNode;
        }

        public Node<T> getRightNode(){
            return rightNode;
        }
        public void setRightNode(Node<T> rightNode){
            this.rightNode = rightNode;
        }
    }

    public void add(T data){
        Node<T> newNode = new Node(data);

        if(root == null){
            root = newNode;
            size++;
            return;
        }
        add(root, newNode);
    }

    private void add(Node<T> currentNode, Node<T> newNode){
        int result = newNode.getData().compareTo(currentNode.getData());

        if(result < 0 ){
            if (currentNode.getLeftNode() == null){
                currentNode.setLeftNode(newNode);
                size++;
            } else{
                add(currentNode.getLeftNode(), newNode);
            }
        } else if(result > 0){
            if(currentNode.getRightNode() == null){
                currentNode.setRightNode(newNode);
                size++;
            }else{
                add(currentNode.getRightNode(), newNode);
            }
        }

        
    }
    public int size(){
        return size;
    }

    
    public void print(){
        if(root != null){
            print(root);
        }
    }

    private void print(Node currentNode){
        if (currentNode.getRightNode() != null){
            print(currentNode.getRightNode());
        }

        System.out.println(currentNode.getData());

        if(currentNode.getLeftNode() != null){
            print(currentNode.getLeftNode());
        }
    }
}
