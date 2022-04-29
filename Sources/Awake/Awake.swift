import Foundation

public class Awake {
    public struct Device {
        public init(MAC: String, BroadcastAddr: String, Port: UInt16 = 9) {
            self.MAC = MAC
            self.BroadcastAddr = BroadcastAddr
            self.Port = Port
        }
        
        var MAC: String
        var BroadcastAddr: String
        var Port: UInt16 = 9
    }
    
    public enum WakeError: Error {
        case SocketSetupFailed(reason: String)
        case SetSocketOptionsFailed(reason: String)
        case SendMagicPacketFailed(reason: String)
    }
    
    public static func target(device: Device) -> Error? {
        var sock: Int32
        var target = sockaddr_in()
        
        target.sin_family = sa_family_t(AF_INET)
        
        // Check Broadcast address (is an IP address or a domain name)
        var bcaddr = inet_addr(device.BroadcastAddr)
        if bcaddr == INADDR_NONE {
            bcaddr = inet_addr(gethostbyname(device.BroadcastAddr))
        }
        target.sin_addr.s_addr = bcaddr
        
        let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
        target.sin_port = isLittleEndian ? _OSSwapInt16(device.Port) : device.Port
        
        // Setup the packet socket
        sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 {
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SocketSetupFailed(reason: err)
        }
        
        let packet = Awake.createMagicPacket(mac: device.MAC)
        let sockaddrLen = socklen_t(MemoryLayout<sockaddr>.stride)
        let intLen = socklen_t(MemoryLayout<Int>.stride)
        
        // Set socket options
        var broadcast = 1
        if setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &broadcast, intLen) == -1 {
            close(sock)
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SetSocketOptionsFailed(reason: err)
        }
        
        // Send magic packet
        var targetCast = unsafeBitCast(target, to: sockaddr.self)
        if sendto(sock, packet, packet.count, 0, &targetCast, sockaddrLen) != packet.count {
            close(sock)
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SendMagicPacketFailed(reason: err)
        }
        
        close(sock)
        
        return nil
    }
    
    private static func createMagicPacket(mac: String) -> [CUnsignedChar] {
        var buffer = [CUnsignedChar]()
        
        // Create header
        for _ in 1...6 {
            buffer.append(0xFF)
        }
        
        let components = mac.components(separatedBy: ":")
        let numbers = components.map {
            return strtoul($0, nil, 16)
        }
        
        // Repeat MAC address 20 times
        for _ in 1...20 {
            for number in numbers {
                buffer.append(CUnsignedChar(number))
            }
        }
        
        return buffer
    }
}
