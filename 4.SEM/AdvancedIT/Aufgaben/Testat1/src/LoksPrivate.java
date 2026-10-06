import java.util.concurrent.Semaphore;

public class LoksPrivate {

    private int criticalSectionLength = 5;
    private int privateSectionLength = 10;
    
    // Geteilter Zustand
    private int turn = 0; // 0 bedeutet Lok 0 ist dran, 1 bedeutet Lok 1 ist dran
    private boolean[] waiting = {false, false}; // Merkt sich, ob eine Lok gerade an der Weiche wartet
    
    // Mutex für "turn" und "waiting"
    private Semaphore mutex = new Semaphore(1);
    
    // Die privaten Semaphoren für jede Lok (starten bei 0)
    private Semaphore[] privSem = {new Semaphore(0), new Semaphore(0)};

    private final long startTime = System.currentTimeMillis();

    /**
     * Innere Klasse für die Lok-Threads.
     */
    public class Lok extends Thread {
        private int id;
        private int speedUnitPerSecond;

        public Lok(int id, int speedUnitPerSecond) {
            this.id = id;
            this.speedUnitPerSecond = speedUnitPerSecond;
        }

        @Override
        public void run() {
            while(true) {
                log("erreicht die Weiche und wartet ggf.");
                
                enter(); 
                
                log("befährt das gemeinsame Mittelstück.");
                sleepForSection(criticalSectionLength);
                
                exit(); 
                
                log("hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.");
                sleepForSection(privateSectionLength);
            }
        }
        
        /**
         * Methode zum Betreten des Mittelstücks (Verbraucher).
         */
        private void enter() {
            try {
                // Mutex holen, um Variablen sicher zu lesen/schreiben
                mutex.acquire(); 
                
                if (turn != id) {
                    // Lok soll warten
                    waiting[id] = true;
                    // Mutex freigeben, vor sleep
                    mutex.release(); 
                    
                    // Am privaten Semaphor warten - sleep
                    privSem[id].acquire(); 
                } else {
                    // Lok darf fahren, Mutex wieder freigeben.
                    mutex.release(); 
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log("wurde unterbrochen.");
            }
        }

        /**
         * Methode zum Verlassen des Mittelstücks (Erzeuger).
         */
        private void exit() {
            try {
                // Mutex holen, um Variablen sicher zu ändern
                mutex.acquire(); 
                
                // Runde an die andere Lok übergeben
                turn = 1 - id; 
                
                // Nachsehen, ob die andere Lok an der Weiche steht und schläft
                if (waiting[turn]) {
                    waiting[turn] = false; // Sie wartet nun nicht mehr
                    privSem[turn].release(); // Die andere Lok wecken
                }
                
                // Mutex wieder freigeben
                mutex.release(); 
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log("wurde unterbrochen.");
            }
        }

        /**
         * Hilfsmethode zur Berechnung und Ausführung der simulierten Fahrzeit.
         */
        private void sleepForSection(int length) {
            try {
                int sleepTimeMs = (length * 1000) / speedUnitPerSecond;
                Thread.sleep(sleepTimeMs);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt(); 
                System.out.println("Lok " + id + " wurde unterbrochen.");
            }
        }

        /**
         * Logger: Berechnet die vergangenen Sekunden seit Programmstart
         */
        private void log(String message) {
            long elapsedMs = System.currentTimeMillis() - startTime;
            double elapsedSeconds = elapsedMs / 1000.0;
            
            System.out.printf("[%7.3fs] Lok %d: %s%n", elapsedSeconds, id, message);
        }
    }

    public static void main(String[] args) {
        LoksPrivate loksPrivate = new LoksPrivate();
        
        int speedLok0 = 2; 
        int speedLok1 = 2;
        
        Lok lok0 = loksPrivate.new Lok(0, speedLok0);
        Lok lok1 = loksPrivate.new Lok(1, speedLok1);
        
        lok0.start();
        lok1.start();
    }
}