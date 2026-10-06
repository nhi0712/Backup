public class BinarySearchTree<T extends Comparable<T>>{

    private Node root;
    private int size;

    public boolean add(T data){
        if (root == null){
            root = new Node(data);
            return true;
        }
        return add(data,root);
    } 

    private boolean add(T data, Node currentNode){
        if(currentNode.getData().compareTo(data) > 0){
            if (currentNode.getLeftNode() == null){
                currentNode.setLeftNode(new Node(data));
                return true;
            }
            else{
                return add(data, currentNode.leftNode);
            }
        }
        else if(currentNode.getData().compareTo(data) < 0){
            if(currentNode.getRightNode() == null){
                currentNode.setRightNode(new Node(data));
            }
            else{
                return add(data, currentNode.rightNode);
            }
        }
        return false;
    }

    public int getSize(){
        return size;
    }

    //in-order-traversierung -> left, current, right
    public void inOrderTravers(){
        if(root != null){
            inOrderTravers(root);
        }
        else{
            System.out.println("leerer Baum");
        }
    }
    private void inOrderTravers(Node currentNode){
        if(currentNode.getLeftNode() != null){
            inOrderTravers(currentNode.getLeftNode());
        }
        System.out.println(currentNode.getData());
        if(currentNode.getRightNode() != null){
            inOrderTravers(currentNode.getRightNode());
        }
    }

    //pre-order-traversierung  -> current, left, right
    public void preOrderTravers(){
        if (root != null){
            preOrderTravers(root);
        }
        else{
            System.out.println("leerer Baum");
        }
    }

    private void preOrderTravers(Node currentNode){
        System.out.println(currentNode.getData());
        if(currentNode.getLeftNode() != null){
            inOrderTravers(currentNode.getLeftNode());
        }
        if(currentNode.getRightNode() != null){
            inOrderTravers(currentNode.getRightNode());
        }
    }

    //left, right, current
    public void postOrderTravers(){
        if(root != null){
            postOrderTravers(root);
        }
        else{
            System.out.println("leerer Baum");
        }
    }
    private void postOrderTravers(Node currentNode){
        if(currentNode.getLeftNode() != null){
            postOrderTravers(currentNode.getLeftNode());
        }
        if(currentNode.getRightNode() != null){
            postOrderTravers(currentNode.getRightNode());
        }
        System.out.println(currentNode.getData());
    }

    private class Node{
        private T data;
        private Node leftNode;
        private Node rightNode;
        

        Node (T data){
            this.data = data;
            size++;
        }

        void setLeftNode(Node leftNode){
            this.leftNode = leftNode;
        }

        void setRightNode(Node rightNode){
            this.rightNode = rightNode;
        }

        Node getLeftNode(){
            return leftNode;
        }

        Node getRightNode(){
            return rightNode;
        }

        T getData(){
            return data;
        }
    }
}
