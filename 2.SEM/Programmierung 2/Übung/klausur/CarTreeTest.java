package klausur;
public class CarTreeTest {
    public static void main(String[] args) {
        BinaryTree<Car> carTree = new BinaryTree<Car>();

        carTree.add(new Car("HD-ML 6273", "sportwagen", 240, "ROT", 827392));
        carTree.add(new Car("HD-XX 1234", "suv", 180, "SCHWARZ", 123456));
        carTree.add(new Car("HD-HE 7283", "kombi", 130, "GRÜN", 83721));
        carTree.add(new Car("HD-ME 7283", "kleinwagen", 68, "ROT", 26372));
        carTree.add(new Car("HD-XX 1234", "suv", 180, "SCHWARZ", 123458));
        carTree.add(new Car("HD-IN 1782", "kombi", 130, "GRÜN", 83721));
        carTree.add(new Car("HD-MS 8293", "minivan", 110, "GRAU", 63742));

        carTree.print();
    }
}
