import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.*;
import java.util.Scanner;

public class Client {
    public static void main(String[] args) {
        try {
            DatagramSocket socket = new DatagramSocket();
            InetAddress serverAddress = InetAddress.getByName("localhost");

            Scanner scanner = new Scanner(System.in);
            while (true) {
                String line = scanner.nextLine();
                byte[] buffer = line.getBytes();
                DatagramPacket packet = new DatagramPacket(buffer, buffer.length, serverAddress, 4999);
                socket.send(packet);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

    }


}
