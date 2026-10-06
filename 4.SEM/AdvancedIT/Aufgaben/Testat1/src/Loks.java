import java.util.concurrent.Semaphore;

public class Loks {

    // Semaphor für Lok 0: Startet mit 1 (darf als Erste in das gemeinsame Mittelstück)
    private Semaphore semLok0 = new Semaphore(1);
    
    // Semaphor für Lok 1: Startet mit 0 (muss zwingend warten, bis Lok 0 fertig ist)
    private Semaphore semLok1 = new Semaphore(0);
    
    // Streckenlängen
    private int criticalSectionLength = 5;
    private int privateSectionLength = 10;

    private final long startTime = System.currentTimeMillis();

    /**
     * Innere Klasse für die Lok-Threads.
     */
    public class Lok extends Thread {
        private int id;
        private int speedUnitPerSecond;
        
        // Semaphor-Referenz, auf das diese Lok warten muss (Verbraucher)
        private Semaphore ownSem;   
        // Semaphor-Referenz der anderen Lok, das beim Verlassen freigegeben wird (Erzeuger)
        private Semaphore otherSem; 

        public Lok(int id, int speedUnitPerSecond, Semaphore ownSem, Semaphore otherSem) {
            this.id = id;
            this.speedUnitPerSecond = speedUnitPerSecond;
            this.ownSem = ownSem;
            this.otherSem = otherSem;
        }

        @Override
        public void run() {
            log("startet ihre Fahrt, mit " + speedUnitPerSecond + " Einheiten pro Sekunde.");

            // Endlosschleife aus der Aufgabenstellung
            while(true) {
                log("erreicht die Weiche und wartet ggf.");
                
                // Eintritt in den kritischen Bereich (entspricht enterLok0() / enterLok1())
                enter(); 
                
                // Befahren des gemeinsamen Mittelstück
                log("befährt das gemeinsame Mittelstück.");
                sleepForSection(criticalSectionLength);
                
                log("verlässt das Mittelstück...");
                // Verlassen des kritischen Bereichs (entspricht exitLok0() / exitLok1())
                exit(); 
                
                // Befahren des eigenen Kreisabschnitts
                log("hat das Mittelstück verlassen und fährt auf dem eigenen Kreis.");
                sleepForSection(privateSectionLength);
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
                log("wurde unterbrochen.");
            }
        }

        /**
         * Methode zum Betreten des Mittelstücks (Verbraucher).
         */
        public void enter() {
            try {
                ownSem.acquire();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } 
        }

        /**
         * Methode zum Verlassen des Mittelstücks (Erzeuger).
         */
        public void exit() {
            otherSem.release();
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
        Loks loks = new Loks();
        
        // Initialisierung gemäß Aufgabe: 
        // Lok 0 wartet auf semLok0 und gibt semLok1 frei.
        Lok lok0 = loks.new Lok(0, 2, loks.semLok0, loks.semLok1);
        
        // Lok 1 wartet auf semLok1 und gibt semLok0 frei. (Fährt deutlich schneller).
        Lok lok1 = loks.new Lok(1, 2, loks.semLok1, loks.semLok0);

        // Threads starten
        lok0.start();
        lok1.start();
    }
}