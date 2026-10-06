import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class CrackHashes {

    public static void main(String[] args) {
        String hashFilePath = "24sea-passwort_wiederherstellung-tasks/JavaHashcodes.txt";
        String wordlistPath = "wordlist.txt/rockyou.txt";
        
        Set<Integer> targetHashes = new HashSet<>();

        // 1. Hashes aus der Datei einlesen
        System.out.println("[*] Lade Hashcodes...");
        try (BufferedReader br = new BufferedReader(new FileReader(hashFilePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    targetHashes.add(Integer.parseInt(line));
                }
            }
        } catch (IOException e) {
            System.err.println("[-] Fehler beim Lesen der Hash-Datei: " + e.getMessage());
            return;
        }

        System.out.println("[+] " + targetHashes.size() + " eindeutige Hashes geladen.");

        Map<Integer, String> foundResults = new HashMap<>();

        // 2. rockyou.txt Zeile für Zeile durchgehen
        System.out.println("[*] Starte Wörterbuch-Attacke mit rockyou.txt...");
        
        // ISO_8859_1 (Latin-1) verhindert Abstürze bei Sonderzeichen in rockyou.txt
        try (BufferedReader br = new BufferedReader(new FileReader(wordlistPath, StandardCharsets.ISO_8859_1))) {
            String candidate;
            long count = 0;

            while ((candidate = br.readLine()) != null) {
                count++;
                
                // Javas eingebaute hashCode() Funktion nutzen
                int candidateHash = candidate.hashCode();

                if (targetHashes.contains(candidateHash)) {
                    if (!foundResults.containsKey(candidateHash)) {
                        foundResults.put(candidateHash, candidate);
                        System.out.printf("[SUCCESS] Hash: %-12d -> Passwort: '%s'%n", candidateHash, candidate);
                    }

                    // Abbrechen, wenn alle Hashes geknackt wurden
                    if (foundResults.size() == targetHashes.size()) {
                        System.out.println("[+] Alle Hashes erfolgreich wiederhergestellt!");
                        break;
                    }
                }

                // Fortschrittsanzeige alle 2 Millionen Wörter
                if (count % 2000000 == 0) {
                    System.out.println("[...] " + count + " Wörter geprüft...");
                }
            }
        } catch (IOException e) {
            System.err.println("[-] Fehler beim Lesen der Wortliste: " + e.getMessage());
            return;
        }

        System.out.println("\n[*] Fertig! " + foundResults.size() + " von " + targetHashes.size() + " Passwörtern gefunden.");
    }
}