    import XCTest
    @testable import Awake

    final class AwakeTests: XCTestCase {
        func wakeMyMachine() {
            // IMPORTANT! replace mac addr with yours, and in terminal run this command 'nc -ul 9'
            let device = Awake.Device(MAC: "18:c0:4d:a2:ba:8a", BroadcastAddr: "255.255.255.255")
            let _ = Awake.target(device: device)
        }
    }
