

public interface Bookable {

  int freeSlots();
  void bookSlots(int slots) throws NotEnoughFreeSlotsException;
  default boolean reserveSlots(int slots){
    return false;
  }
}
