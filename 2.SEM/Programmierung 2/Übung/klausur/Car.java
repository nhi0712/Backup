package klausur;
public class Car implements Comparable<Car> {

    private String licensePlate;
    private String type;
    private int horsePower;
    private String color;
    private int drivenKm;

    public Car(String licensePlate, String type, int horsePower, String color, int drivenKm) {
        this.licensePlate = licensePlate;
        this.type = type;
        this.horsePower = horsePower;
        this.color = color;
        this.drivenKm = drivenKm;

    }

    @Override
    public int compareTo(Car o){
        if(this.horsePower != o.horsePower){
            return this.horsePower - o.horsePower;
        }

        if(this.type.toUpperCase().compareTo(o.type.toUpperCase()) != 0){
            return this.type.toUpperCase().compareTo(o.type.toUpperCase());
        }

        if(this.licensePlate.compareTo(o.licensePlate) != 0){
            return this.licensePlate.compareTo(o.licensePlate);
        }

        return 0;
    }

    @Override
    public String toString(){
        return this.type + ", " + this.horsePower + ", " + this.licensePlate + ", " + this.color + ", " + this.drivenKm;
    }


}
