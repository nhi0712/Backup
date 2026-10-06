import java.net.DatagramPacket;
import java.net.DatagramSocket;

public class Server {
    public static final int PORT = 4999;

    public static void main(String[] args) {
        try {
            DatagramSocket socket = new DatagramSocket(4999);
            byte[] buffer = new byte[1024];
            DatagramPacket packet = new DatagramPacket(buffer, buffer.length);

            while (true) {
            socket.receive(packet);
            String message = new String(packet.getData(), 0, packet.getLength());
            String senderIP = packet.getAddress().getHostAddress();
            System.out.println("Received message: " + message + " from " + senderIP);
        }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }


}
