# Wake
A Wake-on-Lan library in Swift

### Usage:
```swift
let computer = Wake.Device(MAC: "AA:AA:AA:AA:AA:AA", BroadcastAddr: "255.255.255.255", Port: 9)
Wake.target(device: computer)
```

## License
[MIT License](http://opensource.org/licenses/MIT)

## Author
Jesper Lindberg [@lindbergjesper](http://twitter.com/lindbergjesper/)
