public class SchokoLeer {
    public class SchokoLeer extends Exception {
        public SchokoLeer(int rest, int angefragt){
        super("Achtung: Es werden " + angefragt + 
        " Tafeln gebraucht, aber es sind nur noch " + rest + 
        " Tafeln in der Box.");
        }
        }
        
}
