public class BubbleSort {
    int[] zahlen;
    boolean swap1 = false;
    public boolean swap(int a, int b){
        if (a > b) {
            int temp = a;
            a = b;
            b = temp;
            return true;
        }
        else {
            return false;
        }       
    }
    
    int i = zahlen.length - 2;
    while (swap == true){
        if (!swap1){
            for (int j = 0; j <= i; j++)
            {
                if (zahlen[j] > zahlen[j+1]){
                    swap(zahlen[j], zahlen[j+1]);   
                    swap1 = true;            
                }
            }
            i--;
        }
    }   
}



    

