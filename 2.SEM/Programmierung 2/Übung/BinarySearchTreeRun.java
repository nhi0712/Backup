public class BinarySearchTreeRun {
    public static void main(String[] args) {
        BinarySearchTree tree = new BinarySearchTree<>();
        tree.add(5);
        tree.add(4);
        tree.add(6);
        tree.add(3);
        tree.add(7);
        
        System.out.println("tree size: " + tree.getSize());
        System.out.println("post-order: ");
        tree.postOrderTravers();

        System.out.println("In-Order: ");
        tree.inOrderTravers();

        System.out.println("Pre-Order: ");
        tree.preOrderTravers();
        

        
        

    }
}
