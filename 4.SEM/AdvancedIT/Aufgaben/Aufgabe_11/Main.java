public class Main {
    public static void main(String[] args) {     
        FifoQueue queue = new FifoQueue();
        queue.put("1");
        queue.put("2");
        queue.put("3");
        
        System.out.println(queue.get());   
        queue.put("4");
        System.out.println(queue.get());
        
    }
}