public class Main {
    public class Calculation {
 
        public int calculateA(int x) {
            int result = (x * 2) + 10;
            return result;
        }
    
        public int calculateB(int x) {
            int result = (x * 2) + 10;
            return result;
        }
    
        public int calculateC(int x) {
            int result = (x * 2) + 10;
            return result;
        }
    }
    public class Calculation {

        private int calculate(int x) {
            return (x * 2) + 10;
        }
    
        public int calculateA(int x) {
            return calculate(x);
        }
    
        public int calculateB(int x) {
            return calculate(x);
        }
    
        public int calculateC(int x) {
            return calculate(x);
        }
    }
}
