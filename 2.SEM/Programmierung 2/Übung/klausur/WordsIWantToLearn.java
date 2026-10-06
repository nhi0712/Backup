package klausur;

public class WordsIWantToLearn {
    Element peekElement = null;
    public void push(String data){
        peekElement = new Element(data, peekElement);
    }

    public String pop(){
        if (peekElement == null){
            return null;
        }
        else{
            String data = peekElement.getData();
            return data;
        }
    }

    public String peek(){
        if(peekElement == null){
            return null;
        }
        else{
            String data = peekElement.getData();
            return data;
        }
    }

    private class Element{
        private String data;
        private Element prevElement;

        public Element(String data, Element prevElement){
            this.data = data;
            this.prevElement = prevElement;
        }

        public String getData(){
            return data;
        }

        public Element gePrevElement(){
            return prevElement;
        }
    }

}
